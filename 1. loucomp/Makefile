#
# Makefile for C-MINUS
# Gnu C Version
# K. Louden 2/3/98
#

CC = gcc
CFLAGS = 
OBJS = main.o util.o scan.o
cminus: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o cminus 
main.o: main.c globals.h util.h scan.h 
	$(CC) $(CFLAGS) -c main.c
util.o: util.c util.h globals.h
	$(CC) $(CFLAGS) -c util.c
scan.o: scan.c scan.h util.h globals.h
	$(CC) $(CFLAGS) -c scan.c
clean:
	-rm cminus
	-rm $(OBJS)
all: cminus
