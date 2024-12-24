%{
#include <stdio.h>

// 定义 YYSTYPE 的类型
#define YYSTYPE int

// 声明外部的词法分析器
int yylex();
void yyerror(const char *s);
%}

%token NUMBER
%token ADD SUB MUL DIV ABS
%token EOL

%%

calclist:
    | calclist exp EOL { printf(" = %d\n", $2); }
    ;

exp:
    factor { $$ = $1; }
    | exp ADD factor { $$ = $1 + $3; }
    | exp SUB factor { $$ = $1 - $3; }
    ;

factor:
    term { $$ = $1; }
    | factor MUL term { $$ = $1 * $3; }
    | factor DIV term { 
        if ($3 == 0) {
            yyerror("division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    ;

term:
    NUMBER { $$ = $1; }
    | ABS term { $$ = $2 >= 0 ? $2 : -$2; }
    ;

%%

int main(int argc, char **argv) {
    return yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "error: %s\n", s);
}
