#ifndef _SYM_H_
#define _SYM_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "type.h"


struct SymTab* createSymbolTable();
struct SymTab* addSymbolTable(struct SymTab* now);
struct SymTab* deleteSymbolTable(struct SymTab* now, int symbol);


double _sciToFlo(char *sci);
char* _changeKind(int num);
char* _changeType(int num);


struct SymTab* attToSymTab(struct SymTab* now, struct EntNode* node, int line);
struct EntNode* createEmptNode();
struct EntNode* addName(struct EntNode* node, char* name);
struct EntNode* addKind(struct EntNode* node, int kind);
struct EntNode* addLevel(struct EntNode* node, int level);
struct EntNode* addType(struct EntNode* node, int type, int type_size);
struct EntNode* addConstAtt(struct EntNode* node, union ConstAtt att);

#endif