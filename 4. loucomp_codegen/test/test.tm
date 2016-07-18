* C-MINUS Compilation to TM Code
* File: test/test.tm
* -> init zero, gp, sp
  0:    LDC  0,0(0) 	reg[zero]=0 (init zero)
  1:     LD  5,0(0) 	gp=dMem[0] (dMem[0]==maxaddress)
  2:     ST  0,0(0) 	dMem[0]=0 (clear location 0)
  3:    LDA  6,1(5) 	sp=gp-global_var_num+1
* <- init zero, gp, sp
* skip 5 instr: call main, waiting for addr of main
  9:   HALT  0,0,0 	stop program
* -> pre-defined function: input
* -> function declaration head
 10:    LDA  6,-1(6) 	PUSH BP
 11:     ST  4,0(6) 	
 12:    LDA  4,0(6) 	MOV BP, SP
 13:    LDA  6,0(6) 	SP -= Varaiable number
* <- function declaration head
 14:     IN  1,0,0 	input ac
* -> function declaration tail
 15:    LDA  6,0(4) 	MOV SP, BP
 16:    LDA  6,1(6) 	POP BP
 17:     LD  4,-1(6) 	
 18:    LDA  6,1(6) 	RETRN; POP PC
 19:     LD  7,-1(6) 	
* <- function declaration tail
* <- pre-defined function: input
* -> pre-defined function: output
* -> function declaration head
 20:    LDA  6,-1(6) 	PUSH BP
 21:     ST  4,0(6) 	
 22:    LDA  4,0(6) 	MOV BP, SP
 23:    LDA  6,0(6) 	SP -= Varaiable number
* <- function declaration head
 24:     LD  1,2(4) 	ac=dMem[bp+2] (param 0)
 25:    OUT  1,0,0 	output ac
* -> function declaration tail
 26:    LDA  6,0(4) 	MOV SP, BP
 27:    LDA  6,1(6) 	POP BP
 28:     LD  4,-1(6) 	
 29:    LDA  6,1(6) 	RETRN; POP PC
 30:     LD  7,-1(6) 	
* <- function declaration tail
* <- pre-defined function: output
* -> function declaration
* gcd
* -> function declaration head
 31:    LDA  6,-1(6) 	PUSH BP
 32:     ST  4,0(6) 	
 33:    LDA  4,0(6) 	MOV BP, SP
 34:    LDA  6,0(6) 	SP -= Varaiable number
* <- function declaration head
* -> compound
* -> if
* -> Op
* -> Id
* -> get address of variable
 35:    LDA  1,3(4) 	ac=bp+offset+2
* <- get address of variable
 36:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 37:    LDA  6,-1(6) 	PUSH AC
 38:     ST  1,0(6) 	
* -> Const
 39:    LDC  1,0(0) 	ac=const value
* <- Const
 40:    LDA  6,1(6) 	POP AC1
 41:     LD  2,-1(6) 	
 42:    SUB  1,2,1 	reg[ac]=reg[ac1]-reg[ac]
 43:    JEQ  1,2(7) 	conditional jmp: if true
 44:    LDC  1,0(1) 	ac=0 (false case
 45:    LDA  7,1(7) 	unconditional jmp
 46:    LDC  1,1(1) 	ac=1 (true case
* <- Op
* if: conditional jump to else
* -> return
* -> Id
* -> get address of variable
 48:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
 49:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
* -> function declaration tail
 50:    LDA  6,0(4) 	MOV SP, BP
 51:    LDA  6,1(6) 	POP BP
 52:     LD  4,-1(6) 	
 53:    LDA  6,1(6) 	RETRN; POP PC
 54:     LD  7,-1(6) 	
* <- function declaration tail
* <- return
* if: unconditional jmp to end
 47:    JEQ  1,8(7) 	if: if ac==0, pc=addr of else
* -> return
* -> call
* gcd
* -> Op
* -> Id
* -> get address of variable
 56:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
 57:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 58:    LDA  6,-1(6) 	PUSH AC
 59:     ST  1,0(6) 	
* -> Op
* -> Op
* -> Id
* -> get address of variable
 60:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
 61:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 62:    LDA  6,-1(6) 	PUSH AC
 63:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 64:    LDA  1,3(4) 	ac=bp+offset+2
* <- get address of variable
 65:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 66:    LDA  6,1(6) 	POP AC1
 67:     LD  2,-1(6) 	
 68:    DIV  1,2,1 	reg[ac]=reg[ac1] / reg[ac]
* <- Op
 69:    LDA  6,-1(6) 	PUSH AC
 70:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 71:    LDA  1,3(4) 	ac=bp+offset+2
* <- get address of variable
 72:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 73:    LDA  6,1(6) 	POP AC1
 74:     LD  2,-1(6) 	
 75:    MUL  1,2,1 	reg[ac]=reg[ac1] * reg[ac]
* <- Op
 76:    LDA  6,1(6) 	POP AC1
 77:     LD  2,-1(6) 	
 78:    SUB  1,2,1 	reg[ac]=reg[ac1] - reg[ac]
* <- Op
 79:    LDA  6,-1(6) 	PUSH AC (for argument)
 80:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 81:    LDA  1,3(4) 	ac=bp+offset+2
* <- get address of variable
 82:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 83:    LDA  6,-1(6) 	PUSH AC (for argument)
 84:     ST  1,0(6) 	
* -> call (internal)
* gcd
 85:    LDA  1,3(7) 	ac=pc+3 (next pc)
 86:    LDA  6,-1(6) 	PUSH AC (return address)
 87:     ST  1,0(6) 	
 88:    LDC  7,31(0) 	pc=address (jmp to called function)
 89:    LDA  6,2(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> function declaration tail
 90:    LDA  6,0(4) 	MOV SP, BP
 91:    LDA  6,1(6) 	POP BP
 92:     LD  4,-1(6) 	
 93:    LDA  6,1(6) 	RETRN; POP PC
 94:     LD  7,-1(6) 	
* <- function declaration tail
* <- return
 55:    LDA  7,39(7) 	if: pc=addr of endif
* <- if
* <- compound
* -> function declaration tail
 95:    LDA  6,0(4) 	MOV SP, BP
 96:    LDA  6,1(6) 	POP BP
 97:     LD  4,-1(6) 	
 98:    LDA  6,1(6) 	RETRN; POP PC
 99:     LD  7,-1(6) 	
* <- function declaration tail
* -> function declaration
* -> function declaration
* main
* -> function declaration head
100:    LDA  6,-1(6) 	PUSH BP
101:     ST  4,0(6) 	
102:    LDA  4,0(6) 	MOV BP, SP
103:    LDA  6,-2(6) 	SP -= Varaiable number
* <- function declaration head
* -> compound
* -> assign
* -> Id
* -> get address of variable
104:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
105:    LDA  6,-1(6) 	push ac
106:     ST  1,0(6) 	
* -> call
* input
* -> call (internal)
* input
107:    LDA  1,3(7) 	ac=pc+3 (next pc)
108:    LDA  6,-1(6) 	PUSH AC (return address)
109:     ST  1,0(6) 	
110:    LDC  7,10(0) 	pc=address (jmp to called function)
111:    LDA  6,0(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
112:    LDA  6,1(6) 	pop ac1
113:     LD  2,-1(6) 	
114:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
115:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
116:    LDA  6,-1(6) 	push ac
117:     ST  1,0(6) 	
* -> call
* input
* -> call (internal)
* input
118:    LDA  1,3(7) 	ac=pc+3 (next pc)
119:    LDA  6,-1(6) 	PUSH AC (return address)
120:     ST  1,0(6) 	
121:    LDC  7,10(0) 	pc=address (jmp to called function)
122:    LDA  6,0(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
123:    LDA  6,1(6) 	pop ac1
124:     LD  2,-1(6) 	
125:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> call
* output
* -> call
* gcd
* -> Id
* -> get address of variable
126:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
127:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
128:    LDA  6,-1(6) 	PUSH AC (for argument)
129:     ST  1,0(6) 	
* -> Id
* -> get address of variable
130:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
131:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
132:    LDA  6,-1(6) 	PUSH AC (for argument)
133:     ST  1,0(6) 	
* -> call (internal)
* gcd
134:    LDA  1,3(7) 	ac=pc+3 (next pc)
135:    LDA  6,-1(6) 	PUSH AC (return address)
136:     ST  1,0(6) 	
137:    LDC  7,31(0) 	pc=address (jmp to called function)
138:    LDA  6,2(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
139:    LDA  6,-1(6) 	PUSH AC (for argument)
140:     ST  1,0(6) 	
* -> call (internal)
* output
141:    LDA  1,3(7) 	ac=pc+3 (next pc)
142:    LDA  6,-1(6) 	PUSH AC (return address)
143:     ST  1,0(6) 	
144:    LDC  7,20(0) 	pc=address (jmp to called function)
145:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* <- compound
* -> function declaration tail
146:    LDA  6,0(4) 	MOV SP, BP
147:    LDA  6,1(6) 	POP BP
148:     LD  4,-1(6) 	
149:    LDA  6,1(6) 	RETRN; POP PC
150:     LD  7,-1(6) 	
* <- function declaration tail
* -> function declaration
* -> call (internal)
* main
  4:    LDA  1,3(7) 	ac=pc+3 (next pc)
  5:    LDA  6,-1(6) 	PUSH AC (return address)
  6:     ST  1,0(6) 	
  7:    LDC  7,100(0) 	pc=address (jmp to called function)
  8:    LDA  6,0(6) 	sp=sp+arg_num
* <- call (internal)
* END OF C-MINUS Compilation to TM Code
