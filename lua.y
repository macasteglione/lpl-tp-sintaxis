%{
#include <stdio.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

char* eval_str(char *s, char *valor, int assign);
float eval(char *s, float valor, int assing);
enum tipo_dato { TIPO_NUM, TIPO_STR };

struct Nodo {
    char* clave;
    float valor_num;
    char* valor_str;
    enum tipo_dato tipo;
    struct Nodo *next;
};

struct Nodo* variables = NULL;

%}

%union {
	  char *str;
    float num;
    struct Nodo *nod;
}

%token LABELSEP
%token ASIG
%token GOTO
%token SEP
%token OP_ADD
%token OP_SUB
%token OP_MUL
%token OP_DIV
%token PRINT
%token LP
%token RP
%token <str> NAME
%token <num> NUMERAL
%token NEWLINE
%token <num> BOOLEAN
%token <str> STRING
%nterm <str> var
%nterm <num> exp
%nterm <num> termino
%nterm <num> factor

%%

programa:
       /* vacío */
       | programa sentencia
       ;

sentencia:
      LABELSEP NAME LABELSEP NEWLINE { printf("Label: %s\n", $2); }
      | GOTO NAME NEWLINE { printf("Goto: %s\n", $2); }
      | var ASIG exp NEWLINE { eval($1, $3, 1); printf("%s <-- %f\n", $1, $3 ); }
      | var ASIG STRING NEWLINE {  }
      | PRINT STRING NEWLINE { printf("%s\n", $2); }
      | PRINT exp NEWLINE { printf("%f\n", $2); }
      ;

var:
      NAME
      ;

factor:
      NAME { $$ = eval($1, 0, 0); }
      | NUMERAL
      | BOOLEAN
      | LP exp RP { $$ = $2; }
      ;

termino:
      factor
      | termino OP_MUL factor { $$ = $1 * $3; }
      | termino OP_DIV factor { $$ = $1 / $3; }
      ;

exp:
      termino
      | exp OP_ADD termino {$$ = $1 + $3; }
      | exp OP_SUB termino { $$ = $1 - $3; }
      ;

%%

float eval(char *s, float valor, int assing) {
    struct Nodo* v = variables;
    while(v != NULL) {
        if(strcmp(v->clave, s) == 0) {
            if (assing == 1) {
                v->valor_num = valor;
                v->tipo = TIPO_NUM;
            }
            return v->valor_num;
        }
        v = v->next;
    }

    struct Nodo *new = malloc(sizeof(struct Nodo));
    new->clave = strdup(s);
    new->valor_num = valor;
    new->valor_str = NULL;
    new->tipo = TIPO_NUM;
    new->next = variables;
    variables = new;
    return 0;
}

char* eval_str(char *s, char *valor, int assign) {
    struct Nodo* v = variables;
    while (v != NULL) {
        if (strcmp(v->clave, s) == 0) {
            if (assign == 1) {
                v->valor_str = strdup(valor);
                v->tipo = TIPO_STR;
            }
            return v->valor_str;
        }
        v = v->next;
    }
    struct Nodo *new = malloc(sizeof(struct Nodo));
    new->clave = strdup(s);
    new->valor_str = strdup(valor);
    new->valor_num = 0;
    new->tipo = TIPO_STR;
    new->next = variables;
    variables = new;
    return valor;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
