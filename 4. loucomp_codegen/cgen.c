/****************************************************/
/* File: cgen.c                                     */
/* The code generator implementation                */
/* for the TINY compiler                            */
/* (generates code for the TM machine)              */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "symtab.h"
#include "code.h"
#include "cgen.h"

#define ADDRESS		1
#define VALUE		0
static int getInfo = 0;
static int saved_config = FALSE;
static int siblingRecur = TRUE;
static char * currentFuncName = NULL;
static int currentScope = 0;
static int isCall = FALSE;

int globalIndex = 0;
typedef struct varNode
  {
    char * name;
    int index;
    struct varNode *next;
  } VarNode;
static VarNode * globalVars = NULL;

static void push_global (char * name)
{
  VarNode * v = (VarNode *)malloc(sizeof(VarNode));
  v->name = copyString(name);
  v->index = globalIndex++;

  v->next = globalVars;
  globalVars = v;
}

static void traverseGlobal(TreeNode * root)
{
  if (root == NULL)
    return;

  if (root->nodekind == StmtK) {
    if ((root->kind.stmt == VarDecK) || (root->kind.stmt == ArrayDecK))
      push_global(root->attr.name);
  }

  traverseGlobal (root->sibling);
}

static int isGlobalVar(TreeNode * t)
{
  VarNode * v = globalVars;
  if (t->declNode->scope == 0) {
    while (v != NULL) {
      if (strcmp(v->name, t->attr.name) ==0)
        return TRUE;
      v = v->next;
    }
  }
  return FALSE;
}

typedef struct funcInfo
  {
    char * name;
    int para_num;
    int var_num;

    int inst_addr;

    TreeNode * dec;
    VarNode * vars;
    VarNode * params;
    struct funcInfo * next;
  } FuncInfo;
static FuncInfo * functionList = NULL;

typedef struct stackFrame
  { 
    FuncInfo * info;
    struct stackFrame * next;
  } StackFrame;
static StackFrame * stackList = NULL;

static StackFrame * makeStackFrame(FuncInfo * f)
{
  StackFrame * frame = (StackFrame *)malloc(sizeof(StackFrame));
  frame->info = f;
  return frame;
}

static void push_stack (StackFrame * st)
{
  st->next = stackList;
  stackList = st;
}

static void pop_stack (void)
{
  if (stackList != NULL)
    stackList = stackList->next;  
}

static FuncInfo * lookup_FuncInfo(char * name)
{
   FuncInfo * ret = functionList;
   while (ret != NULL)
   {
     if (strcmp(ret->name, name) == 0)
       return ret;
     ret = ret->next;
   }
   return NULL;
}

static int offset(char * name)
{
  FuncInfo * f = lookup_FuncInfo(currentFuncName);
  VarNode * vTmp;

  if (f != NULL)
  {
    /* find variable */
    vTmp = f->vars;
    while (vTmp != NULL) {
      if (strcmp(vTmp->name, name) == 0) {
        return vTmp->index;
      }
      vTmp = vTmp->next;
    }
    /* or find parameters */
    vTmp = f->params;
    while (vTmp != NULL) {
      if (strcmp(vTmp->name, name) == 0) {
      	return vTmp->index;
      }
      vTmp = vTmp->next;
    }
  }
  return -1;
}

static int isParam(char * name)
{
  int ret;
  int ofs = offset(name); 
  if (ofs == -1)
    return -1;

  FuncInfo * f = lookup_FuncInfo(currentFuncName);
  VarNode * params = f->params;
  while (params != NULL) {
    if (strcmp(params->name, name) == 0)
      return TRUE;
    params = params->next; 
  }
  return FALSE;
}

static void push_func(FuncInfo * f)
{
  f->next = functionList;
  functionList = f;
}

static void pop_func(void)
{
  if (functionList != NULL)
    functionList = functionList->next;
}

static void push_var(VarNode * node, VarNode * vars)
{
  node->next = vars;
  vars = node;
}

/* dec must be a function declaration.
 */
static FuncInfo * makeFuncInfo (TreeNode * dec)
{
  if (dec == NULL)
    printf("dec is null in makeFuncInfo");

  int index = 0;
  TreeNode * tmp;
  VarNode * vTmp;
  TreeNode * params;
  TreeNode * compound_stmt;
  TreeNode * local_declarations;

  /* Construct a frame. */
  FuncInfo * info = (FuncInfo *)malloc(sizeof(FuncInfo));
  info->dec = dec;
  info->name = copyString(dec->attr.name);
  info->inst_addr = emitSkip(0);


  /* pre-defined functions processing. */
  if (strcmp(dec->attr.name, "input") == 0) {
    info->var_num = 0; info->vars = NULL;
    info->para_num = 0;info->params = NULL;
    return info;
  } else if (strcmp(dec->attr.name, "output") == 0) {
    info->var_num = 0; info->vars = NULL;
    info->para_num = 1;
    vTmp = (VarNode *)malloc(sizeof(VarNode));
    vTmp->index = 0;
    vTmp->name = copyString(dec->child[0]->attr.name);

    if (info->params == NULL)
      info->params = vTmp;
    else
    { vTmp->next = info->params;
      info->params = vTmp;
    }
    return info;
  }

  /* Declaration Info */
  params = dec->child[0];
  compound_stmt = dec->child[1];
  local_declarations = compound_stmt->child[0];

  /* Insert parameters into vars list. */
  if (params->type == Void)
    info->para_num = 0;  
  else {
    tmp = params;
    while (tmp != NULL) { 
      info->para_num ++;
      vTmp = (VarNode *)malloc(sizeof(VarNode));
      vTmp->index = index++;
      vTmp->name = copyString(tmp->attr.name);

      if (info->params == NULL)
        info->params = vTmp;
      else
      { vTmp->next = info->params;
        info->params = vTmp;
      }
      //push_var(vTmp, info->params);
      tmp = tmp->sibling;
    }
  }

  /* Insert var declarations into vars list. */
  if (local_declarations == NULL)
    info->var_num = 0;
  else {
    index = 0;
    tmp = local_declarations;
    while (tmp != NULL)
    {
      info->var_num ++; 
      vTmp = (VarNode *)malloc(sizeof(VarNode));
      vTmp->index = index++;
      vTmp->name = copyString(tmp->attr.name);

      if (info->vars == NULL)
        info->vars = vTmp;
      else
      { vTmp->next = info->vars;
        info->vars = vTmp;
      }
      //push_var(vTmp, info->vars);
      tmp = tmp->sibling;
    }
  }
  return info;
}

static void push_reg(int reg, char *str) {
  emitRM("LDA", sp, -1, sp, str); // sp = sp - 1
  emitRM("ST", reg, 0, sp, "");
}

static void pop_reg(int reg, char *str) {
  emitRM("LDA", sp, 1, sp, str); // sp = sp + 1
  emitRM("LD", reg, -1, sp, "");
}

static void func_head(char * name) {
  FuncInfo * f = lookup_FuncInfo(name);
  int address = emitSkip(0);
  int size = f->var_num;

  emitComment("-> function declaration head");
  push_reg(bp, "PUSH BP");
  emitRM("LDA", bp, 0, sp, "MOV BP, SP");
  emitRM("LDA", sp, -size, sp, "SP -= Varaiable number");
  emitComment("<- function declaration head");
}

static void func_return()
{
  if (TraceCode) emitComment("-> function declaration tail");
  emitRM("LDA", sp, 0, bp, "MOV SP, BP");
  pop_reg(bp, "POP BP");
  pop_reg(pc, "RETRN; POP PC"); // RETURN PC
  if (TraceCode) emitComment("<- function declaration tail");
}

static void call (FuncInfo * f) {
  char * name = f->name;
  int inst_addr = f->inst_addr;
  int arg_num = f->para_num;
  int var_num = f->var_num; 

  emitComment("-> call (internal)");
  emitComment(name);
  emitRM("LDA", ac, 3, pc, "ac=pc+3 (next pc)");
  push_reg(ac, "PUSH AC (return address)");
  emitRM("LDC", pc, inst_addr, zero, "pc=address (jmp to called function)");
  emitRM("LDA", sp, arg_num, sp, "sp=sp+arg_num");
  emitComment("<- call (internal)");
}

/* tmpOffset is the memory offset for temps
   It is decremented each time a temp is
   stored, and incremeted when loaded again
*/
static int tmpOffset = 0;

/* prototype for internal recursive code generator */
static void cGen (TreeNode * tree);

/* Procedure genStmt generates code at a statement node */
static void genStmt( TreeNode * tree) {
  int savedLoc1,savedLoc2,currentLoc;
  int loc;
  switch (tree->kind.stmt) {

      case IfK :
         if (TraceCode) emitComment("-> if") ;
         /* generate code for test expression */
         cGen(tree->child[0]); // value in ac
         savedLoc1 = emitSkip(1) ;
         emitComment("if: conditional jump to else");

         /* recurse on then part */
         cGen(tree->child[1]);  
         savedLoc2 = emitSkip(1) ;
         emitComment("if: unconditional jmp to end");

         currentLoc = emitSkip(0) ;
         emitBackup(savedLoc1) ;
         emitRM_Abs("JEQ",ac,currentLoc,"if: if ac==0, pc=addr of else");
         emitRestore();

         /* recurse on else part */
         cGen(tree->child[2]);
         currentLoc = emitSkip(0) ;
         emitBackup(savedLoc2) ;
         emitRM_Abs("LDA",pc,currentLoc,"if: pc=addr of endif") ;
         emitRestore();
         if (TraceCode)  emitComment("<- if") ;
         break; /* if_k */

      // Note: it doesn't process case 'array(address) = array(address)' 
      case AssignK:
      	 if (TraceCode) emitComment("-> assign");

      	 getInfo = ADDRESS;
      	 cGen(tree->child[0]);
      	 push_reg(ac, "push ac"); // push ac

         getInfo = VALUE;
      	 cGen(tree->child[1]);
      	 pop_reg (ac1, "pop ac1"); // pop ac1

      	 /* At left side's address, assign right side's value */
      	 emitRM("ST", ac, 0, ac1, "dMem[ac1]=ac"); 
      	 
      	 if (TraceCode) emitComment("<- assign");
      	 break;

      case ParamK:
      case VarDecK:
      case ArrayDecK:
         // do nothing
      	 break;

      case FuncDecK:
         currentFuncName = copyString(tree->attr.name);

      	 emitComment("-> function declaration");
      	 emitComment(tree->attr.name);

	 push_func(makeFuncInfo(tree));
      	 func_head(tree->attr.name);
      	 cGen(tree->child[1]);
      	 func_return();

      	 emitComment("-> function declaration");
      	 break;

      case ComK:
      	 emitComment("-> compound");
      	 cGen(tree->child[1]);
      	 emitComment("<- compound");
      	 break;

      case WhileK:
      	 emitComment("-> while");
      	 savedLoc1 = emitSkip(0);
      	 emitComment("while: comes back here after body");
      	 cGen(tree->child[0]);
      	 savedLoc2 = emitSkip(1);
      	 emitComment("while: conditional jmp to end");
      	 cGen(tree->child[1]);
      	 emitRM("LDC", pc, savedLoc1, zero, "while: go back; pc=addr of condition");

      	 currentLoc = emitSkip(0);
      	 emitBackup(savedLoc2);
      	 emitRM("JEQ", ac, currentLoc, zero, "while: if ac==0, pc=addr of endwhile");
      	 emitRestore();
      	 emitComment("<- while");
      	 break;

      case ReturnK:
      	 emitComment("-> return");
         if ((tree->child[0] != NULL) &&
             (tree->child[0]->type == Integer))
           cGen(tree->child[0]);
         func_return();
      	 emitComment("<- return");
      	 break;

      default:
         break;
    }
} /* genStmt */

/* emit one instruction to get the addresss of a variable. */
void emitGetAddr(TreeNode * var)
{
  int isPar = isParam(var->attr.name);
  int isGlob = isGlobalVar(var);
  int ofs = offset(var->attr.name);
  if (isGlob == FALSE && ofs == -1) {
    printf("%s\n", var->attr.name);
    printf("some error! in emitGetAddr\n");
    return;
  }

  emitComment("-> get address of variable");
  /* If this variable is parameter */
  if (isPar == TRUE) {
    if (var->type == Integer) {
      emitRM("LDA", ac, ofs+2, bp, "ac=bp+offset+2");
    } else if (var->type == IntegerArray) {
      emitRM("LD", ac, ofs+2, bp, "ac=dMem[bp+offset+2]");
    }
  /* If this variable is local or global variable. */
  } else {
    if (var->nodekind == ExpK) {
      switch (var->kind.exp) {
        case IdK:
        case IdArrayK:
          /* global - using gp */
          if (isGlobalVar(var))
       	  //if (var->declNode->scope == 0)
            emitRM("LDA", ac, -ofs, gp, "ac=gp-offset");
          /* local - using bp */
  	  else
  	    emitRM("LDA", ac, -1-ofs, bp, "ac=bp-offset-1");
  	  break;
        default:
          break;
      } 
    }
  }
  emitComment("<- get address of variable");
} /* emitGetAddr */

void emitRelop(char * op)
{
  emitRO("SUB", ac, ac1, ac, "reg[ac]=reg[ac1]-reg[ac]");
  emitRM(op, ac, 2, pc, "conditional jmp: if true");
  emitRM("LDC", ac, 0, ac, "ac=0 (false case");
  emitRM("LDA", pc, 1, pc, "unconditional jmp");
  emitRM("LDC", ac, 1, ac, "ac=1 (true case");
}

/* Procedure genExp generates code at an expression node */
static void genExp( TreeNode * tree)
{ int loc;
  switch (tree->kind.exp) {

    case ConstK :
      emitComment("-> Const") ;
      emitRM("LDC",ac,tree->attr.val,zero,"ac=const value");
      emitComment("<- Const") ;
      break;
    
    case IdK :
      emitComment("-> Id") ;
      emitGetAddr(tree); // reg[ac]=address of var
      if (getInfo == VALUE)
        emitRM("LD", ac, 0, ac, "ac=dMem[ac]");
      emitComment("<- Id") ;
      break;

    case IdArrayK:
      emitComment("-> Array Id");
      emitGetAddr(tree);
      saved_config = getInfo;
      getInfo = ADDRESS;
      cGen(tree->child[0]);
      getInfo = saved_config;
      pop_reg(ac, "POP AC");
      emitRO("SUB", ac, ac1, ac, "ac=ac1-ac (array offset)");
      emitComment("<- Array Id");
      break;

    case OpK :
         emitComment("-> Op") ;
         getInfo = VALUE;
         cGen(tree->child[0]);
         push_reg(ac, "PUSH AC");

         getInfo = VALUE;
         cGen(tree->child[1]);
         pop_reg(ac1, "POP AC1");

         switch (tree->attr.op) {
            case PLUS :
               emitRO("ADD",ac,ac1,ac,"reg[ac]=reg[ac1] + reg[ac]");
               break;
            case MINUS :
               emitRO("SUB",ac,ac1,ac,"reg[ac]=reg[ac1] - reg[ac]");
               break;
            case TIMES :
               emitRO("MUL",ac,ac1,ac,"reg[ac]=reg[ac1] * reg[ac]");
               break;
            case OVER :
               emitRO("DIV",ac,ac1,ac,"reg[ac]=reg[ac1] / reg[ac]");
               break;
            case EQ : emitRelop("JEQ"); break;
            case NEQ: emitRelop("JNE"); break;
            case LG : emitRelop("JGT"); break;
            case LE : emitRelop("JGE"); break;
            case SM : emitRelop("JLT"); break;
            case SE : emitRelop("JLE"); break;
               
            default:
               emitComment("BUG: Unknown operator");
               break;
         } /* case op */
         emitComment("<- Op") ;
         break; /* OpK */

      case CallK:
         isCall = TRUE;
      	 emitComment("-> call");
      	 emitComment(tree->attr.name);

         TreeNode * p = tree->child[0]; // arguments
         while (p != NULL) {
           pushParam(p);
           p = p->sibling;
	 }

      	 /* push parameters */
         siblingRecur = FALSE;
      	 while ((p=popParam()) != NULL) {
           getInfo = VALUE;
           cGen(p); 
           push_reg (ac, "PUSH AC (for argument)");
         }
         siblingRecur = TRUE;
      	
      	 /* emit instructions for call */
      	 FuncInfo * f = lookup_FuncInfo(tree->attr.name); 
      	 call (f);
      	 emitComment("<- call");
      	 break;

    default:
      break;
  }
} /* genExp */

/* Procedure cGen recursively generates code by
 * tree traversal
 */
static void cGen( TreeNode * tree)
{ if (tree != NULL)
  { 
    switch (tree->nodekind) {
      case StmtK:
        genStmt(tree);
        break;
      case ExpK:
        genExp(tree);
        break;
      default:
        break;
    }
    if (siblingRecur == TRUE)
      cGen(tree->sibling);
  }
}

/* after this function called, 
 * reg[zero] = 0
 * reg[gp] = max address of memory
 * reg[sp] = max address - (global variable number + 1)
 */
static void codeGenInit(void) {
  int size = get_global_var_num();

  emitComment("-> init zero, gp, sp");
  emitRM("LDC",zero,0,zero, "reg[zero]=0 (init zero)");
  emitRM("LD", gp, 0, zero, "gp=dMem[0] (dMem[0]==maxaddress)");
  emitRM("ST", zero, 0, zero, "dMem[0]=0 (clear location 0)");
  emitRM("LDA", sp, -size+1, gp, "sp=gp-global_var_num+1");
  emitComment("<- init zero, gp, sp");
}

static void codeGenInput(void) {
  emitComment("-> pre-defined function: input");

  TreeNode * inputTree = st_func_lookup("input");
  FuncInfo * funcInfo = makeFuncInfo(inputTree);
  funcInfo->inst_addr = emitSkip(0);

  if ((inputTree != NULL) && (funcInfo != NULL))
    push_func(funcInfo);
  else 
    exit (-1);

  func_head("input");
  emitRO("IN", ac, zero, zero, "input ac");
  func_return();
  emitComment("<- pre-defined function: input");
}

static void codeGenOutput(void) {
  emitComment("-> pre-defined function: output");

  TreeNode * outputTree = st_func_lookup("output");
  FuncInfo * funcInfo = makeFuncInfo(outputTree);
  funcInfo->inst_addr = emitSkip(0);

  if ((outputTree != NULL) && (funcInfo != NULL))
    push_func(funcInfo);
  else 
    exit (-1);

  func_head("output");
  emitRM("LD", ac, 2, bp, "ac=dMem[bp+2] (param 0)");
  emitRO("OUT", ac, zero, zero, "output ac");
  func_return();
  emitComment("<- pre-defined function: output");
}

/**********************************************/
/* the primary function of the code generator */
/**********************************************/
/* Procedure codeGen generates code to a code
 * file by traversal of the syntax tree. The
 * second parameter (codefile) is the file name
 * of the code file, and is used to print the
 * file name as a comment in the code file
 */
void codeGen(TreeNode * syntaxTree, char * codefile)
{ char * s = malloc(strlen(codefile)+7);
  int mainLoc;
  strcpy(s,"File: ");
  strcat(s,codefile);

  /* Instruction comment */
  emitComment("C-MINUS Compilation to TM Code");
  emitComment(s);
  codeGenInit();

  /* jmp to main, call main, halt. */
  emitComment("skip 5 instr: call main, waiting for addr of main");
  mainLoc = emitSkip(5);
  emitRO("HALT", zero, zero, zero, "stop program");

  /* define pre-defined functions: input, output */
  codeGenInput();
  codeGenOutput();

  traverseGlobal(syntaxTree);
  /* generate code for TINY program */
  cGen(syntaxTree);

  /* backpatch address of main */
  emitBackup(mainLoc);
  call(lookup_FuncInfo("main"));
  emitRestore();

  emitComment("END OF C-MINUS Compilation to TM Code");
}
