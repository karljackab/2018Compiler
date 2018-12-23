%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
int yyerror( char *msg );
extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */
%}

%token SEMICOLON    /* ; */
%token COMMA		/* , */
%token ID           /* identifier */

%token VOID			/* keyword */
%token INT          
%token DOUBLE
%token FLOAT
%token STRING
%token BOOL
%token EQUAL
%token CONST
%token PRINT
%token READ
%token IF
%token ELSE
%token WHILE
%token DO
%token FOR
%token RETURN
%token BREAK
%token CONTINUE

%token INT_CONST	/* integer const */
%token FLOAT_CONST
%token STRING_CONST
%token BOOL_CONST

%token L_CURLY		/* { */
%token R_CURLY		/* } */
%token L_SQUARE		/* [ */
%token R_SQUARE		/* ] */
%token L_PAREN		/* ( */
%token R_PAREN		/* ) */


%left MULT DIV MOD
%left PLUS MINUS
%left ST SE EQ GE GT NEQ
%right NOT
%left AND
%left OR

%%

program : decl_and_def_list
	;

decl_and_def_list	: declaration_list decl_and_def_list_append
			| definition_list decl_and_def_list_append
			;
decl_and_def_list_append : decl_and_def_list
			| %empty
			;

declaration_list : const_decl
                | var_decl
                | funct_decl
				;

/*			function declaration 		*/
funct_decl : type identifier L_PAREN arguments R_PAREN SEMICOLON
		| VOID identifier L_PAREN arguments R_PAREN SEMICOLON
		;

arguments : type identifier arguments_append
		| type array arguments_append
		| %empty
		;
arguments_append : COMMA arguments
		| %empty
		;

/*		function definition 		*/
definition_list : type identifier L_PAREN arguments R_PAREN compound
		| VOID identifier L_PAREN arguments R_PAREN compound
		;


/*			variable declaration 		*/
var_decl : type identifier_list SEMICOLON
    	;

type : INT
	 | DOUBLE
	 | FLOAT
	 | STRING
	 | BOOL
     ;

identifier_list : identifier var_assign identifier_list_append
		| array arr_assign identifier_list_append
		;
identifier_list_append : COMMA identifier_list
		| %empty
		;

var_assign : EQUAL expression
		| %empty
		;

identifier : ID
		;

array : ID arr_size_list
		;

arr_size_list : arr_size
		| arr_size arr_size_list
		;

arr_size : L_SQUARE INT_CONST R_SQUARE
		;

arr_assign : EQUAL initial_array
		| %empty
		;

initial_array : L_CURLY expression_list R_CURLY
		;

expression_list : expression expression_list_append
		| %empty
		;
expression_list_append : COMMA expression expression_list_append
		| %empty
		;

/*		const declaration 		*/

const_decl : CONST type const_list SEMICOLON
		;

const_list : identifier EQUAL literal_const const_list_append
		;
const_list_append : COMMA const_list
		| %empty
		;

literal_const : INT_CONST
		| FLOAT_CONST
		| STRING_CONST
		| BOOL_CONST
		;

/*		statement		*/
statement : compound
		| simple
		| conditional
		| while
		| for
		| jump
		| procedure
		;

/*		compound		*/
compound : L_CURLY compound_content R_CURLY
		;

compound_content : var_decl compound_content
		| const_decl compound_content
		| statement compound_content
		| %empty
		;

/*		simple		*/
simple : variable_reference EQUAL expression SEMICOLON
		| PRINT expression SEMICOLON
		| READ variable_reference SEMICOLON
		;

variable_reference : identifier
		| array_ref
		;

array_ref : identifier array_ref_idx
		;
array_ref_idx : L_SQUARE expression R_SQUARE array_ref_idx_append
		;
array_ref_idx_append : array_ref_idx
		| %empty
		;

/*		expression		*/
expression : literal_const 
		| variable_reference
		| MINUS expression
		| expression MULT expression
		| expression DIV expression
		| expression MOD expression
		| expression PLUS expression
		| expression MINUS expression
		| expression ST expression
		| expression SE expression
		| expression EQ expression
		| expression GE expression
		| expression GT expression
		| expression NEQ expression
		| expression NOT expression
		| expression AND expression
		| expression OR expression
		| L_PAREN expression R_PAREN
		;

/* 		conditional		*/
conditional : conditional_pair
		| conditional_single
		;
conditional_pair : IF L_PAREN expression R_PAREN compound ELSE L_PAREN expression R_PAREN compound
	;
conditional_single : IF L_PAREN expression R_PAREN compound
	;

/*		while		*/
while : single_while
	|	do_while
	;
single_while : WHILE L_PAREN expression R_PAREN compound
	;
do_while : DO compound WHILE L_PAREN expression R_PAREN SEMICOLON
	;

/*		for 		*/
for : FOR L_PAREN for_init_expr SEMICOLON for_control_expr SEMICOLON for_incre_expr R_PAREN compound
		;
for_init_expr : expression
		| expression EQUAL expression
		| %empty
		;
for_control_expr : expression
		| expression EQUAL expression
		| %empty
		;
for_incre_expr : expression
		| expression EQUAL expression
		| %empty
		;

/*		jump		*/
jump : RETURN expression SEMICOLON
	| BREAK SEMICOLON
	| CONTINUE SEMICOLON
	;

/*		invocation		*/
procedure : identifier L_PAREN expression_list R_PAREN SEMICOLON


%%

int yyerror( char *msg )
{
  fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
	fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
	fprintf( stderr, "|\n" );
	fprintf( stderr, "| Unmatched token: %s\n", yytext );
  fprintf( stderr, "|--------------------------------------------------------------------------\n" );
  exit(-1);
}

int  main( int argc, char **argv )
{
	if( argc != 2 ) {
		fprintf(  stdout,  "Usage:  ./parser  [filename]\n"  );
		exit(0);
	}

	FILE *fp = fopen( argv[1], "r" );
	
	if( fp == NULL )  {
		fprintf( stdout, "Open  file  error\n" );
		exit(-1);
	}
	
	yyin = fp;
	yyparse();

	fprintf( stdout, "\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	fprintf( stdout, "|  There is no syntactic error!  |\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	exit(0);
}

