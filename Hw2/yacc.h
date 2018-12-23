/* A Bison parser, made by GNU Bison 3.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_YACC_H_INCLUDED
# define YY_YY_YACC_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    SEMICOLON = 258,
    COMMA = 259,
    ID = 260,
    VOID = 261,
    INT = 262,
    DOUBLE = 263,
    FLOAT = 264,
    STRING = 265,
    BOOL = 266,
    EQUAL = 267,
    CONST = 268,
    PRINT = 269,
    READ = 270,
    IF = 271,
    ELSE = 272,
    WHILE = 273,
    DO = 274,
    FOR = 275,
    RETURN = 276,
    BREAK = 277,
    CONTINUE = 278,
    INT_CONST = 279,
    FLOAT_CONST = 280,
    DOUBLE_CONST = 281,
    STRING_CONST = 282,
    BOOL_CONST = 283,
    L_CURLY = 284,
    R_CURLY = 285,
    L_SQUARE = 286,
    R_SQUARE = 287,
    L_PAREN = 288,
    R_PAREN = 289,
    MULT = 290,
    DIV = 291,
    MOD = 292,
    PLUS = 293,
    MINUS = 294,
    ST = 295,
    SE = 296,
    EQ = 297,
    GE = 298,
    GT = 299,
    NEQ = 300,
    NOT = 301,
    AND = 302,
    OR = 303
  };
#endif
/* Tokens.  */
#define SEMICOLON 258
#define COMMA 259
#define ID 260
#define VOID 261
#define INT 262
#define DOUBLE 263
#define FLOAT 264
#define STRING 265
#define BOOL 266
#define EQUAL 267
#define CONST 268
#define PRINT 269
#define READ 270
#define IF 271
#define ELSE 272
#define WHILE 273
#define DO 274
#define FOR 275
#define RETURN 276
#define BREAK 277
#define CONTINUE 278
#define INT_CONST 279
#define FLOAT_CONST 280
#define DOUBLE_CONST 281
#define STRING_CONST 282
#define BOOL_CONST 283
#define L_CURLY 284
#define R_CURLY 285
#define L_SQUARE 286
#define R_SQUARE 287
#define L_PAREN 288
#define R_PAREN 289
#define MULT 290
#define DIV 291
#define MOD 292
#define PLUS 293
#define MINUS 294
#define ST 295
#define SE 296
#define EQ 297
#define GE 298
#define GT 299
#define NEQ 300
#define NOT 301
#define AND 302
#define OR 303

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_YACC_H_INCLUDED  */
