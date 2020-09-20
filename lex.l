%{

%}

/*
	──Terminals──
*/
letter			[A-Za-z]
digit			[0-9]
whitespace		[ \t]
eol				\n
alfanum			[A-Za-z0-9_]
commentStart	"/*"
commentEnd		"*/"
bin_op			["+""-""*""/"]
rel_op			["==""!=""<=""<"">="">"]
logical_op		["&&""||"]
ch				[ -]
anything		.

/*
	──Non-terminals──
*/
id				{letter}{alfanum}*
charcon			["\n""\0"] | {ch}
intcon			{digit}+
stringcon		{ch}+
prog			{stmt}+

stmt			(if"("{expr}")"{stmt}(else{stmt})?)
				|
				(while"("{expr}")"{stmt})
				|
				(for"("{assg}?";"{expr}?";"{assg}?")"{stmt})
				|
				(return{expr}?";")
				|
				({assg}";")
				|
				({id}"("({expr}(","{expr})*)?")"";")
				|
				("{"{stmt}*"}")
				|
				";"

assg			{id}("["{expr}"]")?"="{expr}

expr			("-"{expr})
				|
				("!"{expr})
				|
				({expr}{bin_op}{expr})
				|
				({expr}{rel_op}{expr})
				|
				({expr}{logical_op}{expr})
				|
				({id}("("({expr}(","{expr})*)?")"|("["{expr}"]"))?)
				|
				("("{expr}")")
				|
				{intcon}|{charcon}|{stringcon}

/*
	──States──
*/
%s COMMENT

/*
	──Flex Options──
*/
%option noyywrap

%%
<INITIAL>{

	{commentStart}	{ BEGIN(COMMENT); }
	{id}			{ printf("id: %s\n", yytext); }
	{eol}
	{anything}

}

<COMMENT>{

	{commentEnd}	{ BEGIN(INITIAL); }
	{eol}
	{anything}

}

%%
int main(int argc, char **argv) {

		// skip over program name
		++argv;
		--argc;

		// get input
		if (argc > 0) {
			yyin = fopen(argv[0], "r");
		} else {
			yyin = stdin;
		}
		
		// run main
		yylex(); 

		return 0;
}
