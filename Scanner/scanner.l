

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
intcon			[digit]+

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

<INITIAL>"=="           {return(EQUALS);}
<INITIAL>"!="           {return(NOTEQU);}
<INITIAL>">="           {return(GREEQU);}
<INITIAL>"<="           {return(LESEQU);}
<INITIAL>">"            {return(GREATE);}
<INITIAL>"<"            {return(LESSTH);}
<INITIAL>"&&"           {return(ANDCOM);}
<INITIAL>"||"           {return(ORCOMP);}
<INITIAL>";"            {return(SEMIC);}
<INITIAL>","            {return(COMMA);}
<INITIAL>"("            {return(LPARN);}
<INITIAL>")"            {return(RPARN);}
<INITIAL>"["            {return(LBRAC);}
<INITIAL>"]"            {return(RBRAC);}
<INITIAL>"{"            {return(LCURL);}
<INITIAL>"}"            {return(RCURL);}
<INITIAL>"="            {return(EQUAL);}
<INITIAL>"+"            {return(ADD);}
<INITIAL>"-"            {return(SUB);}
<INITIAL>"*"            {return(MUL);}
<INITIAL>"/"            {return(DIV);}
        
<INITIAL>"for"			 {return(FOR);}				
<INITIAL>"if"			 {return(IF);}
<INITIAL>"else"          {return(ELSE);}
<INITIAL>"while"         {return(WHILE);}
<INITIAL>"return"        {return(RETURN);}

<INITIAL>{intcon}        {return(INTCON);}
<INITIAL>{charcon}       {return(CHARCON);}

<INITIAL>{id}			 {return(ID);}
<INITIAL>{whitespace}    ;


<INITIAL>{anything}      {return(OTHER);}

%%


int main() {

    int result;
    while ((result=yylex())!=0) {
        printf("%d\t%s\n", result, yytext);
    }
    return 0;
}