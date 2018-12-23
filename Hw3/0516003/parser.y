%{
#include <stdio.h>
#include <stdlib.h>
#include "type.h"
#include "sym.h"


extern int linenum;
extern FILE *yyin;
extern char *yytext;
extern char buf[256];
extern int *ptr_symbol;
extern int *ptr_linenum;

int yylex();
int yyerror( char *msg );

struct SymTab* NowTable;

int level = 0;

%}

%union {
  int intVal;
  double floatVal;
  char *strVal;

  struct EntNode* nodeVal;
  struct EntList* nodeList;
}

%token  <strVal> ID
%token  <intVal> INT_CONST
%token  <floatVal> FLOAT_CONST
%token  <floatVal> SCIENTIFIC
%token  <strVal> STR_CONST

%token  LE_OP
%token  NE_OP
%token  GE_OP
%token  EQ_OP
%token  AND_OP
%token  OR_OP

%token  READ
%token  BOOLEAN
%token  WHILE
%token  DO
%token  IF
%token  ELSE
%token  <intVal> TRUE
%token  <intVal> FALSE
%token  FOR
%token  INT
%token  PRINT
%token  BOOL
%token  VOID
%token  FLOAT
%token  DOUBLE
%token  STRING
%token  CONTINUE
%token  BREAK
%token  RETURN
%token  CONST

%token  L_PAREN
%token  R_PAREN
%token  COMMA
%token  SEMICOLON
%token  ML_BRACE
%token  MR_BRACE
%token  L_BRACE
%token  R_BRACE
%token  ADD_OP
%token  SUB_OP
%token  MUL_OP
%token  DIV_OP
%token  MOD_OP
%token  ASSIGN_OP
%token  LT_OP
%token  GT_OP
%token  NOT_OP

/*  Program 
    Function 
    Array 
    Const 
    IF 
    ELSE 
    RETURN 
    FOR 
    WHILE
*/

%type <intVal> scalar_type

%type <nodeVal> const_list
%type <nodeVal> literal_const

%type <nodeVal> identifier_list
%type <nodeVal> dim

%type <nodeVal> parameter_list
%type <nodeVal> array_decl

%start program
%%

program :   
            {
                NowTable = createSymbolTable();
            } 
        decl_list funct_def decl_and_def_list 
            DelSymbolTable
        ;

decl_list : decl_list var_decl
          | decl_list const_decl
          | decl_list funct_decl
          |
          ;


decl_and_def_list : decl_and_def_list var_decl
                  | decl_and_def_list const_decl
                  | decl_and_def_list funct_decl
                  | decl_and_def_list funct_def
                  | 
                  ;

funct_def : scalar_type ID L_PAREN R_PAREN
                {
                    struct EntNode* node = createEmptNode();
                    addName(node, $2);
                    addKind(node, func_kind);
                    addLevel(node, level);
                    addType(node, $1, 1);
                    node->func_att_num = 0;
                    attToSymTab(NowTable, node, *ptr_linenum);

                    NowTable = addSymbolTable(NowTable);
                    level++;
                }
            compound_statement
            {
                NowTable = deleteSymbolTable(NowTable, *ptr_symbol);
                level--;
            }
          | scalar_type ID L_PAREN parameter_list R_PAREN 
                {
                    struct EntNode* node = createEmptNode();
                    addName(node, $2);
                    addKind(node, func_kind);
                    addLevel(node, level);
                    addType(node, $1, 1);

                    struct EntNode* para = $4;
                    int att_len = 0;
                    while(para != NULL)
                    {
                        node->func_att[att_len] = para->type;
                        att_len++;
                        para = para->next;
                    }
                    node->func_att_num = att_len;
                    attToSymTab(NowTable, node, *ptr_linenum);

                    NowTable = addSymbolTable(NowTable);
                    level++;

                    para = $4;
                    while(para != NULL)
                    {
                        para->kind = para_kind;
                        para->level = level;
                        para = para->next;
                    }
                    para = $4;
                    attToSymTab(NowTable, para, *ptr_linenum);
                }
            compound_statement
            {
                NowTable = deleteSymbolTable(NowTable, *ptr_symbol);
                level--;
            }
          | VOID ID L_PAREN R_PAREN 
                {
                    struct EntNode* node = createEmptNode();
                    addName(node, $2);
                    addKind(node, func_kind);
                    addLevel(node, level);
                    addType(node, void_type, 1);
                    node->func_att_num = 0;
                    attToSymTab(NowTable, node, *ptr_linenum);

                    NowTable = addSymbolTable(NowTable);
                    level++;
                }
            compound_statement
            {
                NowTable = deleteSymbolTable(NowTable, *ptr_symbol);
                level--;
            }
          | VOID ID L_PAREN parameter_list R_PAREN 
                {
                    struct EntNode* node = createEmptNode();
                    addName(node, $2);
                    addKind(node, func_kind);
                    addLevel(node, level);
                    addType(node, void_type, 1);

                    struct EntNode* para = $4;
                    int att_len = 0;
                    while(para != NULL)
                    {
                        node->func_att[att_len] = para->type;
                        att_len++;
                        para = para->next;
                    }
                    node->func_att_num = att_len;
                    attToSymTab(NowTable, node, *ptr_linenum);

                    NowTable = addSymbolTable(NowTable);
                    level++;

                    para = $4;
                    while(para != NULL)
                    {
                        para->kind = para_kind;
                        para->level = level;
                        para = para->next;
                    }
                    para = $4;
                    attToSymTab(NowTable, para, *ptr_linenum);
                }
            compound_statement
            {
                NowTable = deleteSymbolTable(NowTable, *ptr_symbol);
                level--;
            }
          ;

funct_decl : scalar_type ID L_PAREN R_PAREN SEMICOLON
                {
                    struct EntNode* node = createEmptNode();
                    addName(node, $2);
                    addKind(node, func_kind);
                    addLevel(node, level);
                    addType(node, $1, 1);
                    node->func_att_num = 0;
                    attToSymTab(NowTable, node, *ptr_linenum);
                }
           | scalar_type ID L_PAREN parameter_list R_PAREN SEMICOLON
                {
                    struct EntNode* node = createEmptNode();
                    addName(node, $2);
                    addKind(node, func_kind);
                    addLevel(node, level);
                    addType(node, $1, 1);

                    struct EntNode* para = $4;
                    int att_len = 0;
                    while(para != NULL)
                    {
                        node->func_att[att_len] = para->type;
                        att_len++;
                        para = para->next;
                    }
                    node->func_att_num = att_len;
                    attToSymTab(NowTable, node, *ptr_linenum);
                }
           | VOID ID L_PAREN R_PAREN SEMICOLON
                {
                    struct EntNode* node = createEmptNode();
                    addName(node, $2);
                    addKind(node, func_kind);
                    addLevel(node, level);
                    addType(node, void_type, 1);
                    node->func_att_num = 0;
                    attToSymTab(NowTable, node, *ptr_linenum);
                }
           | VOID ID L_PAREN parameter_list R_PAREN SEMICOLON
                {
                    struct EntNode* node = createEmptNode();
                    addName(node, $2);
                    addKind(node, func_kind);
                    addLevel(node, level);
                    addType(node, void_type, 1);

                    struct EntNode* para = $4;
                    int att_len = 0;
                    while(para != NULL)
                    {
                        node->func_att[att_len] = para->type;
                        att_len++;
                        para = para->next;
                    }
                    node->func_att_num = att_len;
                    attToSymTab(NowTable, node, *ptr_linenum);
                }
           ;

parameter_list : parameter_list COMMA scalar_type ID
                    {
                        struct EntNode* node = createEmptNode();
                        addType(node, $3, 1);
                        addName(node, $4);
                        addLevel(node, level);
                        addKind(node, para_kind);

                        struct EntNode* temp = $1;
                        while(temp->next != NULL)
                            temp = temp->next;
                        temp->next = node;
                        $$ = $1;
                    }
               | parameter_list COMMA scalar_type array_decl
                    {
                        struct EntNode* node = $4;
                        addType(node, $3, 1);
                        addLevel(node, level);
                        addKind(node, para_kind);

                        struct EntNode* temp = $1;
                        while(temp->next != NULL)
                            temp = temp->next;
                        temp->next = node;
                        $$ = $1;
                    }
               | scalar_type array_decl
                    {
                        struct EntNode* node = $2;
                        addType(node, $1, 1);
                        addLevel(node, level);
                        addKind(node, para_kind);
                        $$ = node;
                    }
               | scalar_type ID
                    {
                        struct EntNode* node = createEmptNode();
                        addType(node, $1, 1);
                        addName(node, $2);
                        addLevel(node, level);
                        addKind(node, para_kind);
                        $$ = node;
                    }
               ;

var_decl : scalar_type identifier_list SEMICOLON
            {
                struct EntNode* node = $2;
                while(node != NULL)
                {
                    addKind(node, var_kind);
                    addLevel(node, level);
                    addType(node, $1, 1);
                    node = node->next;
                }
                attToSymTab(NowTable, $2, *ptr_linenum);
            }
         ;

identifier_list : identifier_list COMMA ID
                    {
                        struct EntNode* temp = $1;
                        struct EntNode* node = createEmptNode();
                        addName(node, $3);
                        while(temp->next!=NULL)
                            temp = temp->next;
                        temp->next = node;
                        $$ = $1;
                    }
                | identifier_list COMMA ID ASSIGN_OP logical_expression
                    {
                        struct EntNode* temp = $1;
                        struct EntNode* node = createEmptNode();
                        addName(node, $3);
                        while(temp->next!=NULL)
                            temp = temp->next;
                        temp->next = node;
                        $$ = $1;
                    }
                | identifier_list COMMA array_decl ASSIGN_OP initial_array
                    {
                        struct EntNode* temp = $1;
                        struct EntNode* node = $3;
                        while(temp->next!=NULL)
                            temp = temp->next;
                        temp->next = node;
                        $$ = $1;
                    }
                | identifier_list COMMA array_decl
                | array_decl ASSIGN_OP initial_array
                    {
                        $$ = $1;
                    }
                | array_decl
                    {
                        $$ = $1;
                    }
                | ID ASSIGN_OP logical_expression
                    {
                        struct EntNode* node = createEmptNode();
                        addName(node, $1);
                        $$ = node;
                    }
                | ID 
                    {
                        struct EntNode* node = createEmptNode();
                        addName(node, $1);
                        $$ = node;
                    }
                ;

initial_array : L_BRACE literal_list R_BRACE
              ;

literal_list : literal_list COMMA logical_expression
             | logical_expression
             | 
             ;

const_decl : CONST scalar_type const_list SEMICOLON
            {
                struct EntNode *head = $3, *temp = head;
                while(temp != NULL)
                {
                    if(temp->type == int_type)
                        if($2 == float_type || $2 == double_type)
                            temp->const_att.float_val = temp->const_att.int_val;
                    temp->type = $2;
                    temp = temp->next;
                }
                attToSymTab(NowTable, head, *ptr_linenum);
            };

const_list : const_list COMMA ID ASSIGN_OP literal_const
              {
                struct EntNode *node = $5, *temp = $1;
                addName(node, $3);

                while(temp->next != NULL)
                    temp = temp->next;
                temp->next = node;

                $$ = $1;
              }
           | ID ASSIGN_OP literal_const
              {
                struct EntNode *node = $3;
                addName(node, $1);

                $$ = node;
              }
           ;

array_decl : ID dim
            {
                struct EntNode* node = $2;
                addName(node, $1);
                $$ = node;
            }
           ;

dim : dim ML_BRACE INT_CONST MR_BRACE
        {
            struct EntNode* node = $1;
            node->type_size ++;
            node->arr_size[node->type_size-2] = $3;
            $$ = node;
        }
    | ML_BRACE INT_CONST MR_BRACE
        {
            struct EntNode* node = createEmptNode();
            node->type_size = 2;
            node->arr_size[0] = $2;
            $$ = node;
        }
    ;

compound_statement : L_BRACE var_const_stmt_list R_BRACE
                    ;

var_const_stmt_list : var_const_stmt_list statement 
                    | var_const_stmt_list var_decl
                    | var_const_stmt_list const_decl
                    |
                    ;

statement : compound_statement
          | simple_statement
          | conditional_statement
          | while_statement
          | for_statement
          | function_invoke_statement
          | jump_statement
          ;     

simple_statement : variable_reference ASSIGN_OP logical_expression SEMICOLON
                 | PRINT logical_expression SEMICOLON
                 | READ variable_reference SEMICOLON
                 ;

NewSymbolTable : {
                    NowTable = addSymbolTable(NowTable);
                    level++;
                }

DelSymbolTable : {
                    NowTable = deleteSymbolTable(NowTable, *ptr_symbol);
                    level--;
                }


conditional_statement : IF L_PAREN logical_expression R_PAREN L_BRACE 
                        NewSymbolTable
                        var_const_stmt_list R_BRACE
                        DelSymbolTable
                      | IF L_PAREN logical_expression R_PAREN L_BRACE 
                        NewSymbolTable
                        var_const_stmt_list R_BRACE
                        DelSymbolTable
                        ELSE L_BRACE
                        NewSymbolTable
                        var_const_stmt_list R_BRACE
                        DelSymbolTable
                      ;
while_statement : WHILE L_PAREN logical_expression R_PAREN L_BRACE 
                    {
                        NowTable = addSymbolTable(NowTable);
                        level++;
                    }
                    var_const_stmt_list R_BRACE
                    {
                        NowTable = deleteSymbolTable(NowTable, *ptr_symbol);
                        level--;
                    }
                | DO L_BRACE
                    {
                        NowTable = addSymbolTable(NowTable);
                        level++;
                    }
                    var_const_stmt_list
                    R_BRACE
                    {
                        NowTable = deleteSymbolTable(NowTable, *ptr_symbol);
                        level--;
                    } WHILE L_PAREN logical_expression R_PAREN SEMICOLON
                ;

for_statement : FOR L_PAREN initial_expression_list SEMICOLON control_expression_list SEMICOLON increment_expression_list R_PAREN 
                    L_BRACE
                    {
                        NowTable = addSymbolTable(NowTable);
                        level++;
                    }
                var_const_stmt_list R_BRACE
                    {
                        NowTable = deleteSymbolTable(NowTable, *ptr_symbol);
                        level--;
                    }
              ;


initial_expression_list : initial_expression
                        |
                        ;

initial_expression : initial_expression COMMA variable_reference ASSIGN_OP logical_expression
                   | initial_expression COMMA logical_expression
                   | logical_expression
                   | variable_reference ASSIGN_OP logical_expression

control_expression_list : control_expression
                        |
                        ;

control_expression : control_expression COMMA variable_reference ASSIGN_OP logical_expression
                   | control_expression COMMA logical_expression
                   | logical_expression
                   | variable_reference ASSIGN_OP logical_expression
                   ;

increment_expression_list : increment_expression 
                          |
                          ;

increment_expression : increment_expression COMMA variable_reference ASSIGN_OP logical_expression
                     | increment_expression COMMA logical_expression
                     | logical_expression
                     | variable_reference ASSIGN_OP logical_expression
                     ;

function_invoke_statement : ID L_PAREN logical_expression_list R_PAREN SEMICOLON
                          | ID L_PAREN R_PAREN SEMICOLON
                          ;

jump_statement : CONTINUE SEMICOLON
               | BREAK SEMICOLON
               | RETURN logical_expression SEMICOLON
               ;

variable_reference : array_list
                   | ID
                   ;


logical_expression : logical_expression OR_OP logical_term
                   | logical_term
                   ;

logical_term : logical_term AND_OP logical_factor
             | logical_factor
             ;

logical_factor : NOT_OP logical_factor
               | relation_expression
               ;

relation_expression : relation_expression relation_operator arithmetic_expression
                    | arithmetic_expression
                    ;

relation_operator : LT_OP
                  | LE_OP
                  | EQ_OP
                  | GE_OP
                  | GT_OP
                  | NE_OP
                  ;

arithmetic_expression : arithmetic_expression ADD_OP term
                      | arithmetic_expression SUB_OP term
                      | term
                      ;

term : term MUL_OP factor
     | term DIV_OP factor
     | term MOD_OP factor
     | factor
     ;

factor : SUB_OP factor
       | literal_const
       | variable_reference
       | L_PAREN logical_expression R_PAREN
       | ID L_PAREN logical_expression_list R_PAREN
       | ID L_PAREN R_PAREN
       ;

logical_expression_list : logical_expression_list COMMA logical_expression
                        | logical_expression
                        ;

array_list : ID dimension
           ;

dimension : dimension ML_BRACE logical_expression MR_BRACE
          | ML_BRACE logical_expression MR_BRACE
          ;



scalar_type : INT   {$$ = int_type;}
            | DOUBLE  {$$ = double_type;}
            | STRING  {$$ = str_type;}
            | BOOL  {$$ = bool_type;}
            | FLOAT   {$$ = float_type;}
            ;
 
literal_const : INT_CONST   
                {
                    struct EntNode* node = createEmptNode();
                    union ConstAtt val;
                    val.int_val = $1;
                    addKind(node, const_kind);
                    addLevel(node ,level);
                    addType(node, int_type, 1);
                    addConstAtt(node, val);
                    $$ = node;
                }
              | FLOAT_CONST
                {
                    struct EntNode* node = createEmptNode();
                    union ConstAtt val;
                    val.float_val = $1;
                    addKind(node, const_kind);
                    addLevel(node ,level);
                    addType(node, float_type, 1);
                    addConstAtt(node, val);
                    $$ = node;
                }
              | SCIENTIFIC
                {
                    struct EntNode* node = createEmptNode();
                    union ConstAtt val;
                    val.float_val = $1;
                    addKind(node, const_kind);
                    addLevel(node ,level);
                    addType(node, float_type, 1);
                    addConstAtt(node, val);
                    $$ = node;
                }
              | STR_CONST
                {
                    struct EntNode* node = createEmptNode();
                    union ConstAtt val;
                    val.str_val = $1;
                    addKind(node, const_kind);
                    addLevel(node ,level);
                    addType(node, str_type, 1);
                    addConstAtt(node, val);
                    $$ = node;
                }
              | TRUE
                {
                    struct EntNode* node = createEmptNode();
                    union ConstAtt val;
                    val.int_val = 1;
                    addKind(node, const_kind);
                    addLevel(node ,level);
                    addType(node, bool_type, 1);
                    addConstAtt(node, val);
                    $$ = node;
                }
              | FALSE
                {
                    struct EntNode* node = createEmptNode();
                    union ConstAtt val;
                    val.int_val = 0;
                    addKind(node, const_kind);
                    addLevel(node ,level);
                    addType(node, bool_type, 1);
                    addConstAtt(node, val);
                    $$ = node;
                }
              ;


%%

int yyerror( char *msg )
{
    fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
    fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
    fprintf( stderr, "|\n" );
    fprintf( stderr, "| Unmatched token: %s\n", yytext );
    fprintf( stderr, "|--------------------------------------------------------------------------\n" );
    exit(-1);
    //  fprintf( stderr, "%s\t%d\t%s\t%s\n", "Error found in Line ", linenum, "next token: ", yytext );
}


