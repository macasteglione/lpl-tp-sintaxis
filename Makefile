parser: lua.tab.c lex.yy.c
	gcc -o parser lua.tab.c lex.yy.c -lfl

lua.tab.c: lua.y
	bison -d -o lua.tab.c lua.y

lex.yy.c: lua.l lua.tab.c
	flex -o lex.yy.c lua.l

clean:
	rm -f lua.tab.c lua.tab.h lex.yy.c parser
