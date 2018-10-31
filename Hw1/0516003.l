%{
	#define MAX_LINE_LENGTH 257
	#define MAX_ID_LENGTH 257
	int Opt_Source = 1;
	int Opt_Token = 1;
	int Opt_Statistic = 1;
	int linenum = 1;
	char buf[MAX_LINE_LENGTH];
	int pre_stat; // 1=initial, 2=prag
	int count[1000],length=0,i;
	char name[1000][258];
	char str_tmp[1000];
	int len_tmp;
	#define LIST { strncat(buf, yytext, sizeof(buf) - strlen(buf) - 1); }
	#define token(t) { LIST; if (Opt_Token) printf("<%s>\n", #t); }
	void tokenString(char *t, char *s) {
		LIST;
		if (Opt_Token)
			printf("<%s:%s>\n", t, s);
		if(!strcmp(t,"id")&&Opt_Statistic)
		{
			int find=0;
			for(i=0;i<length;i++)
				if(!strcmp(name[i],s))
				{
					find=1;
					break;
				}
			if(find)
				count[i]++;
			else
			{
				strcpy(name[i],s);
				count[i]=1;
				length++;
			}
		}
	}
%}

delim \,|\;|\(|\)|\[|\]|\{|\}
KW while|do|if|else|true|false|for|int|print|const|read|boolean|bool|void|float|double|string|continue|break|return
letter [a-zA-Z]
digit [0-9]
id {letter}({letter}|{digit})*
integer 0|[1-9][0-9]*
float {digit}+\.{digit}+
scientific ({integer}|{float})[Ee][+-]?{digit}+
space [ \t]

%Start MULTI_COMMENT COMMENT PRAG WITH_SPACE STRING STRING_JUMP
%%
<INITIAL>{space} {LIST; BEGIN WITH_SPACE;}
<WITH_SPACE>{space} {LIST; BEGIN WITH_SPACE;}
<COMMENT>{space} LIST;
<MULTI_COMMENT>{space} LIST;
<INITIAL>{delim} tokenString("delim", yytext);
<INITIAL>"+" token("+");
<INITIAL>"-" token("-");
<INITIAL>"*" token("*");
<INITIAL>"/" token("/");
<INITIAL>"%" token("%");
<INITIAL>"=" token("=");
<INITIAL>"<" token("<");
<INITIAL>"<=" token("<=");
<INITIAL>"!=" token("!=");
<INITIAL>">=" token(">=");
<INITIAL>">" token(">");
<INITIAL>"==" token("==");
<INITIAL>"&&" token("&&");
<INITIAL>"||" token("||");
<INITIAL>"!" token("!");
<INITIAL>{KW} tokenString("KW", yytext);
<INITIAL>{id} tokenString("id", yytext);
<INITIAL>{integer} tokenString("integer", yytext);
<INITIAL>{float} tokenString("float", yytext);
<INITIAL>{scientific} tokenString("scientific", yytext);
<INITIAL>"\"" {
	LIST;
	len_tmp = 0;
	BEGIN STRING;
}

<WITH_SPACE>{delim} tokenString("delim", yytext);
<WITH_SPACE>"+" token("+");
<WITH_SPACE>"-" token("-");
<WITH_SPACE>"*" token("*");
<WITH_SPACE>"/" token("/");
<WITH_SPACE>"%" token("%");
<WITH_SPACE>"=" token("=");
<WITH_SPACE>"<" token("<");
<WITH_SPACE>"<=" token("<=");
<WITH_SPACE>"!=" token("!=");
<WITH_SPACE>">=" token(">=");
<WITH_SPACE>">" token(">");
<WITH_SPACE>"==" token("==");
<WITH_SPACE>"&&" token("&&");
<WITH_SPACE>"||" token("||");
<WITH_SPACE>"!" token("!");
<WITH_SPACE>{KW} tokenString("KW", yytext);
<WITH_SPACE>{id} tokenString("id", yytext);
<WITH_SPACE>{integer} tokenString("integer", yytext);
<WITH_SPACE>{float} tokenString("float", yytext);
<WITH_SPACE>{scientific} tokenString("scientific", yytext);
<WITH_SPACE>"\"" {
	LIST;
	len_tmp = 0;
	BEGIN STRING;
}

<STRING>"\\" BEGIN STRING_JUMP;
<STRING>"\"" {
	str_tmp[len_tmp] = '\0';
	tokenString("string",str_tmp);
	BEGIN WITH_SPACE;
}
<STRING>[^\n] {
	LIST;
	str_tmp[len_tmp] = *yytext;
	len_tmp++;
}
<STRING>\n { // Unrecognized character
	fprintf(stderr, "Error at line %d: %s\n", linenum, yytext);
	exit(1);
}

<STRING_JUMP>[\\\"] {
	LIST;
	str_tmp[len_tmp] = *yytext;
	len_tmp++;
	BEGIN STRING;
}


<INITIAL>#pragma{space}+token{space}+on{space}* {
	LIST;
	Opt_Token = 1;
	BEGIN PRAG;
}
<INITIAL>#pragma{space}+token{space}+off{space}* {
	LIST;
	Opt_Token = 0;
	BEGIN PRAG;
}
<INITIAL>#pragma{space}+source{space}+on{space}* {
	LIST;
	Opt_Source = 1;
	BEGIN PRAG;
}
<INITIAL>#pragma{space}+source{space}+off{space}* {
	LIST;
	Opt_Source = 0;
	BEGIN PRAG;
}
<INITIAL>#pragma{space}+statistic{space}+on{space}* {
	LIST;
	Opt_Statistic = 1;
	BEGIN PRAG;
}
<INITIAL>#pragma{space}+statistic{space}+off{space}* {
	LIST;
	Opt_Statistic = 0;
	BEGIN PRAG;
}

<PRAG>"/*" {
	LIST;
	pre_stat = 2;
	BEGIN MULTI_COMMENT;
}
<PRAG>"//" {
	LIST;
	BEGIN COMMENT;
}
<PRAG>. {
	fprintf(stderr, "Error at line %d: %s\n", linenum, yytext);
	exit(1);
}

<INITIAL>"/*" {
	LIST;
	pre_stat = 1;
	BEGIN MULTI_COMMENT;
}
<WITH_SPACE>"/*" {
	LIST;
	pre_stat = 1;
	BEGIN MULTI_COMMENT;
}
<MULTI_COMMENT>"*/" {
	LIST;
	if(pre_stat==1)
		BEGIN WITH_SPACE;
	else 
		BEGIN PRAG;
}
<MULTI_COMMENT>\n {
	LIST;
	if (Opt_Source)
		printf("%d:%s\n", linenum, buf);
	++linenum;
	buf[0] = '\0';
	pre_stat = 1;
}
<MULTI_COMMENT>. LIST;

\n {
	LIST;
	if (Opt_Source)
		printf("%d:%s\n", linenum, buf);
	++linenum;
	buf[0] = '\0';
	BEGIN INITIAL;
}


<INITIAL>"//" {
	LIST;
	BEGIN COMMENT;
}
<WITH_SPACE>"//" {
	LIST;
	BEGIN COMMENT;
}
<COMMENT>. LIST;


. { // Unrecognized character
	fprintf(stderr, "Error at line %d: %s\n", linenum, yytext);
	exit(1);
}
%%

int main( int argc, char **argv )
{
	if (argc >= 2)
	{
		yyin = fopen( argv[1], "r" );
		if ( NULL == yyin ) {
			fprintf( stderr, "Cannot open: %s\n", argv[1] );
			exit(-1);
		}
	}
	else
	{
		yyin = stdin;
	}

	yylex();

	if(buf[0]!='\0'&&Opt_Source)
		printf("%d:%s\n", linenum, buf);

	if (Opt_Statistic)
	{
		printf("frequencies of identifiers:\n");
		int i=0;
		for(i=0;i<length;i++)
			printf("%s\t%d\n",name[i],count[i]);
	}

	exit(0);
}