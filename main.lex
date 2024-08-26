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

{ID}        { printf("ID: %s\n", yytext); }
{NUM}       { printf("NUM: %s\n", yytext); }
{ASSIGN}    { printf("ASSIGN: %s\n", yytext); }
{EQUAL}     { printf("EQUAL: %s\n", yytext); }
{DIFF}      { printf("DIFF: %s\n", yytext); }
{OPERATOR}  { printf("OPERATOR: %s\n", yytext); }
{SEP}       { printf("SEP: %s\n", yytext); }
"//".*      { /* Ignora comentários de linha */ }
"/*"[^*]*"*"+([^/*][^*]*"*"+)*"/" { /* Ignora comentários de bloco */ }
[ \t\n]     { /* Ignora espaços em branco */ }
.           { printf("Caractere desconhecido: %s\n", yytext); }

%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
