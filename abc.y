%{
#include <stdlib.h>
#include <stdio.h>
#include "symboltable.h"
ofstream fout;
unsigned long hash2(string str)
{
    unsigned long hash = 5381,c;
    int i=0;

    while ((c = str[i++]))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return hash;
}
int n=15;
SymbolTable table(n);
int count=0;
int yyparse(void);
int yylex(void);

void yyerror(char *s)
{
	fprintf(stderr,"%s\n",s);
	return;
}

%}

%union { double dval; int ivar ; char *sval;SymbolInfo *sym;}
%token <sval> CHAR IF ELSE FOR WHILE INT FLOAT DOUBLE RETURN VOID MAIN PRINTLN ASSIGNOP NOT SEMICOLON COMMA LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD INCOP DECOP CONST_CHAR 
%token <sym> ADDOP MULOP RELOP LOGICOP CONST_INT CONST_FLOAT ID


%%

Program : INT MAIN LPAREN RPAREN compound_statement                                                     {cout<<"Program : INT MAIN LPAREN RPAREN compound_statement\n\n";}
	;


compound_statement : LCURL var_declaration statements RCURL                                         {cout<<"compound_statement : LCURL var_declaration statements RCURL\n\n";}
		   | LCURL statements RCURL                                                                                                               {cout<<"compound_statement : LCURL statements RCURL\n\n";} 
		   | LCURL RCURL                                                                                                                                       {cout<<"compound_statement :LCURL RCURL\n\n";}
		   ;

			 
var_declaration	: type_specifier declaration_list SEMICOLON                                             {cout<<"var_declaration	: type_specifier declaration_list SEMICOLON\n\n";
                                                                                                                                                                            
                                                                                                                                                                            }
		|  var_declaration type_specifier declaration_list SEMICOLON                                      {cout<<"var_declaration: var_declaration type_specifier declaration_list SEMICOLON\n\n";}
		;

type_specifier	: INT                                                                                                                                     {printf("type_specifier : INT\n\n");}
		| FLOAT                                                                                                                                                       {printf("type_specifier : FLOAT\n\n");}
		| CHAR                                                                                                                                                        {printf("type_specifier : CHAR\n\n");}
		;
			
declaration_list : declaration_list COMMA ID                                                                                    {cout<<"declaration_list : declaration_list COMMA ID\n";
                                                                                                                                                                                int hs=hash2($3->name)%n;
                                                                                                                                                                                table.insert(hs,$3);
                                                                                                                                                                                }
		 | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD                                                  {cout<<"declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n";}
		 | ID                                                                                                                                                              {cout<<"declaration_list : ID\n";
                                                                                                                                                                                int hs=hash2($1->name)%n;
                                                                                                                                                                                table.insert(hs,$1);
                                                                                                                                                                                }
		 | ID LTHIRD CONST_INT RTHIRD                                                                                                     {printf("declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n");}
		 ;

statements : stmt                                                                                                                                           {cout<<"statements : stmt\n\n";}
	   | statements stmt                                                                                                                                   {cout<<"statements : statements stmt\n\n";}
	   ;

stmt : matched                                                                                                                                               {cout<<"stmt : matched\n\n";}
        |unmatched                                                                                                                                            {cout<<"stmt : unmatched\n\n";}
        ;
matched : statement                                                                                                                                     {cout<<"matched : statement\n\n";}
        | IF LPAREN expression RPAREN matched ELSE matched                                                    {cout<<"matched : IF LPAREN expression RPAREN matched ELSE matched\n\n";}
        
        ;
unmatched : IF LPAREN expression RPAREN stmt                                                                        {cout<<"unmatched : IF LPAREN expression RPAREN stmt\n\n";}
        | IF LPAREN expression RPAREN matched ELSE unmatched                                            {cout<<"unmatched : IF LPAREN expression RPAREN matched ELSE unmatched\n\n";}
;
        

       
statement  : expression_statement                                                                                                   {cout<<"statement  : expression_statement\n\n";}
	   | compound_statement                                                                                                                    {cout<<"statement : compound_statement\n\n";}
	   | FOR LPAREN expression_statement expression_statement expression RPAREN statement          
                                                                                                                                {cout<<"statement :  FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n";}
	  
	   | WHILE LPAREN expression RPAREN statement                                                                  {cout<<"statement : WHILE LPAREN expression RPAREN statement\n\n";}
	   | PRINTLN LPAREN ID RPAREN SEMICOLON                                                                            {cout<<"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n";}
	   | RETURN expression SEMICOLON                                                                                               {cout<<"statement : RETURN expression SEMICOLON\n\n";}
	   ;
		


expression_statement	: SEMICOLON			                                                                                     {cout<<"expression_statement	: SEMICOLON\n\n";}
			| expression SEMICOLON                                                                                                           {cout<<"expression_statement : expression SEMICOLON\n\n";}
			;
						
variable : ID 		                                                                                                                                           {cout<<"variable : ID\n\n";}
	 | ID LTHIRD expression RTHIRD                                                                                                     {cout<<"variable : ID LTHIRD expression RTHIRD\n\n";};
	 ;
			
expression : logic_expression	                                                                                                              {cout<<"expression : logic_expression\n\n";}
	   | variable ASSIGNOP logic_expression 	                                                                                      {cout<<"expression : variable ASSIGNOP logic_expression\n\n";}
	   ;
			
logic_expression : rel_expression 	                                                                                                     {cout<<"logic_expression : rel_expression\n\n";}
		 | rel_expression LOGICOP rel_expression 	                                                                               {cout<<"logic_expression : rel_expression LOGICOP rel_expression\n\n";}
		 ;
			
rel_expression	: simple_expression                                                                                                  {cout<<"rel_expression	: simple_expression\n\n";}
		| simple_expression RELOP simple_expression                                                                   {cout<<"rel_expression : simple_expression RELOP simple_expression\n\n";}	
		;
				
simple_expression : term                                                                                                                        {cout<<"simple_expression : term \n\n";}
		  | simple_expression ADDOP term                                                                                              {cout<<"simple_expression : simple_expression ADDOP term \n\n";}
		  ;
					
term :	unary_expression                                                                                                                     {cout<<"term :	unary_expression\n\n";}
     |  term MULOP unary_expression                                                                                                   {cout<<"term : term MULOP unary_expression\n\n";}
     ;

unary_expression : ADDOP unary_expression                                                                           {cout<<"unary_expression : ADDOP unary_expression\n\n";}
		 | NOT unary_expression                                                                                                               {cout<<"unary_expression : NOT unary_expression\n\n";}
		 | factor                                                                                                                                                    {cout<<"unary_expression : factor\n\n";}
		 ;
	
factor	: variable                                                                                                                                       {cout<<"factor	: variable\n\n";}
	| LPAREN expression RPAREN                                                                                                         {cout<<"factor : expression RPAREN\n\n";}
	| CONST_INT                                                                                                                                        {cout<<"factor : CONST_INT\n";
                                                                                                                                                                        cout<<$1->name<<"\n\n";
                                                                                                                                                                    }
	| CONST_FLOAT                                                                                                                                  {cout<<"factor : CONST_FLOAT\n\n";}
	| CONST_CHAR                                                                                                                                   {cout<<"factor : CONST_CHAR\n\n";}
	| factor INCOP                                                                                                                                     {cout<<"factor : factor INCOP\n\n";
                                                                                                                                                                        }
	| factor DECOP                                                                                                                                     {{cout<<"factor : factor DECOP\n\n";}}
	;



%%

int main(void){
	/*yydebug=1;*/
	
	yyparse();
	return 0;
}
