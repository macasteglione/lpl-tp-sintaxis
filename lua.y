%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *s);
%}

%union {
	char *str;
}

%token LABELSEP
%token GOTO
%token <str> NAME

%%

programa:
       /* vacío */
       | sentencia programa
       ;

sentencia:
      LABELSEP NAME LABELSEP		{ printf("Label: %s\n", $2); }
    | GOTO NAME				{ printf("Goto: %s\n", $2); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
