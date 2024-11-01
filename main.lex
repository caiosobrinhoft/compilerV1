%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "main.tab.h"

  int lines = 0;
  int lexical_errors = 0;

  void print_error(char *, const char *, int);
%}

DIGIT                   [0-9]
VAR                     [A-Za-z_][A-Za-z_0-9]*
ATTRIBUTION_SYMBOL      "="
SPACE                   [\t\r" "]
NEWLINE                 \n
SEPARATOR               ";"
COMMENT                 "//"[^\n]*
COMMENT_BLOCK           "/""*"[^*]*"*""/"

INTEGER                 "-"?{DIGIT}+
FLOAT                   "-"?{DIGIT}+("."{DIGIT}+)?
STRING                  \"[^\n]*\"

INTEGER_KEYWORD         "int"
FLOAT_KEYWORD           "float"
STRING_KEYWORD          "string"
VOID_KEYWORD            "void"
TYPES_KEYWORDS          {INTEGER_KEYWORD}|{FLOAT_KEYWORD}|{STRING_KEYWORD}|{VOID_KEYWORD}
RETURN_KEYWORD          "return"

%%

{SPACE}                  {}
{COMMENT}                {}
{COMMENT_BLOCK}          {}
{NEWLINE}                { lines++; }

{RETURN_KEYWORD}         { return (RETURN_KEYWORD); }
"while"                  { return (WHILE); }
"for"                    { return (FOR); }
"if"                     { return (IF); }
"else"                   { return (ELSE); }
"else if"                { return (ELSE_IF); }
"++"                     { return (PLUS_PLUS); }
"--"                     { return (MINUS_MINUS); }

{INTEGER}                { return (NUMBER); }
{FLOAT}                  { return (NUMBER); }
{STRING}                 { return (STRING); }

"+"                      { return (ADD); }
"-"                      { return (SUB); }
"*"                      { return (PROD); }
"/"                      { return (DIV); }
"%"                      { return (REST); }

","                      { return (VIRGULA); }
"("                      { return (ABRE_PAREN); }
")"                      { return (FECHA_PAREN); }
"{"                      { return (ABRE_CHAVE); }
"}"                      { return (FECHA_CHAVE); }
{ATTRIBUTION_SYMBOL}     { return (ATRIB); }
"=="                     { return (EQUAL); }

{TYPES_KEYWORDS}         { return (TYPE_KEYWORD); }
{VAR}                    { return (ID); }

"!"                      { return (NOT); }
"||"                     { return (OR); }
"&&"                     { return (AND); }
">"                      { return (GREATERTHAN); }
">="                     { return (GREATERTHANEQUAL); }
"<"                      { return (LESSTHAN); }
"<="                     { return (LESSTHANEQUAL); }

{SEPARATOR}  { return (EOL); }

.                        { lexical_errors++; print_error(yytext, "Unknown token", lines + 1); }

%%

int yywrap() {
  return 1;
}

void print_error(char *declaration, const char *error_label, int error_at_line) {
  printf("\n\n!-> LEXICAL ERROR at line %d\n", error_at_line);
  printf("  - %s: %s\n", error_label, declaration);
}