* C-MINUS Compilation to TM Code
* File: test/selSort.tm
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
* minloc
* -> function declaration head
 31:    LDA  6,-1(6) 	PUSH BP
 32:     ST  4,0(6) 	
 33:    LDA  4,0(6) 	MOV BP, SP
 34:    LDA  6,-3(6) 	SP -= Varaiable number
* <- function declaration head
* -> compound
* -> assign
* -> Id
* -> get address of variable
 35:    LDA  1,-3(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
 36:    LDA  6,-1(6) 	push ac
 37:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 38:    LDA  1,3(4) 	ac=bp+offset+2
* <- get address of variable
 39:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 40:    LDA  6,1(6) 	pop ac1
 41:     LD  2,-1(6) 	
 42:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
 43:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
 44:    LDA  6,-1(6) 	push ac
 45:     ST  1,0(6) 	
* -> Array Id
* -> get address of variable
 46:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
* -> Id
* -> get address of variable
 47:    LDA  1,3(4) 	ac=bp+offset+2
* <- get address of variable
* <- Id
 48:    LDA  6,1(6) 	POP AC
 49:     LD  1,-1(6) 	
 50:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
 51:    LDA  6,1(6) 	pop ac1
 52:     LD  2,-1(6) 	
 53:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
 54:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
 55:    LDA  6,-1(6) 	push ac
 56:     ST  1,0(6) 	
* -> Op
* -> Id
* -> get address of variable
 57:    LDA  1,3(4) 	ac=bp+offset+2
* <- get address of variable
 58:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 59:    LDA  6,-1(6) 	PUSH AC
 60:     ST  1,0(6) 	
* -> Const
 61:    LDC  1,1(0) 	ac=const value
* <- Const
 62:    LDA  6,1(6) 	POP AC1
 63:     LD  2,-1(6) 	
 64:    ADD  1,2,1 	reg[ac]=reg[ac1] + reg[ac]
* <- Op
 65:    LDA  6,1(6) 	pop ac1
 66:     LD  2,-1(6) 	
 67:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> while
* while: comes back here after body
* -> Op
* -> Id
* -> get address of variable
 68:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
 69:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 70:    LDA  6,-1(6) 	PUSH AC
 71:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 72:    LDA  1,4(4) 	ac=bp+offset+2
* <- get address of variable
 73:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 74:    LDA  6,1(6) 	POP AC1
 75:     LD  2,-1(6) 	
 76:    SUB  1,2,1 	reg[ac]=reg[ac1]-reg[ac]
 77:    JLT  1,2(7) 	conditional jmp: if true
 78:    LDC  1,0(1) 	ac=0 (false case
 79:    LDA  7,1(7) 	unconditional jmp
 80:    LDC  1,1(1) 	ac=1 (true case
* <- Op
* while: conditional jmp to end
* -> compound
* -> if
* -> Op
* -> Array Id
* -> get address of variable
 82:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
* -> Id
* -> get address of variable
 83:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
 84:    LDA  6,1(6) 	POP AC
 85:     LD  1,-1(6) 	
 86:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
 87:    LDA  6,-1(6) 	PUSH AC
 88:     ST  1,0(6) 	
* -> Id
* -> get address of variable
 89:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
 90:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
 91:    LDA  6,1(6) 	POP AC1
 92:     LD  2,-1(6) 	
 93:    SUB  1,2,1 	reg[ac]=reg[ac1]-reg[ac]
 94:    JLT  1,2(7) 	conditional jmp: if true
 95:    LDC  1,0(1) 	ac=0 (false case
 96:    LDA  7,1(7) 	unconditional jmp
 97:    LDC  1,1(1) 	ac=1 (true case
* <- Op
* if: conditional jump to else
* -> compound
* -> assign
* -> Id
* -> get address of variable
 99:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
100:    LDA  6,-1(6) 	push ac
101:     ST  1,0(6) 	
* -> Array Id
* -> get address of variable
102:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
* -> Id
* -> get address of variable
103:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
104:    LDA  6,1(6) 	POP AC
105:     LD  1,-1(6) 	
106:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
107:    LDA  6,1(6) 	pop ac1
108:     LD  2,-1(6) 	
109:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
110:    LDA  1,-3(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
111:    LDA  6,-1(6) 	push ac
112:     ST  1,0(6) 	
* -> Id
* -> get address of variable
113:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
114:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
115:    LDA  6,1(6) 	pop ac1
116:     LD  2,-1(6) 	
117:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* <- compound
* if: unconditional jmp to end
 98:    JEQ  1,20(7) 	if: if ac==0, pc=addr of else
118:    LDA  7,0(7) 	if: pc=addr of endif
* <- if
* -> assign
* -> Id
* -> get address of variable
119:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
120:    LDA  6,-1(6) 	push ac
121:     ST  1,0(6) 	
* -> Op
* -> Id
* -> get address of variable
122:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
123:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
124:    LDA  6,-1(6) 	PUSH AC
125:     ST  1,0(6) 	
* -> Const
126:    LDC  1,1(0) 	ac=const value
* <- Const
127:    LDA  6,1(6) 	POP AC1
128:     LD  2,-1(6) 	
129:    ADD  1,2,1 	reg[ac]=reg[ac1] + reg[ac]
* <- Op
130:    LDA  6,1(6) 	pop ac1
131:     LD  2,-1(6) 	
132:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* <- compound
133:    LDC  7,68(0) 	while: go back; pc=addr of condition
 81:    JEQ  1,134(0) 	while: if ac==0, pc=addr of endwhile
* <- while
* -> return
* -> Id
* -> get address of variable
134:    LDA  1,-3(4) 	ac=bp-offset-1
* <- get address of variable
135:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
* -> function declaration tail
136:    LDA  6,0(4) 	MOV SP, BP
137:    LDA  6,1(6) 	POP BP
138:     LD  4,-1(6) 	
139:    LDA  6,1(6) 	RETRN; POP PC
140:     LD  7,-1(6) 	
* <- function declaration tail
* <- return
* <- compound
* -> function declaration tail
141:    LDA  6,0(4) 	MOV SP, BP
142:    LDA  6,1(6) 	POP BP
143:     LD  4,-1(6) 	
144:    LDA  6,1(6) 	RETRN; POP PC
145:     LD  7,-1(6) 	
* <- function declaration tail
* -> function declaration
* -> function declaration
* sort
* -> function declaration head
146:    LDA  6,-1(6) 	PUSH BP
147:     ST  4,0(6) 	
148:    LDA  4,0(6) 	MOV BP, SP
149:    LDA  6,-2(6) 	SP -= Varaiable number
* <- function declaration head
* -> compound
* -> assign
* -> Id
* -> get address of variable
150:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
151:    LDA  6,-1(6) 	push ac
152:     ST  1,0(6) 	
* -> Id
* -> get address of variable
153:    LDA  1,3(4) 	ac=bp+offset+2
* <- get address of variable
154:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
155:    LDA  6,1(6) 	pop ac1
156:     LD  2,-1(6) 	
157:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> while
* while: comes back here after body
* -> Op
* -> Id
* -> get address of variable
158:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
159:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
160:    LDA  6,-1(6) 	PUSH AC
161:     ST  1,0(6) 	
* -> Op
* -> Id
* -> get address of variable
162:    LDA  1,4(4) 	ac=bp+offset+2
* <- get address of variable
163:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
164:    LDA  6,-1(6) 	PUSH AC
165:     ST  1,0(6) 	
* -> Const
166:    LDC  1,1(0) 	ac=const value
* <- Const
167:    LDA  6,1(6) 	POP AC1
168:     LD  2,-1(6) 	
169:    SUB  1,2,1 	reg[ac]=reg[ac1] - reg[ac]
* <- Op
170:    LDA  6,1(6) 	POP AC1
171:     LD  2,-1(6) 	
172:    SUB  1,2,1 	reg[ac]=reg[ac1]-reg[ac]
173:    JLT  1,2(7) 	conditional jmp: if true
174:    LDC  1,0(1) 	ac=0 (false case
175:    LDA  7,1(7) 	unconditional jmp
176:    LDC  1,1(1) 	ac=1 (true case
* <- Op
* while: conditional jmp to end
* -> compound
* -> assign
* -> Id
* -> get address of variable
178:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
179:    LDA  6,-1(6) 	push ac
180:     ST  1,0(6) 	
* -> call
* minloc
* -> Id
* -> get address of variable
181:    LDA  1,4(4) 	ac=bp+offset+2
* <- get address of variable
182:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
183:    LDA  6,-1(6) 	PUSH AC (for argument)
184:     ST  1,0(6) 	
* -> Id
* -> get address of variable
185:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
186:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
187:    LDA  6,-1(6) 	PUSH AC (for argument)
188:     ST  1,0(6) 	
* -> Id
* -> get address of variable
189:     LD  1,2(4) 	ac=dMem[bp+offset+2]
* <- get address of variable
190:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
191:    LDA  6,-1(6) 	PUSH AC (for argument)
192:     ST  1,0(6) 	
* -> call (internal)
* minloc
193:    LDA  1,3(7) 	ac=pc+3 (next pc)
194:    LDA  6,-1(6) 	PUSH AC (return address)
195:     ST  1,0(6) 	
196:    LDC  7,31(0) 	pc=address (jmp to called function)
197:    LDA  6,3(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
198:    LDA  6,1(6) 	pop ac1
199:     LD  2,-1(6) 	
200:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* <- Id
201:    LDA  6,-1(6) 	push ac
202:     ST  1,0(6) 	
* -> Array Id
* -> get address of variable
203:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
* -> Id
* -> get address of variable
204:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
205:    LDA  6,1(6) 	POP AC
206:     LD  1,-1(6) 	
207:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
208:    LDA  6,1(6) 	pop ac1
209:     LD  2,-1(6) 	
210:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Array Id
* -> get address of variable
211:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
* -> Id
* -> get address of variable
212:    LDA  1,-2(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
213:    LDA  6,1(6) 	POP AC
214:     LD  1,-1(6) 	
215:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
216:    LDA  6,-1(6) 	push ac
217:     ST  1,0(6) 	
* -> Array Id
* -> get address of variable
218:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
* -> Id
* -> get address of variable
219:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
220:    LDA  6,1(6) 	POP AC
221:     LD  1,-1(6) 	
222:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
223:    LDA  6,1(6) 	pop ac1
224:     LD  2,-1(6) 	
225:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Array Id
* -> get address of variable
226:    LDA  1,2(4) 	ac=bp+offset+2
* <- get address of variable
* -> Id
* -> get address of variable
227:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
228:    LDA  6,1(6) 	POP AC
229:     LD  1,-1(6) 	
230:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
231:    LDA  6,-1(6) 	push ac
232:     ST  1,0(6) 	
* -> Id
233:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
234:    LDA  6,1(6) 	pop ac1
235:     LD  2,-1(6) 	
236:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
237:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
238:    LDA  6,-1(6) 	push ac
239:     ST  1,0(6) 	
* -> Op
* -> Id
* -> get address of variable
240:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
241:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
242:    LDA  6,-1(6) 	PUSH AC
243:     ST  1,0(6) 	
* -> Const
244:    LDC  1,1(0) 	ac=const value
* <- Const
245:    LDA  6,1(6) 	POP AC1
246:     LD  2,-1(6) 	
247:    ADD  1,2,1 	reg[ac]=reg[ac1] + reg[ac]
* <- Op
248:    LDA  6,1(6) 	pop ac1
249:     LD  2,-1(6) 	
250:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* <- compound
251:    LDC  7,158(0) 	while: go back; pc=addr of condition
177:    JEQ  1,252(0) 	while: if ac==0, pc=addr of endwhile
* <- while
* <- compound
* -> function declaration tail
252:    LDA  6,0(4) 	MOV SP, BP
253:    LDA  6,1(6) 	POP BP
254:     LD  4,-1(6) 	
255:    LDA  6,1(6) 	RETRN; POP PC
256:     LD  7,-1(6) 	
* <- function declaration tail
* -> function declaration
* -> function declaration
* main
* -> function declaration head
257:    LDA  6,-1(6) 	PUSH BP
258:     ST  4,0(6) 	
259:    LDA  4,0(6) 	MOV BP, SP
260:    LDA  6,-1(6) 	SP -= Varaiable number
* <- function declaration head
* -> compound
* -> assign
* -> Id
* -> get address of variable
261:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
262:    LDA  6,-1(6) 	push ac
263:     ST  1,0(6) 	
* -> Const
264:    LDC  1,0(0) 	ac=const value
* <- Const
265:    LDA  6,1(6) 	pop ac1
266:     LD  2,-1(6) 	
267:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> while
* while: comes back here after body
* -> Op
* -> Id
* -> get address of variable
268:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
269:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
270:    LDA  6,-1(6) 	PUSH AC
271:     ST  1,0(6) 	
* -> Const
272:    LDC  1,10(0) 	ac=const value
* <- Const
273:    LDA  6,1(6) 	POP AC1
274:     LD  2,-1(6) 	
275:    SUB  1,2,1 	reg[ac]=reg[ac1]-reg[ac]
276:    JLT  1,2(7) 	conditional jmp: if true
277:    LDC  1,0(1) 	ac=0 (false case
278:    LDA  7,1(7) 	unconditional jmp
279:    LDC  1,1(1) 	ac=1 (true case
* <- Op
* while: conditional jmp to end
* -> compound
* -> assign
* -> Array Id
* -> get address of variable
281:    LDA  1,1(5) 	ac=gp-offset
* <- get address of variable
* -> Id
* -> get address of variable
282:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
283:    LDA  6,1(6) 	POP AC
284:     LD  1,-1(6) 	
285:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
286:    LDA  6,-1(6) 	push ac
287:     ST  1,0(6) 	
* -> call
* input
* -> call (internal)
* input
288:    LDA  1,3(7) 	ac=pc+3 (next pc)
289:    LDA  6,-1(6) 	PUSH AC (return address)
290:     ST  1,0(6) 	
291:    LDC  7,10(0) 	pc=address (jmp to called function)
292:    LDA  6,0(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
293:    LDA  6,1(6) 	pop ac1
294:     LD  2,-1(6) 	
295:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> assign
* -> Id
* -> get address of variable
296:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
297:    LDA  6,-1(6) 	push ac
298:     ST  1,0(6) 	
* -> Op
* -> Id
* -> get address of variable
299:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
300:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
301:    LDA  6,-1(6) 	PUSH AC
302:     ST  1,0(6) 	
* -> Const
303:    LDC  1,1(0) 	ac=const value
* <- Const
304:    LDA  6,1(6) 	POP AC1
305:     LD  2,-1(6) 	
306:    ADD  1,2,1 	reg[ac]=reg[ac1] + reg[ac]
* <- Op
307:    LDA  6,1(6) 	pop ac1
308:     LD  2,-1(6) 	
309:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* <- compound
310:    LDC  7,268(0) 	while: go back; pc=addr of condition
280:    JEQ  1,311(0) 	while: if ac==0, pc=addr of endwhile
* <- while
* -> call
* sort
* -> Const
311:    LDC  1,10(0) 	ac=const value
* <- Const
312:    LDA  6,-1(6) 	PUSH AC (for argument)
313:     ST  1,0(6) 	
* -> Const
314:    LDC  1,0(0) 	ac=const value
* <- Const
315:    LDA  6,-1(6) 	PUSH AC (for argument)
316:     ST  1,0(6) 	
* -> Id
* -> get address of variable
317:    LDA  1,1(5) 	ac=gp-offset
* <- get address of variable
318:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
319:    LDA  6,-1(6) 	PUSH AC (for argument)
320:     ST  1,0(6) 	
* -> call (internal)
* sort
321:    LDA  1,3(7) 	ac=pc+3 (next pc)
322:    LDA  6,-1(6) 	PUSH AC (return address)
323:     ST  1,0(6) 	
324:    LDC  7,146(0) 	pc=address (jmp to called function)
325:    LDA  6,3(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> assign
* -> Id
* -> get address of variable
326:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
327:    LDA  6,-1(6) 	push ac
328:     ST  1,0(6) 	
* -> Const
329:    LDC  1,0(0) 	ac=const value
* <- Const
330:    LDA  6,1(6) 	pop ac1
331:     LD  2,-1(6) 	
332:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* -> while
* while: comes back here after body
* -> Op
* -> Id
* -> get address of variable
333:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
334:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
335:    LDA  6,-1(6) 	PUSH AC
336:     ST  1,0(6) 	
* -> Const
337:    LDC  1,10(0) 	ac=const value
* <- Const
338:    LDA  6,1(6) 	POP AC1
339:     LD  2,-1(6) 	
340:    SUB  1,2,1 	reg[ac]=reg[ac1]-reg[ac]
341:    JLT  1,2(7) 	conditional jmp: if true
342:    LDC  1,0(1) 	ac=0 (false case
343:    LDA  7,1(7) 	unconditional jmp
344:    LDC  1,1(1) 	ac=1 (true case
* <- Op
* while: conditional jmp to end
* -> compound
* -> call
* output
* -> Array Id
* -> get address of variable
346:    LDA  1,1(5) 	ac=gp-offset
* <- get address of variable
* -> Id
* -> get address of variable
347:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
348:    LDA  6,1(6) 	POP AC
349:     LD  1,-1(6) 	
350:    SUB  1,2,1 	ac=ac1-ac (array offset)
* <- Array Id
351:    LDA  6,-1(6) 	PUSH AC (for argument)
352:     ST  1,0(6) 	
* -> call (internal)
* output
353:    LDA  1,3(7) 	ac=pc+3 (next pc)
354:    LDA  6,-1(6) 	PUSH AC (return address)
355:     ST  1,0(6) 	
356:    LDC  7,20(0) 	pc=address (jmp to called function)
357:    LDA  6,1(6) 	sp=sp+arg_num
* <- call (internal)
* <- call
* -> assign
* -> Id
* -> get address of variable
358:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
* <- Id
359:    LDA  6,-1(6) 	push ac
360:     ST  1,0(6) 	
* -> Op
* -> Id
* -> get address of variable
361:    LDA  1,-1(4) 	ac=bp-offset-1
* <- get address of variable
362:     LD  1,0(1) 	ac=dMem[ac]
* <- Id
363:    LDA  6,-1(6) 	PUSH AC
364:     ST  1,0(6) 	
* -> Const
365:    LDC  1,1(0) 	ac=const value
* <- Const
366:    LDA  6,1(6) 	POP AC1
367:     LD  2,-1(6) 	
368:    ADD  1,2,1 	reg[ac]=reg[ac1] + reg[ac]
* <- Op
369:    LDA  6,1(6) 	pop ac1
370:     LD  2,-1(6) 	
371:     ST  1,0(2) 	dMem[ac1]=ac
* <- assign
* <- compound
372:    LDC  7,333(0) 	while: go back; pc=addr of condition
345:    JEQ  1,373(0) 	while: if ac==0, pc=addr of endwhile
* <- while
* <- compound
* -> function declaration tail
373:    LDA  6,0(4) 	MOV SP, BP
374:    LDA  6,1(6) 	POP BP
375:     LD  4,-1(6) 	
376:    LDA  6,1(6) 	RETRN; POP PC
377:     LD  7,-1(6) 	
* <- function declaration tail
* -> function declaration
* -> call (internal)
* main
  4:    LDA  1,3(7) 	ac=pc+3 (next pc)
  5:    LDA  6,-1(6) 	PUSH AC (return address)
  6:     ST  1,0(6) 	
  7:    LDC  7,257(0) 	pc=address (jmp to called function)
  8:    LDA  6,0(6) 	sp=sp+arg_num
* <- call (internal)
* END OF C-MINUS Compilation to TM Code
