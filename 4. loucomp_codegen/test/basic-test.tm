* C-MINUS Compilation to TM Code
* File: test/basic-test.tm
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
* -> call
* output
* -> Op
* -> Id
* -> get address of variable
 49:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
 50:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 51:    LDA  6,-1(6) 	PUSH AC
 52:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 53:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
 54:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 55:    LDA  6,1(6) 	POP AC1
 56:     LD  2,-1(6) 	
 57:    ADD  1,2,1 	reg[ac]=reg[ac1] + reg[ac]
* <- Op
 58:    LDA  6,-1(6) 	PUSH AC (for argument)
 59:     ST  1,0(6) 	
* -> call (internal)
* output
 60:    LDA  1,3(7) 	ac=pc+3 (next pc)
 61:    LDA  6,-1(6) 	PUSH AC (return address)
 62:     ST  1,0(6) 	
 63:    LDC  7,20(0) 	pc=address (jmp to called function)
 64:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> assign
* -> Id
* -> get address of variable
 65:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
 66:    LDA  6,-1(6) 	push ac
 67:     ST  1,0(6) 	
* -> call
* input
* -> call (internal)
* input
 68:    LDA  1,3(7) 	ac=pc+3 (next pc)
 69:    LDA  6,-1(6) 	PUSH AC (return address)
 70:     ST  1,0(6) 	
 71:    LDC  7,10(0) 	pc=address (jmp to called function)
 72:    LDA  6,0(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
 73:    LDA  6,1(6) 	pop ac1
 74:     LD  2,-1(6) 	
 75:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
 76:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
 77:    LDA  6,-1(6) 	push ac
 78:     ST  1,0(6) 	
* -> call
* input
* -> call (internal)
* input
 79:    LDA  1,3(7) 	ac=pc+3 (next pc)
 80:    LDA  6,-1(6) 	PUSH AC (return address)
 81:     ST  1,0(6) 	
 82:    LDC  7,10(0) 	pc=address (jmp to called function)
 83:    LDA  6,0(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
 84:    LDA  6,1(6) 	pop ac1
 85:     LD  2,-1(6) 	
 86:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> call
* output
* -> Op
* -> Id
* -> get address of variable
 87:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
 88:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 89:    LDA  6,-1(6) 	PUSH AC
 90:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 91:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
 92:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 93:    LDA  6,1(6) 	POP AC1
 94:     LD  2,-1(6) 	
 95:    MUL  1,2,1 	reg[ac]=reg[ac1] * reg[ac]
* <- Op
 96:    LDA  6,-1(6) 	PUSH AC (for argument)
 97:     ST  1,0(6) 	
* -> call (internal)
* output
 98:    LDA  1,3(7) 	ac=pc+3 (next pc)
 99:    LDA  6,-1(6) 	PUSH AC (return address)
100:     ST  1,0(6) 	
101:    LDC  7,20(0) 	pc=address (jmp to called function)
102:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* <- compound
* -> function declaration tail
103:    LDA  6,0(4) 	MOV SP, BP
104:    LDA  6,1(6) 	POP BP
105:     LD  4,-1(6) 	
106:    LDA  6,1(6) 	RETRN; POP PC
107:     LD  7,-1(6) 	
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
