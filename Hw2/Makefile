LEX = lex
YACC = yacc
LEXFN = lex.l
YACC_IN = yacctemplate.y
CC = gcc
LIBS = -ly -lfl
OUTPUT = parser
SCANNERSN = scanner.c
YACC_FILE = yacc.c

all: scanner

scanner: lex yacc
	$(CC) -o $(OUTPUT) $(SCANNERSN) $(YACC_FILE) $(LIBS)
lex:
	$(LEX) -o $(SCANNERSN) $(LEXFN)
yacc:
	$(YACC) -o $(YACC_FILE) -d -v $(YACC_IN)