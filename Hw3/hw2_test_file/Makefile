LEX = lex
YACC = yacc
LEXFN = lex.l
OUTPUT = parser
YACC_IN = yacctemplate.y
CC = gcc
LIBS = -ly -lfl -lbsd
SCANNERSN = scanner.c
YACC_FILE = yacc.c

all: scanner

scanner: lex yacc
	$(CC) -o $(OUTPUT) $(SCANNERSN) $(YACC_FILE) $(LIBS)
lex:
	$(LEX) -o $(SCANNERSN) $(LEXFN)
yacc:
	$(YACC) -o $(YACC_FILE) -d -v $(YACC_IN)