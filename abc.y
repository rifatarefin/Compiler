%{
#include <stdlib.h>
#include <stdio.h>
#include<bits/stdc++.h>
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
SymbolInfo *idList[100];
SymbolInfo *spec=new SymbolInfo((char *)"null", (char *)"ID");
int ccnt=0;
int yyparse(void);
int yylex(void);

void yyerror(char *s)
{
	fprintf(stderr,"%s\n",s);
	return;
}

%}

%union { double dval; int ivar ; char *sval;SymbolInfo *sym;}
%token<ivar> CONST_CHAR
%token <sval> CHAR IF ELSE FOR WHILE INT FLOAT DOUBLE RETURN VOID MAIN PRINTLN ASSIGNOP NOT SEMICOLON COMMA LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD INCOP DECOP 
%token <sym> ADDOP MULOP RELOP LOGICOP CONST_INT CONST_FLOAT ID 
%type <dval> factor expression unary_expression term simple_expression rel_expression logic_expression 
%type<sval> type_specifier
%type<sym>variable

%%

Program : INT MAIN LPAREN RPAREN compound_statement                                                     {cout<<"Program : INT MAIN LPAREN RPAREN compound_statement\n\n";}
	;


compound_statement : LCURL var_declaration statements RCURL                                         {cout<<"compound_statement : LCURL var_declaration statements RCURL\n\n";}
		   | LCURL statements RCURL                                                                                                               {cout<<"compound_statement : LCURL statements RCURL\n\n";} 
		   | LCURL RCURL                                                                                                                                       {cout<<"compound_statement :LCURL RCURL\n\n";}
		   ;

			 
var_declaration	: type_specifier declaration_list SEMICOLON                                             {cout<<"var_declaration	: type_specifier declaration_list SEMICOLON\n\n";
                                                                                                                                                                           
                                                                                                                                                                            for(int i=0;i<ccnt;i++)
                                                                                                                                                                            {
                                                                                                                                                                            idList[i]->datatype=$1;
                                                                                                                                                                            int hs=hash2(idList[i]->name);
                                                                                                                                                                            table.insert(hs%n,idList[i]);
                                                                                                                                                                            }
                                                                                                                                                                            ccnt=0;
                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                            }
		|  var_declaration type_specifier declaration_list SEMICOLON                                      {cout<<"var_declaration: var_declaration type_specifier declaration_list SEMICOLON\n\n";
                                                                                                                                                                            
                                                                                                                                                                            for(int i=0;i<ccnt;i++)
                                                                                                                                                                            {
                                                                                                                                                                            idList[i]->datatype=$2;
                                                                                                                                                                            int hs=hash2(idList[i]->name);
                                                                                                                                                                            table.insert(hs%n,idList[i]);
                                                                                                                                                                            }
                                                                                                                                                                            ccnt=0;
                                                                                                                                                                            }
		;

type_specifier	: INT                                                                                                                                     {printf("type_specifier : INT\n\n");
                                                                                                                                                                                $$=$1;
                                                                                                                                                                                }
		| FLOAT                                                                                                                                                       {printf("type_specifier : FLOAT\n\n");
                                                                                                                                                                                $$=$1;
                                                                                                                                                                                }
		| CHAR                                                                                                                                                        {printf("type_specifier : CHAR\n\n");
                                                                                                                                                                                $$=$1;
                                                                                                                                                                                }
		;
			
declaration_list : declaration_list COMMA ID                                                                                    {cout<<"declaration_list : declaration_list COMMA ID\n";
                                                                                                                                                                                idList[ccnt++]=$3;
                                                                                                                                                                               cout<<$3->name<<"\n\n";
                                                                                                                                                                                }
		 | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD                                                  {cout<<"declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n";
                                                                                                                                                                                $3->arrLen=atoi($5->name.c_str());
                                                                                                                                                                                $3->val_array=new double[$3->arrLen];
                                                                                                                                                                                idList[ccnt++]=$3;
                                                                                                                                                                                cout<<$3->name<<"\n\n";
                                                                                                                                                                                }
		 
		 | ID                                                                                                                                                              {cout<<"declaration_list : ID\n";
                                                                                                                                                                                idList[ccnt++]=$1;
                                                                                                                                                                                cout<<$1->name<<"\n\n";
                                                                                                                                                                                }
		 | ID LTHIRD CONST_INT RTHIRD                                                                                                     {printf("declaration_list : ID LTHIRD CONST_INT RTHIRD\n");
                                                                                                                                                                                $1->arrLen=atoi($3->name.c_str());
                                                                                                                                                                                $1->val_array=new double[$1->arrLen];
                                                                                                                                                                                idList[ccnt++]=$1;
                                                                                                                                                                                cout<<$1->name<<"\n\n";
                                                                                                                                                                                }
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
						
variable : ID 		                                                                                                                                           {cout<<"variable : ID\n";
                                                                                                                                                                            SymbolInfo *f;
                                                                                                                                                                            int hs=hash2($1->name);
                                                                                                                                                                            f=table.lookUp(hs%n,$1);
                                                                                                                                                                            if(f==0)cout<<"Error! "<<$1->name<<" not declared in the scope\n\n";
                                                                                                                                                                            $$=f;
                                                                                                                                                                            cout<<$$->name<<"\n\n";
                                                                                                                                                                            }
	 | ID LTHIRD expression RTHIRD                                                                                                     {cout<<"variable : ID LTHIRD expression RTHIRD\n";
                                                                                                                                                                            SymbolInfo *f;
                                                                                                                                                                            int hs=hash2($1->name);
                                                                                                                                                                            f=table.lookUp(hs%n,$1);
                                                                                                                                                                            if(f==0)cout<<"Error! "<<$1->name<<" not declared in the scope\n\n";
                                                                                                                                                                            f->index=$3;
                                                                                                                                                                            $$=f;
                                                                                                                                                                            cout<<$$->name<<"\n\n";
                                                                                                                                                                                                 
                                                                                                                                                                        };
	 ;
			
expression : logic_expression	                                                                                                              {cout<<"expression : logic_expression\n\n";
                                                                                                                                                                                $$=$1;
                                                                                                                                                                                }
	   | variable ASSIGNOP logic_expression 	                                                                                      {cout<<"expression : variable ASSIGNOP logic_expression\n\n";
                                                                                                                                                                                $$=1;                                                                                                                       
                                                                                                                                                                                SymbolInfo *f;
                                                                                                                                                                                int hs=hash2($1->name);
                                                                                                                                                                                f=table.lookUp(hs%n,$1);
                                                                                                                                                                                if(f!=0)
                                                                                                                                                                                {
                                                                                                                                                                                    
                                                                                                                                                                                    if(f->index==-1){ f->value=$3;}
                                                                                                                                                                                    else { f->val_array[f->index]=$3;}
                                                                                                                                                                                    table.print(n);
                                                                                                                                                                                }
                                                                                                                                                                                else cout<<"Error! "<<$1->name<<" not found\n\n";
                                                                                                                                                                                }
	   ;
			
logic_expression : rel_expression 	                                                                                                     {cout<<"logic_expression : rel_expression\n\n";
                                                                                                                                                                                $$=$1;
                                                                                                                                                                                //cout<<$$<<"\n\n";
                                                                                                                                                                                }
		 | rel_expression LOGICOP rel_expression 	                                                                               {cout<<"logic_expression : rel_expression LOGICOP rel_expression\n\n";
                                                                                                                                                                                if($2->name=="&&")$$=$1&&$3;
                                                                                                                                                                                else if($2->name=="||")$$=$1||$3;
                                                                                                                                                                                //cout<<$$<<"\n\n";
                                                                                                                                                                                }
		 ;
			
rel_expression	: simple_expression                                                                                                  {cout<<"rel_expression	: simple_expression\n\n";
                                                                                                                                                                            $$=$1;
                                                                                                                                                                            }
		| simple_expression RELOP simple_expression                                                                   {cout<<"rel_expression : simple_expression RELOP simple_expression\n\n";
                                                                                                                                                                            if($2->name==">")$$=$1>$3;
                                                                                                                                                                            else if($2->name=="<")$$=$1<$3;
                                                                                                                                                                            else if($2->name==">=")$$=$1>=$3;
                                                                                                                                                                            else if($2->name=="<=")$$=$1<=$3;
                                                                                                                                                                            else if($2->name=="==")$$=$1==$3;
                                                                                                                                                                            else if($2->name=="!=")$$=$1!=$3;
                                                                                                                                                                            }	
		;
				
simple_expression : term                                                                                                                        {cout<<"simple_expression : term \n\n";
                                                                                                                                                                            $$=$1;
                                                                                                                                                                            }
		  | simple_expression ADDOP term                                                                                              {cout<<"simple_expression : simple_expression ADDOP term \n\n";
                                                                                                                                                                            if($2->name=="+")$$=$1+$3;
                                                                                                                                                                            else $$=$1-$3;
                                                                                                                                                                            }
		  ;
					
term :	unary_expression                                                                                                                     {cout<<"term :	unary_expression\n\n";
                                                                                                                                                                            $$=$1;
                                                                                                                                                                            }
     |  term MULOP unary_expression                                                                                                   {cout<<"term : term MULOP unary_expression\n\n";
                                                                                                                                                                            if($2->name=="*")$$=$1*$3;
                                                                                                                                                                            else if($2->name=="/")$$=$1/$3;
                                                                                                                                                                            else if($2->name=="%")
                                                                                                                                                                            {
                                                                                                                                                                            if($1==(int)$1 && $3==(int)$3)$$=(int)$1%(int)$3;
                                                                                                                                                                            else cout<<"Error! invalid operand\n\n";
                                                                                                                                                                            }
                                                                                                                                                                            }
     ;

unary_expression : ADDOP unary_expression                                                                           {cout<<"unary_expression : ADDOP unary_expression\n\n";
                                                                                                                                                                        if($1->name=="-")$$=-$2;
                                                                                                                                                                        else $$=$2;
                                                                                                                                                                        }
		 | NOT unary_expression                                                                                                               {cout<<"unary_expression : NOT unary_expression\n\n";
                                                                                                                                                                        $$=!$2;
                                                                                                                                                                        }
		 | factor                                                                                                                                                    {cout<<"unary_expression : factor\n\n";
                                                                                                                                                                            $$=$1;
                                                                                                                                                                            }
		 ;
	
factor	: variable                                                                                                                                       {cout<<"factor	: variable\n\n";
                                                                                                                                                                            if($1->index==-1)$$=$1->value;
                                                                                                                                                                            else $$=$1->val_array[$1->index];
                                                                                                                                                                            }
	| LPAREN expression RPAREN                                                                                                         {cout<<"factor : LPAREN expression RPAREN\n\n";
                                                                                                                                                                            $$=$2;
                                                                                                                                                                            }
	| CONST_INT                                                                                                                                        {cout<<"factor : CONST_INT\n";
                                                                                                                                                                        cout<<$1->name<<"\n\n";
                                                                                                                                                                        $$=atoi($1->name.c_str());
                                                                                                                                                                    }
	| CONST_FLOAT                                                                                                                                  {cout<<"factor : CONST_FLOAT\n\n";
                                                                                                                                                                        $$=atof($1->name.c_str());
                                                                                                                                                                        cout<<$1->name<<"\n\n";
                                                                                                                                                                        }
	| CONST_CHAR                                                                                                                                   {cout<<"factor : CONST_CHAR\n\n";
                                                                                                                                                                        $$=$1;
                                                                                                                                                                        }
	| factor INCOP                                                                                                                                     {cout<<"factor : factor INCOP\n\n";
                                                                                                                                                                        $$=$1+1;
                                                                                                                                                                        }
	| factor DECOP                                                                                                                                     {cout<<"factor : factor DECOP\n\n";
                                                                                                                                                                        $$=$1-1;
                                                                                                                                                                            }
	;



%%

int main(void){
	/*yydebug=1;*/
    freopen("input.txt","r",stdin);
	yyparse();
	return 0;
}
