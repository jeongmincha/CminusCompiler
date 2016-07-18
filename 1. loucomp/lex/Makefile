CC = gcc
CFLAGS = 
OBJS = main.o util.o lex.yy.o
cminus_flex: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o cminus_flex -lfl
main.o: main.c globals.h util.h scan.h
	$(CC) $(CFLAGS) -c main.c
util.o: util.c util.h globals.h
	$(CC) $(CFLAGS) -c util.c
scan.o: scan.c scan.h util.h globals.h
	$(CC) $(CFLAGS) -c scan.c
lex.yy.o: cminus.l scan.h util.h globals.h
	flex -o lex.yy.c cminus.l
	$(CC) $(CFLAGS) -c lex.yy.c -lfl 
clean:
	-rm cminus_flex
	-rm $(OBJS)
all: cminus_flex
