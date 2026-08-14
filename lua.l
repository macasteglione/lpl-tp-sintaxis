%{

#include "lua.tab.h"

%}

%%

:: { return LABELSEP; }
goto { return GOTO; }
and { return AND; }
false { return FALSE; }
local { return LOCAL; }
then { return THEN; }
break { return BREAK; }
for { return FOR; }
nil { return NIL; }
true { return TRUE; }
do { return DO; }
function { return FUNCTION; }
not { return NOT; }
until { return UNTIL; }
else { return ELSE; }
or { return OR; }
while { return WHILE; }
elseif { return ELSEIF; }
if { return IF; }
repeat { return REPEAT; }
end { return END; }
in { return IN; }
return { return RETURN; }

= { return ASIGN; }
+ { return ADD; }
& { return AMPERSAND; }
== { return COMPARE; }
( { return OPARENTESIS; }
) { return CPARENTESIS; }
; { return SEMICOLON; }
- { return SUB; }
~ { return COMMA; }
~= { return APROX; }
: { return COLON; }
* { return MUL; }
| { return PIPE; }
<= { return MINOREQUAL; }
>= { return MAJOREQUAL; }
< { return MINOR; }
> { return MAJOR; }
{ { return OCURLYBRAKET; }
} { return CCURLYBRAKET; }

[0-9]+\.[0-9]+ { yylval.num = atof(yytext); return NUMERAL; }
[A-Za-z_][A-Za-z0-9_]* { yylval.str = strdup(yytext); return NAME; }

[ \t\n]+ { } // Limpia espacios

.			{ 
			printf("Error de sintaxis en línea %d [%s]\n", yylineno, yytext);
			exit(1);
			}

%%

int yywrap(void) { return 1; }
