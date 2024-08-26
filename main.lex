%{
#include <stdio.h>
int token_counter = 0; // Contador de tokens
int errors = 0; // Contador de erros
%}

DIGIT        [0-9]
LETTER       [a-zA-Z]
ID           {LETTER}({LETTER}|{DIGIT}|_)*
INT          {DIGIT}+
REAL         {DIGIT}+"."{DIGIT}+
INVALID_REAL {DIGIT}+","{DIGIT}+
ASSIGN       "="
EQUAL        "=="
DIFF         "!="
OPERATOR     "+"|"-"|"*"|"/"
SEP          ";"|","
PARENTHESIS  "("|")"
BRACKETS     "{"|"}"
COMMENT      \/\/
BLOCK_COMMENT  "/*"([^*]|\*+[^*/])*\*+\/
STRING       \"([^\\\n]|(\\.))*?\"
INEQ         "<"|">"|"<="|">="
OR           "||"
AND          "&&"
NOT          "!"
DOT          "."
%%

{ID}        { printf("ID: %s\n", yytext); token_counter++; }
{REAL}      { printf("REAL: %s\n", yytext); token_counter++; }
{INT}       { printf("INT: %s\n", yytext); token_counter++; }
{INVALID_REAL} { printf("ERRO: Número inválido %s\n", yytext); errors++; }
{ASSIGN}    { printf("ASSIGN: %s\n", yytext); token_counter++; }
{EQUAL}     { printf("EQUAL: %s\n", yytext); token_counter++; }
{DIFF}      { printf("DIFF: %s\n", yytext); token_counter++; }
{OPERATOR}  { printf("OPERATOR: %s\n", yytext); token_counter++; }
{SEP}       { printf("SEP: %s\n", yytext); token_counter++; }
{PARENTHESIS} { printf("PARENTHESIS: %s\n", yytext); token_counter++; }
{BRACKETS}  { printf("BRACKETS: %s\n", yytext); token_counter++; }
{INEQ} { printf("INEQ(%s)\n",yytext); token_counter++; }
{COMMENT}   { printf("COMMENT(%s)\n", yytext); token_counter++; }
{BLOCK_COMMENT} { printf("BLOCK_COMMENT\n"); token_counter++; }
{STRING}    { printf("STRING: %s\n", yytext); token_counter++; }
{OR} { printf("OR: %s\n",yytext); token_counter++; }
{AND} { printf("AND: %s\n",yytext); token_counter++; }
{NOT} { printf("NOT: %s\n",yytext); token_counter++; }
[ \t\r]     // Ignorar espaços
\n          { printf("\n"); }
{DOT}       { printf("DOT: %s\n", yytext); token_counter++; }

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
