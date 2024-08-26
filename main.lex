%{
#include <stdio.h>
int token_counter = 0;
int errors = 0;
%}

DIGIT        [0-9]
LETTER       [a-zA-Z]
ID           {LETTER}({LETTER}|{DIGIT}|_)*
NUM          {DIGIT}+
ASSIGN       "="
EQUAL        "=="
DIFF         "!="
OPERATOR     "+"|"-"|"*"|"/"
SEP          ","|";"
PARENTHESIS  "("|")"
BRACKETS     "{"|"}"

%%

{ID}        { printf("ID: %s\n", yytext); token_counter++; }
{NUM}       { printf("NUM: %s\n", yytext); token_counter++; }
{ASSIGN}    { printf("ASSIGN: %s\n", yytext); token_counter++; }
{EQUAL}     { printf("EQUAL: %s\n", yytext); token_counter++; }
{DIFF}      { printf("DIFF: %s\n", yytext); token_counter++; }
{OPERATOR}  { printf("OPERATOR: %s\n", yytext); token_counter++; }
{SEP}       { printf("SEP: %s\n", yytext); token_counter++; }
{PARENTHESIS} { printf("PARENTHESIS: %s\n", yytext); token_counter++; }
{BRACKETS}  { printf("BRACKETS: %s\n", yytext); token_counter++; }
"//".*      { /* Ignora comentários de linha */ }
"/*"[^*]*"*"+([^/*][^*]*"*"+)*"/" { /* Ignora comentários de bloco */ }
[ \t\n]     { /* Ignora espaços em branco */ }
.           { printf("Caractere desconhecido: %s\n", yytext); errors++; }

%%

int main(int argc, char **argv) {
    yylex();
    printf("Total de tokens: %d\n", token_counter);
    printf("Total de erros: %d\n", errors);
    return 0;
}

int yywrap() {
    return 1;
}
