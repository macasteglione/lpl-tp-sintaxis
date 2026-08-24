%{

#include "lua.tab.h"

%}

%%

:: { return LABELSEP; }
= { return ASIG; }
goto { return GOTO; }
, { return SEP; }
[+] { return OP_ADD; }
[-] { return OP_SUB; }
[*] { return OP_MUL; }
[/] { return OP_DIV; }
[(] { return LP; }
[)] { return  RP; }
print { return PRINT; }

true { yylval.num = 1 ; return BOOLEAN; }
false { yylval.num = 0; return BOOLEAN; }
\"[^\"]*\" { yytext[yyleng - 1] = '\0'; yylval.str = strdup(yytext + 1); return STRING; }

[0-9]*\.?[0-9]* { yylval.num = atof(yytext); return NUMERAL; }
[A-Za-z_][A-Za-z0-9_]* { yylval.str = strdup(yytext); return NAME; }

"\n" { return NEWLINE; }
[ \t]+ { } // Limpia espacios

. { printf("Error de sintaxis en línea %d [%s]\n", yylineno, yytext); exit(1); }

%%

int yywrap(void) { return 1; }
