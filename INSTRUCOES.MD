1 - RODAR NO TERMINAL:

flex main.lex

bison -d main.y

gcc -o main lex.yy.c main.tab.c -lfl

./main < input.txt