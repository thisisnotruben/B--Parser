%{

#include <stdio.h>

#define YDEBUG 0

#define Y_DEBUG_PRINT(x) \
	if (YDEBUG) \
		printf("Yout %s \n ",x)

#ifndef YDEBUG
	#undef Y_DEBUG_PRINT(x)
	#define Y_DEBUG_PRINT(x)
#endif // YDEBUG

void yyerror(char const *);
void warn(char const *s);

extern int yylex(void);
extern char the_token[];
extern int input_line_nbr;
extern char *full_line;
extern int lex_state;

%}

%token STRINGCON CHARCON INTCON EQUALS NOTEQU GREEQU LESEQU GREATE LESSTH
%token ANDCOM ORCOMP SEMIC COMMA LPARN RPARN LBRAC RBRAC LCURL RCURL ABANG
%token EQUAL ADD SUB MUL DIV ID EXTERN FOR WHILE RETURN IF ELSE
%token VOID CHAR INT OTHER

%nonassoc PREC_LOWER_THAN_ELSE
%nonassoc ELSE
%nonassoc PREC_LOGOP
%nonassoc PREC_RELOP
%nonassoc PRECBINOP

%left ORCOMP
%left ANDCOM
%left EQUALS NOTEQU
%left LESSTH GREATE LESEQU GREEQU
%left ADD SUB
%left MUL DIV
%right UMINUS
%right ABANG

%%

Prog
	: Stmt
	| Prog Stmt
	;

Stmt
	: IF LPARN Expr RPARN Stmt %prec PREC_LOWER_THAN_ELSE		/* TODO: doesn't recognize SEMIC */
	| IF LPARN Expr RPARN Stmt ELSE Stmt
	| WHILE LPARN Expr RPARN Stmt
	| FOR LPARN StmtForAssign SEMIC StmtForExpr SEMIC StmtForAssign RPARN Stmt
	| RETURN StmtReturn SEMIC
	| Assign SEMIC
	| ID LPARN StmtId RPARN SEMIC
	| LCURL Stmt RCURL			/* TODO: needs to be repetitive */
	| SEMIC
	;

Assign
	: ID Assign1 EQUAL Expr	{Y_DEBUG_PRINT("Assign-1-ID-Assign1-EQUAL-Expr"); }
	;

Expr
	: SUB Expr %prec UMINUS				{ Y_DEBUG_PRINT("Expr-1-UMINUS Expr"); }
	| ABANG Expr						{ Y_DEBUG_PRINT("Expr-2-ANABG Expr"); }
	| Expr Logop Expr %prec PREC_LOGOP	{ Y_DEBUG_PRINT("Expr-3-Expr-Logop-Expr"); }
	| Expr Relop Expr %prec PREC_RELOP	{ Y_DEBUG_PRINT("Expr-3-Expr-Relop-Expr"); }
	| Expr Binop Expr %prec PRECBINOP	{ Y_DEBUG_PRINT("Expr-3-Expr-Binop-Expr"); }
	| ID ExprId							{ Y_DEBUG_PRINT("Expr-6-ID"); }
	| LPARN Expr RPARN					{ Y_DEBUG_PRINT("Expr-7-LPARN-Expr-RPARN");}
	| INTCON							{ Y_DEBUG_PRINT("Expr-8-INTCON"); }
	| CHARCON							{ Y_DEBUG_PRINT("Expr-9-CHARCON"); }
	| STRINGCON							{ Y_DEBUG_PRINT("Expr-10-STRINGCON"); }
	| error								{ warn(":invalid expression "); }
	;

Binop
	: ADD					{ Y_DEBUG_PRINT("Binop-1-ADD"); }
	| SUB					{ Y_DEBUG_PRINT("Binop-2-SUB"); }
	| MUL					{ Y_DEBUG_PRINT("Binop-3-MUL"); }
	| DIV					{ Y_DEBUG_PRINT("Binop-4-DIV"); }
	;

Relop
	: EQUALS				{ Y_DEBUG_PRINT("Relop-1-EQUALS"); }
	| NOTEQU				{ Y_DEBUG_PRINT("Relop-2-NOTEQU"); }
	| LESEQU				{ Y_DEBUG_PRINT("Relop-3-LESEQU"); }
	| LESSTH				{ Y_DEBUG_PRINT("Relop-6-LESSTH"); }
	| GREEQU				{ Y_DEBUG_PRINT("Relop-4-GREEQU"); }
	| GREATE				{ Y_DEBUG_PRINT("Relop-5-GREATE"); }
	;

Logop
	: ANDCOM				{ Y_DEBUG_PRINT("Logop-1-ANDCOM"); }
	| ORCOMP				{ Y_DEBUG_PRINT("Logop-2-ORCOMP"); }
	;

Assign1
	:						{ Y_DEBUG_PRINT("Assign1-1-Empty"); }
	| LBRAC Expr RBRAC		{ Y_DEBUG_PRINT("Assign1-2-LBRAC-Expr-RBRAC"); }
	;

StmtReturn
	:
	| Expr
	;

StmtId
	:
	| ExprList
	;

StmtForAssign
	:
	| Assign
	;

StmtForExpr
	:
	| Expr
	;

ExprList
	: Expr
	| ExprList COMMA Expr
	;

ExprId
	:
	| LPARN StmtId RPARN
	| LBRAC Expr RBRAC
	| error RBRAC
	;

%%

int main(int argc, char **argv)
{
	int result = yyparse();

	if (lex_state == 1)
	{
		yyerror("End of file within a comment");
	}
	else if (lex_state == 2)
	{
		yyerror("End of file within a string");
	}

	return result;
}

int yywrap() { return 1; }

void yyerror(char const *s) { fprintf(stderr, "%s on line %d", s, input_line_nbr); }

void warn(char const *s) { fprintf(stderr, "%s\n", s); }
