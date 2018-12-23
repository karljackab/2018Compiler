#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "type.h"


/*   ==================   kind & Type   ==================   */

double _sciToFlo(char *sci)
{
	char temp[100];
	strncpy(temp, sci, 100);
	char *token = strtok(temp,"Ee \t\n");
	double num = atof(token);
	token = strtok(NULL, "Ee \t\n");
	int exp = atoi(token);

	if(exp)
		num *= pow(10, exp);

	return num;
}

char* _changeKind(int num)
{
	if(num == func_kind)
		return "function";
	else if(num == para_kind)
		return "parameter";
	else if(num == var_kind)
		return "variable";
	else if(num == const_kind)
		return "constant";
	else
		return "KindError";
}

char* _changeType(int num)
{
	if(num == int_type)
		return "int";
	else if(num == float_type)
		return "float";
	else if(num == double_type)
		return "double";
	else if(num == bool_type)
		return "bool";
	else if(num == str_type)
		return "string";
	else if(num == void_type)
		return "void";
	else
		return "TypeError";
}


/*   ======================   Symbol Table   ======================   */
struct SymTab* createSymbolTable()
{
	struct SymTab *newSymTab = (struct SymTab *)malloc(sizeof(struct SymTab));
	newSymTab->next = NULL;
	newSymTab->pre = NULL;
	newSymTab->node = NULL;
	return newSymTab;
}

struct SymTab* addSymbolTable(struct SymTab* now)
{
	struct SymTab *newSymTab = (struct SymTab *)malloc(sizeof(struct SymTab));
	newSymTab->next = NULL;
	newSymTab->pre = now;
	newSymTab->node = NULL;
	now->next = newSymTab;
	return newSymTab;
}

struct SymTab* deleteSymbolTable(struct SymTab* now, int symbol)
{
	struct EntNode* Node = now->node;
	struct EntNode* temp;
	if(symbol)
	{
		printf("=======================================================================================\n");
		printf("Name                             Kind       Level       Type               Attribute               \n");
		printf("---------------------------------------------------------------------------------------\n");
		int i;
		while(Node!=NULL)
		{
			// name
			printf("%-29s\t", Node->name);

			// kind
			printf("%s\t", _changeKind(Node->kind));

			// level
			if(!Node->level)
				printf("0(global)\t");
			else
				printf("%d(local)\t", Node->level);

			// type
			if(Node->type_size > 1)
			{
				printf("%s", _changeType(Node->type),Node->type_size);
				int i;
				for(i=1;i<Node->type_size;i++)
					printf("[%d]",Node->arr_size[i-1]);
				printf("\t");
			}
			else
				printf("%s\t", _changeType(Node->type));


			// Attribute
			if(Node->kind == const_kind)		// constant
			{
				if(Node->type == float_type || Node->type == double_type)
					printf("%lf", Node->const_att.float_val);
				else if(Node->type == str_type)
					printf("%s", Node->const_att.str_val);
				else if(Node->type == bool_type)
				{
					if(Node->const_att.int_val == 1)
						printf("true");
					else
						printf("false");
				}
				else
					printf("%d", Node->const_att.int_val);
			}
			else if(Node->kind == func_kind)	// function
			{
				for(i=0;i<Node->func_att_num-1;i++)
					printf("%s,", _changeType(Node->func_att[i]));
				if(i<Node->func_att_num)	// if function has parameter(s)
					printf("%s", _changeType(Node->func_att[i]));
			}
			printf("\n");
			temp = Node->next;
			free(Node);
			Node = temp;
		}
		printf("======================================================================================\n\n");
	}
	
	struct SymTab *pre = now->pre;
	free(now);
	return pre;
}

/*   ============================================   */

struct SymTab* attToSymTab(struct SymTab* now, struct EntNode* node, int line)
{
	struct EntNode* temp;
	if(now->node == NULL)
		now->node = node;
	else
	{
		int err;
		while(node != NULL)
		{
			err = 0;	// 0 no error, 1 error, 2 function duplicate(definition and declar)
			struct EntNode* temp = now->node;
			while(1)
			{
				if(!strcmp(temp->name, node->name))
					if(temp->kind == func_kind && node->kind == func_kind)
					{
						err = 2;
					}
					else
					{
						err = 1;
						break;
					}
				if(temp->next == NULL)
					break;
				temp = temp->next;
			}

			if(err == 1)
			{
				printf("##########Error at Line %d: %s redeclared.##########\n", line, temp->name);
				node = node->next;
			}
			else if(err == 0)
			{
				temp->next = node;
				node = node->next;
				temp->next->next = NULL;
			}
			else
				node = node->next;
		}
	}
	return now;
}


struct EntNode* createEmptNode()
{
	struct EntNode *newEntNode = (struct EntNode *)malloc(sizeof(struct EntNode));
	newEntNode->next = NULL;
	return newEntNode;
}

struct EntNode* addName(struct EntNode* node, char* name)
{
	strncpy(node->name, name, 32);
	return node;
}
struct EntNode* addKind(struct EntNode* node, int kind)
{
	node->kind = kind;
	return node;
}

struct EntNode* addLevel(struct EntNode* node, int level)
{
	node->level = level;
	return node;
}
struct EntNode* addType(struct EntNode* node, int type, int type_size)
{
	node->type = type;
	node->type_size = type_size;
	return node;
}
struct EntNode* addConstAtt(struct EntNode* node, union ConstAtt att)
{
	switch(node->type)
	{
		case int_type:
		case bool_type:
			node->const_att.int_val = att.int_val;
			break;
		case float_type:
			node->const_att.float_val = att.float_val;
			break;
		case str_type:
			node->const_att.str_val = att.str_val;
	}
	return node;
}