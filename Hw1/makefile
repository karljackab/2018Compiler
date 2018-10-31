.PHONY: all
all: lex.yy.c
	gcc -o scanner lex.yy.c -lfl
lex.yy.c: 0516003.l
	lex 0516003.l