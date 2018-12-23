%{
#include <bsd/string.h>
#include "yacc.h"

#define MAX_LINE_LENGTH 257
#define MAX_ID_LENGTH 257
#define MAX_STRING_LENGTH 257
#define LIST                strlcat(buf, yytext, MAX_LINE_LENGTH)
#define token(t)            {LIST; if (Opt_Token) printf("<%s>\n", #t);}
#define tokenInteger(t, i)  {LIST; if (Opt_Token) printf("<%s:%d>\n", t, i);}
#define tokenString(t, s)   {LIST; if (Opt_Token) printf("<%s:%s>\n", t, s);}
int Opt_Source = 1;
int Opt_Token = 1;
int Opt_Statistic =1;
int linenum = 1;
int Last_State = 0;
char buf[MAX_LINE_LENGTH];
char strContent[MAX_STRING_LENGTH];
typedef struct ids{
	char id_name[MAX_ID_LENGTH];
	int freq;
	struct ids *next;
} id;
id *id_head;
void set(id **, char *);
id *new_id();
%}

%x PRAGMA
%x SOURCE
%x TOKEN
%x STATISTIC
%x OTHER
%x STR
%x STR_ESCAPE
%x COMMENT

%%
<INITIAL>[\t ]+	{
		LIST;
	}
^#pragma[\t ]+	{
		LIST;
		BEGIN PRAGMA;
	}
<PRAGMA>"source"[\t ]+	{
		LIST;
		BEGIN SOURCE;
	}
<PRAGMA>"token"[\t ]+	{
		LIST;
		BEGIN TOKEN;
	}
<PRAGMA>"statistic"[\t ]+	{
		LIST;
		BEGIN STATISTIC;
	}

<SOURCE>"on"[\t ]*	{
		LIST;
		Opt_Source = 1;
		BEGIN OTHER;
	}
<SOURCE>"off"[\t ]*	{
		LIST;
		Opt_Source = 0;
		BEGIN OTHER;
	}

<SOURCE>[^\t ]	{
		//printf("Error at source line %d: %s\n",linenum, yytext);
                  fprintf(stderr,"Error at line %d: %s\n",linenum,yytext);
        exit(1);
	}
<TOKEN>"on"[\t ]*	{
		LIST;
		Opt_Token = 1;
		BEGIN OTHER;
	}
<TOKEN>"off"[\t ]*	{
		LIST;
		Opt_Token = 0;
		BEGIN OTHER;
	}

<TOKEN>[^\t ]	{
                 fprintf(stderr,"Error at line %d: %s\n",linenum,yytext);
        exit(1);
	}

<STATISTIC>"on"[\t ]*	{
		LIST;
		Opt_Statistic = 1;
		BEGIN OTHER;
	}
<STATISTIC>"off"[\t ]*	{
		LIST;
		Opt_Statistic = 0;
		BEGIN OTHER;
	}

<STATISTIC>[^\t ]	{
                 fprintf(stderr,"Error at line %d: %s\n",linenum,yytext);
        exit(1);
	}
<OTHER>\/\/[^\n]*	{
		LIST;
		
	}
<OTHER>"/*"	{
		LIST;
        Last_State = OTHER;
		BEGIN COMMENT;
	}

<OTHER>\n		{
		LIST;
  	      if (Opt_Source)
  	        printf("%d:%s\n", linenum, buf);
  	      linenum++;
  	      buf[0] = '\0';
		  BEGIN INITIAL;
	}

<OTHER>[^\n]		{
                  fprintf(stderr,"Error at line %d: %s\n",linenum,yytext);
                exit(1);

	}

<PRAGMA>[^\t ]		{
                  fprintf(stderr,"Error at line %d: %s\n",linenum,yytext);
                exit(1);

	}
"("	{
		tokenString("delim", "(");
		return L_PAREN;
	}
")"	{
		tokenString("delim", ")");
		return R_PAREN;
	}
","	{
		tokenString("delim", ",");
		return COMMA;
	}
";"	{
		tokenString("delim", ";");
		return SEMICOLON;
	}
"["	{
		tokenString("delim", "[");
		return L_SQUARE;
	}
"]"	{
		tokenString("delim", "]");
		return R_SQUARE;
	}
"{"	{
		tokenString("delim", "{");
		return L_CURLY;
	}
"}"	{
		tokenString("delim", "}");
		return R_CURLY;
	}
"+"	{
		token("+");
		return PLUS;
	}
"-"	{
		token("-");
		return MINUS;
	}
"*"	{
		token("*");
		return MULT;
	}
"/"	{
		token("/");
		return DIV;
	}
"%"	{
		token("%");
		return MOD;
	}
"="	{
		token("=");
		return EQUAL;
	}
"<"	{
		token("<");
		return ST;
	}
"<=" {
		token("<=");
		return SE;
	}
"!=" {
		token("!=");
		return NEQ;
	}
">=" {
		token(">=");
		return GE;
	}
">"	{
		token(">");
		return GT;
	}
"==" {
		token("==");
		return EQ;
	}
"&&" {
		token("&&");
		return AND;
	}
"||" {
		token("||");
		return OR;
	}
"!"	{
		token("!");
		return NOT;
	}

boolean {
		tokenString("KW", yytext);
	}
void {
		tokenString("KW", yytext);
		return VOID;
	}
int {
		tokenString("KW", yytext);
		return INT;
	} 
double {
		tokenString("KW", yytext);
		return DOUBLE;
	}  
float {
		tokenString("KW", yytext);
		return FLOAT;
	} 
string {
		tokenString("KW", yytext);
		return STRING;
	} 
bool {
		tokenString("KW", yytext);
		return BOOL;
	}  
const {
		tokenString("KW", yytext);
		return CONST;
	} 
print {
		tokenString("KW", yytext);
		return PRINT;
	} 
read {
		tokenString("KW", yytext);
		return READ;
	} 
if {
		tokenString("KW", yytext);
		return IF;
	} 
else {
		tokenString("KW", yytext);
		return ELSE;
	} 
while {
		tokenString("KW", yytext);
		return WHILE;
	} 
do {
		tokenString("KW", yytext);
		return DO;
	} 
for {
		tokenString("KW", yytext);
		return FOR;
	}  
return {
		tokenString("KW", yytext);
		return RETURN;
	} 
break {
		tokenString("KW", yytext);
		return BREAK;
	} 
continue {
		tokenString("KW", yytext);
		return CONTINUE;
	}

true | 
false {
	tokenString("KW", yytext);
	return BOOL_CONST;
}

0 |
[1-9][0-9]* {
		tokenString("integer", yytext);
		return INT_CONST;
	}
[0-9]+\.[0-9]+	{
		tokenString("float", yytext);
		return FLOAT_CONST;
	}

([0-9]+|([0-9]*\.[0-9]+))([eE][-+]?[0-9]+)	{
		tokenString("scientific", yytext);
	}
"\""	{ 
		LIST;
                strContent[0] = '\0';
		BEGIN STR;
	}
<STR>"\\"	{
		LIST;
		BEGIN STR_ESCAPE;
	}
<STR_ESCAPE>\"	{
		LIST;
		strlcat (strContent, "\"", MAX_STRING_LENGTH);
		BEGIN STR;
	}
<STR_ESCAPE>n	{
		LIST;
		strlcat( strContent, "\\n", MAX_STRING_LENGTH);
		BEGIN STR;
	}
<STR_ESCAPE>t	{
		LIST;
		strlcat( strContent, "\\t", MAX_STRING_LENGTH);
		BEGIN STR;
	}
<STR_ESCAPE>\\	{
		LIST;
		strlcat( strContent, "\\", MAX_STRING_LENGTH);
		BEGIN STR;
	}
<STR_ESCAPE>\n  {
    fprintf(stderr, "Error at line %d: %s\n", linenum, yytext);
    exit(1);
}
<STR_ESCAPE>[^\"nt\\]	{
		LIST;
		strlcat( strContent, "\\", MAX_STRING_LENGTH);
		strlcat( strContent, yytext, MAX_STRING_LENGTH);
		BEGIN STR;
	}
<STR>"\n"	{
                 fprintf(stderr,"Error at line %d: %s\n",linenum,yytext);
		exit(1);
	}

<STR>\"	{
		tokenString("string", strContent);
		BEGIN INITIAL;
		return STRING_CONST;
	}
<STR>[^\\\n\"]	{
		LIST;
		strlcat( strContent, yytext, MAX_STRING_LENGTH);
	}

"/*"	{
		LIST;
        Last_State = INITIAL;
		BEGIN COMMENT;
	}
<COMMENT>"\n"	{
		LIST;
		if(Last_State == OTHER)Last_State = INITIAL;
		if (Opt_Source)
  	        printf("%d:%s\n", linenum, buf);
		linenum++;
                buf[0] = '\0';
	}

			
<COMMENT>.	{
		LIST;
	}

<COMMENT>"*/"	{
		LIST;
		BEGIN Last_State;
	}

\/\/.*	{
		LIST;
	}

\n	{
  	      LIST;
  	      if (Opt_Source)
  	        printf("%d:%s\n", linenum, buf);
  	      linenum++;
  	      buf[0] = '\0';
        }

[a-zA-Z_][a-zA-Z0-9_]{0,255}	{
		if(Opt_Statistic){
			set(&id_head,yytext);
		}
		tokenString("id",yytext);
		return ID;
	}

.	{
		//printf("Error at wee line %d: %s\n",linenum, yytext);
                 fprintf(stderr,"Error at line %d: %s\n",linenum, yytext);
		exit(1);
	}
%%
void set(id **head, char *yytext)
{
	id *offset = *head;
	id *prev = NULL;	
	if(offset == NULL){
		*head = new_id();
		strncpy((*head)->id_name, yytext,strlen(yytext));
		(*head)->freq = 1;
	}else{
		while(offset){
			if(!strncmp(offset->id_name, yytext, (strlen(yytext)>=strlen(offset->id_name)?strlen(yytext):strlen(offset->id_name)))){
				offset->freq+=1;
				break;
			}
			prev = offset;
			offset = offset -> next;
		}
		if(!offset){
			prev->next = new_id();
			strncpy(prev->next->id_name, yytext, strlen(yytext));
			prev->next->freq+=1;
		}
	}
}
id *new_id()
{
	id *temp = (id *)malloc(sizeof(id));
	temp->next = NULL;
	memset(temp->id_name, 0, 256);
	temp->freq = 0;
	return temp;
}
			
