/****************************************************/
/* File: analyze.c                                  */
/* Semantic analyzer implementation                 */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "symtab.h"
#include "analyze.h"
#include "parse.h"

/* counter for variable memory locations */
static int location = 0;
static int scope = 0;

/* Procedure traverse is a generic recursive 
 * syntax tree traversal routine:
 * it applies preProc in preorder and postProc 
 * in postorder to tree pointed to by t
 */
static void traverse( TreeNode * t,
               void (* preProc) (TreeNode *),
               void (* postProc) (TreeNode *) )
{ if (t != NULL)
  { preProc(t);
    { int i;
      for (i=0; i < MAXCHILDREN; i++)
        traverse(t->child[i],preProc,postProc);
    }
    postProc(t);
    traverse(t->sibling,preProc,postProc);
  }
}

/* If NODE is a node for declaration,
 * This function returns TRUE.
 */
int isDeclaration(TreeNode * node)
{
  if (node->nodekind == StmtK)
  {
    if ((node->kind.stmt == VarDecK) ||
        (node->kind.stmt == FuncDecK) ||
        (node->kind.stmt == ArrayDecK))
      return TRUE;
  }
  
  return FALSE;
}

/* nullProc is a do-nothing procedure to 
 * generate preorder-only or postorder-only
 * traversals from traverse
 */
static void nullProc(TreeNode * t)
{ if (t==NULL) return;
  else return;
}

/* Procedure insertNode inserts 
 * identifiers stored in t into 
 * the symbol table 
 */
static void insertNode(TreeNode * t)
{
  BucketList lookupSymbol;
  static TreeNode * currentFunc = NULL; /* to match return statement. */

  if (t->nodekind == StmtK)
  {
    switch(t->kind.stmt)
    {
    /* Compound statment increments location(nested level) */
    case ComK: location ++;
      break;
    /* Parameter takes current scope, and 
     * its location is always 1. */
    case ParamK:
      t->scope = scope;
      t->loc = 1;
      break;
    /* Variable declaration takes current scope and location */
    case VarDecK:
    case ArrayDecK:
      t->scope = scope;
      t->loc = location;
      break;
    /* Function declaration increments scope and
     * initializes location(nested level) */
    case FuncDecK:
      scope ++;
      location = 0;
      t->scope = 0;
      t->loc = 0;
      currentFunc = t;
      break;
    case ReturnK:
      t->declNode = currentFunc;
      break;
    default:
      break;
    }
  }
  
  if (t->nodekind == StmtK)
  {
    /* Lookup symbol table before inserting into the table */
    switch(t->kind.stmt)
    {
    case ParamK:
      if (t->type != Void)
      {
        if (st_lookup(t->attr.name, t) == NULL)
          st_insert(t->attr.name, t->lineno, t);
        else
        { fprintf(listing, "duplicate parameter name: %s at line %d\n", t->attr.name, t->lineno);
          exit (-1); }
      }
      break;
    case VarDecK:
    case ArrayDecK:
    case FuncDecK:
      if (st_lookup(t->attr.name, t) == NULL)
        st_insert(t->attr.name, t->lineno, t);
      else
      { fprintf(listing, "duplicate declaration: %s at line %d\n", t->attr.name, t->lineno);
      	exit (-1); }
      break;
    default:
      break;
    }
  }

  if ((t->nodekind == ExpK) &&
      ((t->kind.exp == IdK) || (t->kind.exp == IdArrayK) || (t->kind.exp == CallK)))
  {
    t->scope = scope;
    t->loc = location;
    lookupSymbol = st_lookup(t->attr.name, t);
    if (lookupSymbol == NULL)
    { fprintf(listing, "identifier \"%s\" unknown", t->attr.name);
      fprintf(listing, " or out of scope,location: line(%d)\n",t->lineno);
      exit (-1);
    }
    else
    {
      LineList curLine = lookupSymbol->lines;
      LineList nextLine = (LineList) malloc(sizeof(struct LineListRec));
      nextLine->lineno = t->lineno;
      while (1)
      {
      	if (curLine->next == NULL)
	{
          curLine->next = nextLine;
          break;
	}
	else
          curLine = curLine->next;
      }
      t->declNode = lookupSymbol->node;
    }
  }
}

/* function like input, output... 
 * These function are pre-defined functions.
 * setPreDefFunc makes it possible to use them.
 */
static void definePreDefFunc(void)
{ 
  TreeNode *input;
  TreeNode *output;
  TreeNode *param; 

  /* int input(void); */
  input = newStmtNode(FuncDecK);
  input->attr.name = copyString("input");
  input->type = Integer;

  param = newStmtNode(ParamK);
  param->attr.name = copyString("arg");
  param->type = Integer;

  /* void output(int); */
  output = newStmtNode(FuncDecK);
  output->attr.name = copyString("output");
  output->type = Void;
  output->child[0] = param;

  st_insert("input", 0, input);
  st_insert("output", 0, output);
}

/* Function buildSymtab constructs the symbol 
 * table by preorder traversal of the syntax tree
 */
void buildSymtab(TreeNode * syntaxTree)
{
  definePreDefFunc();
  traverse(syntaxTree,insertNode,nullProc);
  if (TraceAnalyze)
  { fprintf(listing,"\nSymbol table:\n\n");
    printSymTab(listing);
  }
}

static void typeError(TreeNode * t, char * message)
{ fprintf(listing,"Type error at line %d: %s\n",t->lineno,message);
  Error = TRUE;
}

/* It tries to match types between each parameter and argument.
 * If there are some dismatches between them, the arguments of
 * the call statement were used not properly.
 */
static int checkArgs(TreeNode *dec, TreeNode *call)
{
  if (dec == NULL)
    return FALSE;

  TreeNode *param = dec->child[0];
  TreeNode *arg = call->child[0];

  while ((param != NULL) && (arg != NULL))
  {
    if (param->type == arg->type)
    {
      param = param->sibling;
      arg = arg->sibling;
    }
    /* If the types are not matched. */
    else
    {
      return FALSE;
    }
  }

  /* the number of parameters and arguments are not same. */
  if (((param == NULL) && (arg != NULL)) || 
      ((param != NULL) && (arg == NULL)))
  {
    return FALSE;
  }

  return TRUE;
}

/* Procedure checkNode performs
 * type checking at a single tree node
 */
static void checkNode(TreeNode * t)
{
  switch (t->nodekind)
  { case ExpK:
      switch (t->kind.exp)
      { case OpK:
      	  if (isAddop(t->attr.op) || isMulop(t->attr.op))
	  {
	    if ((t->child[0]->type == Integer) &&
	        (t->child[1]->type == Integer))
	      t->type = Integer;
	    else
	      typeError(t,"arithmetic operation with non-integers");
	  }
	  else if (isRelop(t->attr.op))
	  {
	    if ((t->child[0]->type == Integer) &&
	        (t->child[1]->type == Integer))
	      t->type = Integer;
	    else
	      typeError(t,"relative operation with non-integers");
	  }
	  else
	    typeError(t,"unknown operation");
	  break;
        case IdK:
	  if (t->child[0] == NULL)
	  {
	    t->type = Integer;

	    BucketList tmp = st_lookup(t->attr.name, t);
	    if (tmp != NULL)
	    { 
	      if(tmp->node->type == IntegerArray)
	        t->type = IntegerArray;
	    }
	  }
	  else
	    typeError(t,"an integer-identifier cannot have its index");
	  break;
        case IdArrayK:
	  if (t->child[0] == NULL)
	    t->type = IntegerArray;
	  else
	  {
            if (t->child[0]->type == Integer)
              t->type = Integer;
	    else
	      typeError(t,"array must have an scalar index");
	  }
          break;
	case CallK:
	  if (checkArgs(t->declNode, t) == FALSE)
	    typeError(t,"parameters and arguments don't match");
	  else
	    t->type = t->declNode->type;
	  break;
        case ConstK:
          t->type = Integer;
          break;
        default:
          break;
      }
      break; /* Case ExpK */
    case StmtK:
      switch (t->kind.stmt)
      { case IfK:
          if (t->child[0]->type != Integer)
            typeError(t->child[0],"if test is not an integer");
          break;
        case AssignK:
          if ((t->child[0]->type == Integer) &&
              (t->child[1]->type == Integer))
            t->type = Integer;
          else
            typeError(t->child[0],"assignment of non-integer value");
          break;
        case WhileK:
          if (t->child[0]->type != Integer)
            typeError(t,"while-condition must be an integer");
          break;
        case ReturnK:
          if (t->declNode->type == Integer)
	  {
	    if ((t->child[0] == NULL) || (t->child[0]->type != Integer))
	      typeError(t->child[0],"not expected return value type");
	  }
	  else if (t->declNode->type == Void)
	  {
	    if (t->child[0] != NULL)
	      typeError(t->child[0],"not expected return value type");
	  }
	  break;
        case ComK:
          t->type = Void;
          break;
        default:
          break;
      }
      break; /* case StmtK */
    default:
      break;
  }
}


/* Procedure typeCheck performs type checking 
 * by a postorder syntax tree traversal
 */
void typeCheck(TreeNode * syntaxTree)
{ traverse(syntaxTree,nullProc,checkNode);
}

