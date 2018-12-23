#ifndef __SEM__
#define __SEM__


void checkFuncDefined(struct SymTable* table, int linenum);
void ERR_FuncDefined(int linenum, char* name);

void ERR_FuncDuplDefined(int linenum, char*name);
void ERR_FuncDuplDeclared(int linenum, char*name);

void ERR_FuncInvoke(int linenum, char*name);
void checkFuncInvoke(struct SymTable* table, char* name, int linenum);

#endif