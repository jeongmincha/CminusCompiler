* C-MINUS Compilation to TM Code
* File: test.tm
* -> init zero, gp, sp
  0:    LDC  0,0(0) 	reg[zero]=0 (init zero)
  1:     LD  5,0(0) 	gp=dMem[0] (dMem[0]==maxaddress)
  2:     ST  0,0(0) 	dMem[0]=0 (clear location 0)
  3:    LDA  6,0(5) 	sp=gp-global_var_num+1
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
* main
* -> function declaration head
 31:    LDA  6,-1(6) 	PUSH BP
 32:     ST  4,0(6) 	
 33:    LDA  4,0(6) 	MOV BP, SP
 34:    LDA  6,-2(6) 	SP -= Varaiable number
* <- function declaration head
* -> compound
* -> assign
* -> Id
* -> get address of variable
 35:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
 36:    LDA  6,-1(6) 	push ac
 37:     ST  1,0(6) 	
* -> Const
 38:    LDC  1,3(0) 	ac=const value
* <- Const
 39:    LDA  6,1(6) 	pop ac1
 40:     LD  2,-1(6) 	
 41:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
 42:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
 43:    LDA  6,-1(6) 	push ac
 44:     ST  1,0(6) 	
* -> Const
 45:    LDC  1,5(0) 	ac=const value
* <- Const
 46:    LDA  6,1(6) 	pop ac1
 47:     LD  2,-1(6) 	
 48:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
 49:    LDA  1,1(5) 	ac=gp-offset
* <- get address of variable
* <- Id
 50:    LDA  6,-1(6) 	push ac
 51:     ST  1,0(6) 	
* -> Const
 52:    LDC  1,2(0) 	ac=const value
* <- Const
 53:    LDA  6,1(6) 	pop ac1
 54:     LD  2,-1(6) 	
 55:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> while
* while: comes back here after body
* -> Op
* -> Id
* -> get address of variable
 56:    LDA  1,1(5) 	ac=gp-offset
* <- get address of variable
 57:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 58:    LDA  6,-1(6) 	PUSH AC
 59:     ST  1,0(6) 	
* -> Const
 60:    LDC  1,0(0) 	ac=const value
* <- Const
 61:    LDA  6,1(6) 	POP AC1
 62:     LD  2,-1(6) 	
 63:    SUB  1,2,1 	reg[ac]=reg[ac1]-reg[ac]
 64:    JGT  1,2(7) 	conditional jmp: if true
 65:    LDC  1,0(1) 	ac=0 (false case
 66:    LDA  7,1(7) 	unconditional jmp
 67:    LDC  1,1(1) 	ac=1 (true case
* <- Op
* while: conditional jmp to end
* -> compound
* -> assign
* -> Id
* -> get address of variable
 69:    LDA  1,1(5) 	ac=gp-offset
* <- get address of variable
* <- Id
 70:    LDA  6,-1(6) 	push ac
 71:     ST  1,0(6) 	
* -> Op
* -> Id
* -> get address of variable
 72:    LDA  1,1(5) 	ac=gp-offset
* <- get address of variable
 73:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 74:    LDA  6,-1(6) 	PUSH AC
 75:     ST  1,0(6) 	
* -> Const
 76:    LDC  1,1(0) 	ac=const value
* <- Const
 77:    LDA  6,1(6) 	POP AC1
 78:     LD  2,-1(6) 	
 79:    SUB  1,2,1 	reg[ac]=reg[ac1] - reg[ac]
* <- Op
 80:    LDA  6,1(6) 	pop ac1
 81:     LD  2,-1(6) 	
 82:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> call
* output
* -> Op
* -> Id
* -> get address of variable
 83:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
 84:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 85:    LDA  6,-1(6) 	PUSH AC
 86:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 87:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
 88:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 89:    LDA  6,1(6) 	POP AC1
 90:     LD  2,-1(6) 	
 91:    ADD  1,2,1 	reg[ac]=reg[ac1] + reg[ac]
* <- Op
 92:    LDA  6,-1(6) 	PUSH AC (for argument)
 93:     ST  1,0(6) 	
* -> call (internal)
* output
 94:    LDA  1,3(7) 	ac=pc+3 (next pc)
 95:    LDA  6,-1(6) 	PUSH AC (return address)
 96:     ST  1,0(6) 	
 97:    LDC  7,20(0) 	pc=address (jmp to called function)
 98:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* <- compound
 99:    LDC  7,56(0) 	while: go back; pc=addr of condition
 68:    JEQ  1,100(0) 	while: if ac==0, pc=addr of endwhile
* <- while
* -> call
* output
* -> Op
* -> Id
* -> get address of variable
100:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
101:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
102:    LDA  6,-1(6) 	PUSH AC
103:     ST  1,0(6) 	
* -> Id
* -> get address of variable
104:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
105:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
106:    LDA  6,1(6) 	POP AC1
107:     LD  2,-1(6) 	
108:    ADD  1,2,1 	reg[ac]=reg[ac1] + reg[ac]
* <- Op
109:    LDA  6,-1(6) 	PUSH AC (for argument)
110:     ST  1,0(6) 	
* -> call (internal)
* output
111:    LDA  1,3(7) 	ac=pc+3 (next pc)
112:    LDA  6,-1(6) 	PUSH AC (return address)
113:     ST  1,0(6) 	
114:    LDC  7,20(0) 	pc=address (jmp to called function)
115:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* <- compound
* -> function declaration tail
116:    LDA  6,0(4) 	MOV SP, BP
117:    LDA  6,1(6) 	POP BP
118:     LD  4,-1(6) 	
119:    LDA  6,1(6) 	RETRN; POP PC
120:     LD  7,-1(6) 	
* <- function declaration tail
* -> function declaration
* -> call (internal)
* main
  4:    LDA  1,3(7) 	ac=pc+3 (next pc)
  5:    LDA  6,-1(6) 	PUSH AC (return address)
  6:     ST  1,0(6) 	
  7:    LDC  7,31(0) 	pc=address (jmp to called function)
  8:    LDA  6,0(6) 	sp=sp+arg_num
* <- call (internal)
* END OF C-MINUS Compilation to TM Code
