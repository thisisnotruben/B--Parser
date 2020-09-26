%{

#include "y.tab.h"

#define DEBUG_LEX 1

int input_line_nbr = 1, lex_state = 0;

%}

letter			[A-Za-z]
digit			[0-9]
whitespace		[ \t]
ch				[ -]
alfanum			[A-Za-z0-9_]
eol				\n
anything		.
id				{letter}{alfanum}*
charcon			'({ch}|\\n|\\0)'
intcon			{digit}+
stringcon		\"({ch}|\n)[^\"]+\"

%s COMMENT STRING
%option noyywrap

%%
<INITIAL>{

	"/*"			{ BEGIN(COMMENT); }
	\"				{ BEGIN(STRING); yymore(); }

	"=="			{ return EQUALS; }
	"!="			{ return NOTEQU; }
	">="			{ return GREEQU; }
	"<="			{ return LESEQU; }
	">" 			{ return GREATE; }
	"<" 			{ return LESSTH; }
	"&&"			{ return ANDCOM; }
	"||"			{ return ORCOMP; }
	";" 			{ return SEMIC; }
	"," 			{ return COMMA; }
	"(" 			{ return LPARN; }
	")" 			{ return RPARN; }
	"[" 			{ return LBRAC; }
	"]" 			{ return RBRAC; }
	"{" 			{ return LCURL; }
	"}" 			{ return RCURL; }
	"!" 			{ return ABANG; }
	"=" 			{ return EQUAL; }
	"+" 			{ return ADD; }
	"-" 			{ return SUB; }
	"*" 			{ return MUL; }
	"/" 			{ return DIV; }
	"for"			{ return FOR; }
	"if"			{ return IF; }
	"else"			{ return ELSE; }
	"while"			{ return WHILE; }
	"return"		{ return RETURN; }
	"void"			{ return VOID; }
	{intcon}		{ return INTCON; }
	{charcon}		{ return CHARCON; }
	{id}			{ return ID; }
	{whitespace}	{ ; }
	{eol}			{ input_line_nbr++; }
	{anything}		{ return OTHER; }

}

<STRING>{

	\"				{ BEGIN(INITIAL); return STRINGCON; }
	[^\"\n]			{ yymore(); }

}

<COMMENT>{

	"*/"			{ BEGIN(INITIAL); }
	{eol}			{ input_line_nbr++; }
	{anything}		{ ; }

}

%%
#if DEBUG_LEX
	int main(int argc, char **argv)
	{
		int result;

		while ((result = yylex()) != 0)
		{
			printf("%d\t%s\n", result, yytext);
		}

		return 0;
	}
#endif
