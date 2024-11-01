%{
  #include <stdio.h>
  #include <stdlib.h>

  extern int lines;
  extern int lexical_errors;
  int parser_errors = 0;

  void yyerror(char *);
  int yylex();
%}

%token EOL 
%token ADD SUB PROD DIV REST
%token TYPE_KEYWORD RETURN_KEYWORD
%token ID NUMBER STRING 
%token ABRE_PAREN FECHA_PAREN ABRE_CHAVE FECHA_CHAVE VIRGULA ATRIB EQUAL NOT AND OR
%token WHILE FOR IF ELSE ELSE_IF PLUS_PLUS MINUS_MINUS
%token GREATERTHAN GREATERTHANEQUAL LESSTHAN LESSTHANEQUAL

%start program

%%

program       : /* empty */
              | commands
              | decl_functions
              ;

decl_functions : decl_function
               | decl_function decl_functions
               ;

commands      : command EOL
              | commands command EOL
              | commands built_in_functions
              ;

built_in_functions : WHILE ABRE_PAREN expression FECHA_PAREN ABRE_CHAVE commands FECHA_CHAVE
                   | FOR ABRE_PAREN assignment EOL expression EOL assignment FECHA_PAREN ABRE_CHAVE commands FECHA_CHAVE
                   | if_statement
                   ;

if_statement  : IF ABRE_PAREN expression FECHA_PAREN ABRE_CHAVE commands FECHA_CHAVE
              | IF ABRE_PAREN expression FECHA_PAREN ABRE_CHAVE commands FECHA_CHAVE ELSE_IF ABRE_PAREN expression FECHA_PAREN ABRE_CHAVE commands FECHA_CHAVE
              | IF ABRE_PAREN expression FECHA_PAREN ABRE_CHAVE commands FECHA_CHAVE ELSE_IF ABRE_PAREN expression FECHA_PAREN ABRE_CHAVE commands FECHA_CHAVE ELSE ABRE_CHAVE commands FECHA_CHAVE
              ;

command       : assignment
              | function_call
              | decl_variable
              | RETURN_KEYWORD expression
              ;

decl_variable : TYPE_KEYWORD var_list
              ;

var_list      : ID VIRGULA var_list
              | ID
              ;

expression_list : expression VIRGULA expression_list
                | expression
                ;

assignment    : TYPE_KEYWORD ID ATRIB expression
              | ID ATRIB expression
              | ID PLUS_PLUS
              | ID MINUS_MINUS
              ;

expression    : term        
              | term ADD expression
              | term SUB expression
              | term PROD expression
              | term DIV expression
              | term REST expression
              | term EQUAL expression
              | term AND expression
              | term OR expression
              | term GREATERTHAN expression
              | term GREATERTHANEQUAL expression
              | term LESSTHAN expression
              | term LESSTHANEQUAL expression
              ;

decl_function : TYPE_KEYWORD ID ABRE_PAREN FECHA_PAREN ABRE_CHAVE commands FECHA_CHAVE
              | TYPE_KEYWORD ID ABRE_PAREN FECHA_PAREN ABRE_CHAVE FECHA_CHAVE
              | TYPE_KEYWORD ID ABRE_PAREN decl_variable FECHA_PAREN ABRE_CHAVE commands FECHA_CHAVE
              | TYPE_KEYWORD ID ABRE_PAREN decl_variable FECHA_PAREN ABRE_CHAVE FECHA_CHAVE
              ;

function_call : ID ABRE_PAREN FECHA_PAREN
              | ID ABRE_PAREN expression_list FECHA_PAREN
              ;
              
term          : NUMBER
              | STRING
              | ABRE_PAREN expression FECHA_PAREN
              | ID
              | function_call
              | NOT term
              ;

%%

int main() {
  yyparse();

  printf("\n\n------------------- END OF FILE -------------------\n");

  if (parser_errors > 0) {
    printf("\n--> O compilador encontrou %d erros sintáticos", parser_errors);
  }

  if (lexical_errors > 0) {
    printf("\n--> O compilador encontrou %d erros léxicos", lexical_errors);
  }

  if (parser_errors == 0 && lexical_errors == 0) {
    printf("\n--> O compilador não encontrou erros");
  } else {
    printf("\n--> O compilador encontrou erros. O programa inserido NÃO é válido!");
  }

  printf("\n--> O arquivo de entrada possui %d linhas\n\n", lines);

  return 0;
}

void yyerror(char *msg) {
  parser_errors++;
  printf("\n--> Erro: %s próximo à linha %d\n", msg, lines);
}