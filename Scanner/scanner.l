

%{


#include <ctype.h>
#include <stdio.h>
#include "y.tab.h"

#define L_DEBUG_PRINT(x, y) printf("\t%s %s %d\n",yytext, x, y)

int input_line_nbr = 1;
int lex_state = 0;

%}

letter			[A-Za-z]
digit			[0-9]
whitespace		[ \t]
eol				\n
alfanum			[A-Za-z0-9_]
intcon			{digit}+

id				{letter}{alfanum}*

ch				[ -]
charcon			'({ch}|\\n|\\0)'
stringcon		\"({ch}|\n)[^\"]+\"
anything		.




%Start comment_in comment_out string_in char_in char_out

%option noyywrap


%%

[\n]	input_line_nbr++;

<INITIAL>"/*"           {
                        BEGIN(comment_in);
                        }
<comment_in>"*"      	BEGIN(comment_out);
<comment_in>[^*]     	;
<comment_out>"*"     	;
<comment_out>"/"        {
                        BEGIN(INITIAL);
                        }
<comment_out>[^*/] 	    BEGIN(comment_in);

<INITIAL>\"             {
                        BEGIN(string_in);
                        yymore();
                        }
<string_in>\"           {
                        BEGIN(INITIAL);
                        printf("\tstr -> %s\n",yytext);
                        }
<string_in>[^\"\n]      yymore();

<INITIAL>{

    "=="           {return(EQUALS);}
    "!="           {return(NOTEQU);}
    ">="           {return(GREEQU);}
    "<="           {return(LESEQU);}
    ">"            {return(GREATE);}
    "<"            {return(LESSTH);}
    "&&"           {return(ANDCOM);}
    "||"           {return(ORCOMP);}
    ";"            {return(SEMIC);}
    ","            {return(COMMA);}
    "("            {return(LPARN);}
    ")"            {return(RPARN);}
    "["            {return(LBRAC);}
    "]"            {return(RBRAC);}
    "{"            {return(LCURL);}
    "}"            {return(RCURL);}
    "!"            {return(ABANG);}
    "="            {return(EQUAL);}
    "+"            {return(ADD);}
    "-"            {return(SUB);}
    "*"            {return(MUL);}
    "/"            {return(DIV);}
            
    "for"			{return(FOR);}				
    "if"			{return(IF);}
    "else"          {return(ELSE);}
    "while"         {return(WHILE);}
    "return"        {return(RETURN);}
    "void"          {return(VOID);}

    {intcon}        {return(INTCON);}
    {charcon}       {return(CHARCON);}

    {id}			{return(ID);}
    {whitespace}    ;


    {anything}      {return(OTHER);}

}


%%


int main() {

    int result;
    while ((result=yylex())!=0) {
        printf("%d\t%s\n", result, yytext);
    }
    return 0;
}