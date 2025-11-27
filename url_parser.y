%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);
int validate_domain(char* domain);
%}

%union {
    char* strval;
}

%token <strval> PROTOCOL DOMAIN_PART
%token SLASHES SLASH DOT DASH END

%start url

%%

url: protocol slashes domain path END {
    printf("✓ VALID URL: All components parsed successfully\n");
    printf("🎉 URL validation completed successfully!\n");
    exit(0);
    }
    ;

protocol: PROTOCOL { printf("Protocol: %s\n", $1); free($1); }
        ;

slashes: SLASHES { printf("Slashes: ://\n"); }
        ;

domain: domain_part 
      | domain DOT domain_part 
      ;

domain_part: DOMAIN_PART { 
    if (validate_domain($1)) {
        printf("Domain part: %s\n", $1);
        free($1);
    } else {
        yyerror("Invalid domain character");
        YYERROR;
    }
    }
    ;

path: 
    | SLASH 
    | SLASH DOMAIN_PART { printf("Path segment: %s\n", $2); free($2); }
    | path SLASH DOMAIN_PART { printf("Path segment: %s\n", $3); free($3); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "❌ ERROR: %s\n", s);
}

int validate_domain(char* domain) {
    for(int i = 0; domain[i]; i++) {
        if(!isalnum(domain[i]) && domain[i] != '-' && domain[i] != '_') {
            return 0;
        }
    }
    return 1;
}

int main() {
    printf("URL Syntax Validator\n");
    printf("====================\n");
    printf("Enter URL to validate:\n");
    
    yyparse();
    return 0;
}