%{
#include "lua.tab.h"

%}

%%

::			{ return LABELSEP; }
goto			{ return GOTO; }

[A-Za-z0-9_]+		{ yylval.str = strdup(yytext); return NAME; }

[ \t\n]+   		{ } // Limpia espacios

.			{ 
			printf("Error de sintaxis en línea %d [%s]\n", yylineno, yytext);
			exit(1);
			}

%%

int yywrap(void) { return 1; }
