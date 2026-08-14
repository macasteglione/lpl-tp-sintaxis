# TP2: Análisis Sintáctico — Reconocedor de Lua con Yacc/Bison

**Paradigmas y Lenguajes de Programación — UNPSJB**

---

## 1. Instalación

```bash
sudo apt install bison flex gcc make
```

`Makefile` sugerido:

```makefile
parser: lua.tab.c lex.yy.c
	gcc -o parser lua.tab.c lex.yy.c -lfl

lua.tab.c: lua.y
	bison -d -o lua.tab.c lua.y

lex.yy.c: lua.l lua.tab.c
	flex -o lex.yy.c lua.l

clean:
	rm -f lua.tab.c lua.tab.h lex.yy.c parser
```

## 2. Analizador léxico (tokens de Lua)

Reutilizando lo trabajado en el TP1, construir con Flex el lexer que entrega tokens a Bison: identificadores, palabras clave (`and`, `if`, `then`, `else`, `end`, `function`, `local`, `for`, `while`, `do`, `repeat`, `until`, `return`, `break`, `nil`, `true`, `false`, etc.), números, strings (comillas simples/dobles y `[[...]]`), operadores/delimitadores, y comentarios (`--` y `--[[...]]`).

Activar `%option yylineno` en el `.l` para poder reportar número de línea en los errores.

> Recordar: Para que yylineno tome el valor de la línea, es necesario definir un patrón que matchee `\n`.

## 3. Gramática, incremental

Trabajar sobre la [gramática oficial de Lua](https://www.lua.org/manual/5.4/manual.html#9), incorporándola por etapas:

La lista a continuación es una sugerencia de orden en base a las dependencias de los no-terminales, pero pueden decidir la aproxímación que sea necesaria.

El objetivo principal es realizar el reconocimiento del lenguaje y los bloques, funciones y estructuras de control no deben ser implementadas para ser ejecutadas. Solo es necesario realizar la implementación de las declaraciones de variables y expresiones.

Solo reconocer:
1. **Bloques y ámbito**: `chunk`, bloques anidados, `local function`.
1. **Estructuras de control**: `if/elseif/else/end`, `while/do/end`, `repeat/until`, `for` numérico y genérico.
1. **Funciones**: definición (`function`, funciones anónimas), parámetros, `return`, `...` (varargs).

Reconocer y ejecutar:
1. **Sentencias simples**: asignación, `local`, llamada a función como sentencia.
1. **Tablas**: constructores `{ }`, indexación (`.` y `[]`), campos posicionales y con clave.
1. **Expresiones**: literales, aritméticas, relacionales, lógicas, concatenación, precedencia y asociatividad.

## 4. Reporte de errores (línea y columna)

- Mantener línea (`yylineno`) y columna (contador propio, actualizado en cada regla del `.l`) durante el escaneo.
- Implementar `yyerror()` para que el mensaje incluya línea y columna del token que provocó el error.
- Definir una política de recuperación de errores (por ejemplo, usando el token especial `error` de Bison) para poder seguir reportando errores posteriores en el mismo archivo, en vez de detenerse en el primero.

## 5. Entrega final

Programa que recibe un archivo `.lua` y, para cada error sintáctico encontrado, imprime línea, columna y una descripción del error. Si no hay errores, informar que el archivo es sintácticamente válido.

Las variables, asignaciones y expresiones (sin llamados a funciones) deben ser ejecutados y respetar precedencias y asociatividades indicadas por el lenguaje.

