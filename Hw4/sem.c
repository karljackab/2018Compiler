#define CORRECT 0
#define ERROR 1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "datatype.h"


void ERR_FuncDefined(int linenum, char* name)
{
	printf("##########Error at Line %d: Function %s is not defined in program.##########\n",linenum, name);
}
void checkFuncDefined(struct SymTable* table, int linenum)
{
	struct SymTableNode* temp = table->head;
	while(temp != NULL)
	{
		if(temp->kind == FUNCTION_t && !(temp->defined))
			ERR_FuncDefined(linenum, temp->name);
		temp = temp->next;
	}
}

void ERR_FuncDuplDefined(int linenum, char*name)
{
	printf("##########Error at Line %d: Function %s is already defined.##########\n",linenum, name);
}
void ERR_FuncDuplDeclared(int linenum, char*name)
{
	printf("##########Error at Line %d: Function %s is already declared.##########\n",linenum, name);
}

void ERR_FuncInvoke(int linenum, char*name)
{
	printf("##########Error at Line %d: Function %s is invoked before declared or defined.##########\n",linenum, name);
}
void checkFuncInvoke(struct SymTable* table, char* name, int linenum)
{
	struct SymTableNode* temp = table->head;
	while(temp != NULL)
	{
		if(temp->kind == FUNCTION_t && !strncmp(temp->name,name,32))
			return;
		temp = temp->next;
	}
	ERR_FuncInvoke(linenum, name);
}


// void checkConvertType()