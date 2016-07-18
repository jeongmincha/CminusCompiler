* C-MINUS Compilation to TM Code
* File: test/test2.tm
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
* add
* -> function declaration head
 31:    LDA  6,-1(6) 	PUSH BP
 32:     ST  4,0(6) 	
 33:    LDA  4,0(6) 	MOV BP, SP
 34:    LDA  6,0(6) 	SP -= Varaiable number
* <- function declaration head
* -> compound
* -> call
* output
* -> Id
* -> get address of variable
 35:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
 36:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 37:    LDA  6,-1(6) 	PUSH AC (for argument)
 38:     ST  1,0(6) 	
* -> call (internal)
* output
 39:    LDA  1,3(7) 	ac=pc+3 (next pc)
 40:    LDA  6,-1(6) 	PUSH AC (return address)
 41:     ST  1,0(6) 	
 42:    LDC  7,20(0) 	pc=address (jmp to called function)
 43:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> call
* output
* -> Id
* -> get address of variable
 44:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
 45:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 46:    LDA  6,-1(6) 	PUSH AC (for argument)
 47:     ST  1,0(6) 	
* -> call (internal)
* output
 48:    LDA  1,3(7) 	ac=pc+3 (next pc)
 49:    LDA  6,-1(6) 	PUSH AC (return address)
 50:     ST  1,0(6) 	
 51:    LDC  7,20(0) 	pc=address (jmp to called function)
 52:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> return
* -> Op
* -> Id
* -> get address of variable
 53:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
 54:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 55:    LDA  6,-1(6) 	PUSH AC
 56:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 57:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
 58:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 59:    LDA  6,1(6) 	POP AC1
 60:     LD  2,-1(6) 	
 61:    ADD  1,2,1 	reg[ac]=reg[ac1] + reg[ac]
* <- Op
* -> function declaration tail
 62:    LDA  6,0(4) 	MOV SP, BP
 63:    LDA  6,1(6) 	POP BP
 64:     LD  4,-1(6) 	
 65:    LDA  6,1(6) 	RETRN; POP PC
 66:     LD  7,-1(6) 	
* <- function declaration tail
* <- return
* <- compound
* -> function declaration tail
 67:    LDA  6,0(4) 	MOV SP, BP
 68:    LDA  6,1(6) 	POP BP
 69:     LD  4,-1(6) 	
 70:    LDA  6,1(6) 	RETRN; POP PC
 71:     LD  7,-1(6) 	
* <- function declaration tail
* -> function declaration
* -> function declaration
* main
* -> function declaration head
 72:    LDA  6,-1(6) 	PUSH BP
 73:     ST  4,0(6) 	
 74:    LDA  4,0(6) 	MOV BP, SP
 75:    LDA  6,0(6) 	SP -= Varaiable number
* <- function declaration head
* -> compound
* -> call
* output
* -> call
* add
* -> Const
 76:    LDC  1,3(0) 	ac=const value
* <- Const
 77:    LDA  6,-1(6) 	PUSH AC (for argument)
 78:     ST  1,0(6) 	
* -> Const
 79:    LDC  1,1(0) 	ac=const value
* <- Const
 80:    LDA  6,-1(6) 	PUSH AC (for argument)
 81:     ST  1,0(6) 	
* -> call (internal)
* add
 82:    LDA  1,3(7) 	ac=pc+3 (next pc)
 83:    LDA  6,-1(6) 	PUSH AC (return address)
 84:     ST  1,0(6) 	
 85:    LDC  7,31(0) 	pc=address (jmp to called function)
 86:    LDA  6,2(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
 87:    LDA  6,-1(6) 	PUSH AC (for argument)
 88:     ST  1,0(6) 	
* -> call (internal)
* output
 89:    LDA  1,3(7) 	ac=pc+3 (next pc)
 90:    LDA  6,-1(6) 	PUSH AC (return address)
 91:     ST  1,0(6) 	
 92:    LDC  7,20(0) 	pc=address (jmp to called function)
 93:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* <- compound
* -> function declaration tail
 94:    LDA  6,0(4) 	MOV SP, BP
 95:    LDA  6,1(6) 	POP BP
 96:     LD  4,-1(6) 	
 97:    LDA  6,1(6) 	RETRN; POP PC
 98:     LD  7,-1(6) 	
* <- function declaration tail
* -> function declaration
* -> call (internal)
* main
  4:    LDA  1,3(7) 	ac=pc+3 (next pc)
  5:    LDA  6,-1(6) 	PUSH AC (return address)
  6:     ST  1,0(6) 	
  7:    LDC  7,72(0) 	pc=address (jmp to called function)
  8:    LDA  6,0(6) 	sp=sp+arg_num
* <- call (internal)
* END OF C-MINUS Compilation to TM Code
