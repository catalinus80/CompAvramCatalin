lex comp.l
yacc -d comp.y
gcc lex.yy.c y.tab.c -o comp -lfl
chmod +x comp
./comp < input.txt