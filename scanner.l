%{
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include "symboltable.h"
#include "y.tab.h"


using namespace std;

extern YYSTYPE yylval;
extern SymbolTable *table;
void yyerror(char *);

int line_count=1;
int error=0;


%}



digit [0-9]
letter [A-Za-z]
delim [ \t\r\f\v]
newline \n
ws [delim]+
id (_|{letter})(_|{letter}|{digit})*
integer {digit}+
number {digit}*(\.{digit}+)?(E[+-]?{digit}+)?
ADDOP [+-] 
MULOP [*/%]

%%

{delim}+	{}
{newline} {line_count++;}

"if" {
            yylval.sval=yytext;
            return IF;}
"else" {
            yylval.sval=yytext;
            return ELSE;}
"for" {yylval.sval=yytext;
            return FOR;}
"while" {yylval.sval=yytext;
                return WHILE;}
"int" {
            yylval.sval=yytext;
            return INT;}
"float" {yylval.sval=yytext;
                return FLOAT;}
"double" {
                yylval.sval=yytext;
                return DOUBLE;}
"char" {yylval.sval=yytext;
                return CHAR;}
"return" {yylval.sval=yytext;
                    return RETURN;}
"void" {yylval.sval=yytext;
                return VOID;}
"main"	{yylval.sval=yytext;
                return MAIN;}
"println"	{yylval.sval=yytext;
                    return PRINTLN;}

{ADDOP} { 
			SymbolInfo *s= new  SymbolInfo(yytext, (char *)"ADDOP");
			yylval.sym = s;
			return ADDOP;
		}



{MULOP}	{
			SymbolInfo *s= new  SymbolInfo(yytext, (char *)"MULOP",line_count);
			yylval.sym= s;
			return MULOP;
		}


"=" 	{return ASSIGNOP;}

">" |
"<" |
">=" |
"<=" |
"==" |
"!=" {
		SymbolInfo *s= new  SymbolInfo(yytext, (char *)"RELOP");
		yylval.sym = s;
		return RELOP;
	}

"&&"	|
"||"	{
			SymbolInfo *s= new  SymbolInfo(yytext, (char *)"LOGICOP");
			yylval.sym = s;
			return LOGICOP;
		}
"!"		{	yylval.sval=yytext;
                return NOT; }


";" 	{yylval.sval=yytext;
        return SEMICOLON;}
"," 	{yylval.sval=yytext;
        return COMMA;}
"(" 	{yylval.sval=yytext;
        return LPAREN;}
")" 	{yylval.sval=yytext;
        return RPAREN;}
"{" 	{yylval.sval=yytext;
        return LCURL;}
"}" 	{yylval.sval=yytext;
        return RCURL;}
"[" 	{yylval.sval=yytext;
        return LTHIRD;}
"]" 	{yylval.sval=yytext;
        return RTHIRD;}
"++" 	{yylval.sval=yytext;
            return INCOP;}
"--" 	{yylval.sval=yytext;
            return DECOP;}



{integer}	{
				SymbolInfo *s= new  SymbolInfo(yytext, (char *)"CONST_INT");
				yylval.sym = s;
				return CONST_INT;
			}
{number} 	{	
				SymbolInfo *s= new  SymbolInfo(yytext, (char *)"CONST_FLOAT");
				yylval.sym = s;
				return CONST_FLOAT; 
			}

{id} 		{	 
				
                SymbolInfo  *s= new SymbolInfo(yytext, (char *)"ID",line_count);
				
				yylval.sym = s;
							
				return ID;
			}


%%

int yywrap(void)
{
	return 1;
}





