%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "url_parser.tab.h"
%}

%%

https    { yylval.strval = strdup(yytext); return PROTOCOL; }
http     { yylval.strval = strdup(yytext); return PROTOCOL; }
ftp      { yylval.strval = strdup(yytext); return PROTOCOL; }
file     { yylval.strval = strdup(yytext); return PROTOCOL; }

"://"    { return SLASHES; }
"/"      { return SLASH; }
"."      { return DOT; }
"-"      { return DASH; }

[a-zA-Z0-9]+ { 
    yylval.strval = strdup(yytext); 
    return DOMAIN_PART; 
}

\n       { return END; }
[ \t]    ; /* ignore whitespace */

.        { 
    printf("Lexer error: Invalid character '%c'\n", yytext[0]); 
    return ERROR; 
}

%%

int yywrap() {
    return 1;
}