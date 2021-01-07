* C-MINUS Compilation to TM Code
* File: test/test3.tm
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
* main
* -> function declaration head
 31:    LDA  6,-1(6) 	PUSH BP
 32:     ST  4,0(6) 	
 33:    LDA  4,0(6) 	MOV BP, SP
 34:    LDA  6,-8(6) 	SP -= Varaiable number
* <- function declaration head
* -> compound
* -> assign
* -> Array Id
* -> get address of variable
 35:    LDA  2,-1(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
 36:    LDC  1,0(0) 	ac=const value
* <- Const
 37:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
 38:    LDA  6,-1(6) 	push ac
 39:     ST  1,0(6) 	
* -> Const
 40:    LDC  1,1(0) 	ac=const value
* <- Const
 41:    LDA  6,1(6) 	pop ac1
 42:     LD  2,-1(6) 	
 43:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Array Id
* -> get address of variable
 44:    LDA  2,-1(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
 45:    LDC  1,1(0) 	ac=const value
* <- Const
 46:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
 47:    LDA  6,-1(6) 	push ac
 48:     ST  1,0(6) 	
* -> Const
 49:    LDC  1,2(0) 	ac=const value
* <- Const
 50:    LDA  6,1(6) 	pop ac1
 51:     LD  2,-1(6) 	
 52:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Array Id
* -> get address of variable
 53:    LDA  2,-1(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
 54:    LDC  1,2(0) 	ac=const value
* <- Const
 55:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
 56:    LDA  6,-1(6) 	push ac
 57:     ST  1,0(6) 	
* -> Const
 58:    LDC  1,3(0) 	ac=const value
* <- Const
 59:    LDA  6,1(6) 	pop ac1
 60:     LD  2,-1(6) 	
 61:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
 62:    LDA  1,-7(4) 	ac=bp-offset-1
 63:    LDA  2,-7(4) 	ac1=bp-offset-1
* <- get address of variable
* <- Id
 64:    LDA  6,-1(6) 	push ac
 65:     ST  1,0(6) 	
* -> Const
 66:    LDC  1,4(0) 	ac=const value
* <- Const
 67:    LDA  6,1(6) 	pop ac1
 68:     LD  2,-1(6) 	
 69:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
 70:    LDA  1,-8(4) 	ac=bp-offset-1
 71:    LDA  2,-8(4) 	ac1=bp-offset-1
* <- get address of variable
* <- Id
 72:    LDA  6,-1(6) 	push ac
 73:     ST  1,0(6) 	
* -> Const
 74:    LDC  1,5(0) 	ac=const value
* <- Const
 75:    LDA  6,1(6) 	pop ac1
 76:     LD  2,-1(6) 	
 77:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> call
* output
* -> Array Id
* -> get address of variable
 78:    LDA  2,-1(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
 79:    LDC  1,0(0) 	ac=const value
* <- Const
 80:    SUB  1,2,1 	ac=ac1-ac (array offset)
 81:     LD  1,0(1) 	ac=dMem[ac]
* <- Array Id
 82:    LDA  6,-1(6) 	PUSH AC (for argument)
 83:     ST  1,0(6) 	
* -> call (internal)
* output
 84:    LDA  1,3(7) 	ac=pc+3 (next pc)
 85:    LDA  6,-1(6) 	PUSH AC (return address)
 86:     ST  1,0(6) 	
 87:    LDC  7,20(0) 	pc=address (jmp to called function)
 88:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> call
* output
* -> Array Id
* -> get address of variable
 89:    LDA  2,-1(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
 90:    LDC  1,1(0) 	ac=const value
* <- Const
 91:    SUB  1,2,1 	ac=ac1-ac (array offset)
 92:     LD  1,0(1) 	ac=dMem[ac]
* <- Array Id
 93:    LDA  6,-1(6) 	PUSH AC (for argument)
 94:     ST  1,0(6) 	
* -> call (internal)
* output
 95:    LDA  1,3(7) 	ac=pc+3 (next pc)
 96:    LDA  6,-1(6) 	PUSH AC (return address)
 97:     ST  1,0(6) 	
 98:    LDC  7,20(0) 	pc=address (jmp to called function)
 99:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> call
* output
* -> Array Id
* -> get address of variable
100:    LDA  2,-1(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
101:    LDC  1,2(0) 	ac=const value
* <- Const
102:    SUB  1,2,1 	ac=ac1-ac (array offset)
103:     LD  1,0(1) 	ac=dMem[ac]
* <- Array Id
104:    LDA  6,-1(6) 	PUSH AC (for argument)
105:     ST  1,0(6) 	
* -> call (internal)
* output
106:    LDA  1,3(7) 	ac=pc+3 (next pc)
107:    LDA  6,-1(6) 	PUSH AC (return address)
108:     ST  1,0(6) 	
109:    LDC  7,20(0) 	pc=address (jmp to called function)
110:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> assign
* -> Array Id
* -> get address of variable
111:    LDA  2,-4(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
112:    LDC  1,0(0) 	ac=const value
* <- Const
113:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
114:    LDA  6,-1(6) 	push ac
115:     ST  1,0(6) 	
* -> Array Id
* -> get address of variable
116:    LDA  2,-1(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
117:    LDC  1,2(0) 	ac=const value
* <- Const
118:    SUB  1,2,1 	ac=ac1-ac (array offset)
119:     LD  1,0(1) 	ac=dMem[ac]
* <- Array Id
120:    LDA  6,1(6) 	pop ac1
121:     LD  2,-1(6) 	
122:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Array Id
* -> get address of variable
123:    LDA  2,-4(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
124:    LDC  1,1(0) 	ac=const value
* <- Const
125:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
126:    LDA  6,-1(6) 	push ac
127:     ST  1,0(6) 	
* -> Array Id
* -> get address of variable
128:    LDA  2,-1(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
129:    LDC  1,1(0) 	ac=const value
* <- Const
130:    SUB  1,2,1 	ac=ac1-ac (array offset)
131:     LD  1,0(1) 	ac=dMem[ac]
* <- Array Id
132:    LDA  6,1(6) 	pop ac1
133:     LD  2,-1(6) 	
134:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Array Id
* -> get address of variable
135:    LDA  2,-4(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
136:    LDC  1,2(0) 	ac=const value
* <- Const
137:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
138:    LDA  6,-1(6) 	push ac
139:     ST  1,0(6) 	
* -> Id
* -> get address of variable
140:    LDA  1,-8(4) 	ac=bp-offset-1
141:    LDA  2,-8(4) 	ac1=bp-offset-1
* <- get address of variable
142:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
143:    LDA  6,1(6) 	pop ac1
144:     LD  2,-1(6) 	
145:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> call
* output
* -> Array Id
* -> get address of variable
146:    LDA  2,-4(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
147:    LDC  1,0(0) 	ac=const value
* <- Const
148:    SUB  1,2,1 	ac=ac1-ac (array offset)
149:     LD  1,0(1) 	ac=dMem[ac]
* <- Array Id
150:    LDA  6,-1(6) 	PUSH AC (for argument)
151:     ST  1,0(6) 	
* -> call (internal)
* output
152:    LDA  1,3(7) 	ac=pc+3 (next pc)
153:    LDA  6,-1(6) 	PUSH AC (return address)
154:     ST  1,0(6) 	
155:    LDC  7,20(0) 	pc=address (jmp to called function)
156:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> call
* output
* -> Array Id
* -> get address of variable
157:    LDA  2,-4(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
158:    LDC  1,1(0) 	ac=const value
* <- Const
159:    SUB  1,2,1 	ac=ac1-ac (array offset)
160:     LD  1,0(1) 	ac=dMem[ac]
* <- Array Id
161:    LDA  6,-1(6) 	PUSH AC (for argument)
162:     ST  1,0(6) 	
* -> call (internal)
* output
163:    LDA  1,3(7) 	ac=pc+3 (next pc)
164:    LDA  6,-1(6) 	PUSH AC (return address)
165:     ST  1,0(6) 	
166:    LDC  7,20(0) 	pc=address (jmp to called function)
167:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> call
* output
* -> Array Id
* -> get address of variable
168:    LDA  2,-4(4) 	ac1=bp-offset-1
* <- get address of variable
* -> Const
169:    LDC  1,2(0) 	ac=const value
* <- Const
170:    SUB  1,2,1 	ac=ac1-ac (array offset)
171:     LD  1,0(1) 	ac=dMem[ac]
* <- Array Id
172:    LDA  6,-1(6) 	PUSH AC (for argument)
173:     ST  1,0(6) 	
* -> call (internal)
* output
174:    LDA  1,3(7) 	ac=pc+3 (next pc)
175:    LDA  6,-1(6) 	PUSH AC (return address)
176:     ST  1,0(6) 	
177:    LDC  7,20(0) 	pc=address (jmp to called function)
178:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* <- compound
* -> function declaration tail
179:    LDA  6,0(4) 	MOV SP, BP
180:    LDA  6,1(6) 	POP BP
181:     LD  4,-1(6) 	
182:    LDA  6,1(6) 	RETRN; POP PC
183:     LD  7,-1(6) 	
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
