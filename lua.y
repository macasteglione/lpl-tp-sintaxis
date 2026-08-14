%{

#include <stdio.h>

int yylex(void);
void yyerror(const char *s);
float eval(char *s);

%}

%union {
	  char *str;
    char **strlist;
    float num;
}

%token <str> NAME

%nterm <str> var
%nterm <num> exp

%token LABELSEP
%token GOTO
%token AND
%token FALSE
%token LOCAL
%token THEN
%token BREAK
%token FOR
%token NIL
%token TRUE
%token DO
%token FUNCTION
%token NOT
%token UNTIL
%token ELSE
%token OR
%token WHILE
%token ELSEIF
%token IF
%token REPEAT
%token END
%token IN
%token RETURN
%token ASIGN
%token <num> NUMERAL

%token ADD;
%token AMPERSAND;
%token COMPARE;
%token OPARENTESIS;
%token CPARENTESIS;
%token SEMICOLON;
%token SUB;
%token TILDE;
%token APROX;
%token COLON;
%token MUL;
%token PIPE;
%token MINOREQUAL;
%token MAJOREQUAL;
%token MINOR;
%token MAJOR;
%token OCURLYBRAKET;
%token CCURLYBRAKET;
%token OBRAKET;
%token CBRAKET;
%token COMMA;
%token DOT;
%token DDOT;
%token TDOT;
%token MODULE;
%token CARET;
%token HASH;
%token RSHIFT;
%token LSHIFT;
%token FLOOR;

%%

programa:
      /* vacío */
      | sentencia programa
      ;

sentencia:
        LABELSEP NAME LABELSEP { printf("Label: %s\n", $2); }
      | GOTO NAME { printf("Goto: %s\n", $2); }
      | var ASIGN exp { printf("%s <- %f\n", $1, $3); }
      ;

var:
      NAME { $$ = $1; }
      ;

exp:
      NAME { $$ = eval($1); }
      | NUMERAL
      ;

varlist:
      var
      | var COMMA varlist
      ;

%%

float eval(char *s) {
    return 1.0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
