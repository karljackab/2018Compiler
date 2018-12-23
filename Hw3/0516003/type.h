#ifndef _TYPE_H_
#define _TYPE_H_

#define func_kind 0
#define para_kind 1
#define var_kind 2
#define const_kind 3

#define int_type 10
#define float_type 11
#define double_type 12
#define bool_type 13
#define str_type 14
#define void_type 15

union ConstAtt{
	int int_val;
	double float_val;
	char* str_val;
};

struct EntNode{
	char name[35];
	int kind;
	int level;
	int type;
	int type_size;
	int arr_size[20];
	union ConstAtt const_att;
	int func_att[30];
	int func_att_num;
	struct EntNode *next;
};

struct SymTab{
	struct SymTab *next;
	struct SymTab *pre;
	struct EntNode *node;
};


#endif