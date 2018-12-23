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
    STRING_CONST = 281,
    BOOL_CONST = 282,
    L_CURLY = 283,
    R_CURLY = 284,
    L_SQUARE = 285,
    R_SQUARE = 286,
    L_PAREN = 287,
    R_PAREN = 288,
    MULT = 289,
    DIV = 290,
    MOD = 291,
    PLUS = 292,
    MINUS = 293,
    ST = 294,
    SE = 295,
    EQ = 296,
    GE = 297,
    GT = 298,
    NEQ = 299,
    NOT = 300,
    AND = 301,
    OR = 302
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
#define STRING_CONST 281
#define BOOL_CONST 282
#define L_CURLY 283
#define R_CURLY 284
#define L_SQUARE 285
#define R_SQUARE 286
#define L_PAREN 287
#define R_PAREN 288
#define MULT 289
#define DIV 290
#define MOD 291
#define PLUS 292
#define MINUS 293
#define ST 294
#define SE 295
#define EQ 296
#define GE 297
#define GT 298
#define NEQ 299
#define NOT 300
#define AND 301
#define OR 302

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_YACC_H_INCLUDED  */
