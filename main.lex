%{
#include <stdio.h>
int token_counter = 0; // Contador de tokens
int errors = 0; // Contador de erros
%}

// Definições de padrões para tokens
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
COMMENT      \/\/
INEQ         "<"|">"|"<="|">="
OR           "||"
AND          "&&"
NOT          "!"

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
{COMMENT}   { printf("COMMENT(%s)\n", yytext); token_counter++; }
[ \t\r]     // Ignorar espaços
\n          { printf("\n"); }
.           { printf("Caractere desconhecido: %s\n", yytext); errors++; }

%%

int main(int argc, char **argv) {
    // Verifica se um arquivo foi passado como argumento
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Erro ao abrir o arquivo");
            return 1;
        }
        yyin = file; // Redireciona a entrada padrão para o arquivo
    }
    yylex(); // Inicia a análise léxica
    printf("Total de tokens: %d\n", token_counter);
    printf("Total de erros: %d\n", errors);
    return 0;
}

// Função chamada quando a análise léxica é concluída
int yywrap() {
    return 1;
}
