%option noyywrap
%x SSTATE
%{
#include<bits/stdc++.h>
#include<stdlib.h>
#include"1305112_offline1_symbol_table.cpp";

int line_count=1,line2;
int hs, size=30,error=0;
SymbolTable obj(30);
string tex, st;


FILE *logout;
FILE *tokenout;

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z_]
DIGIT [0-9]
NEWLINE \n


%%




\"  {
                
                //fout<<" dfsdf\n";
                tex=yytext;
                line2=line_count;
                BEGIN SSTATE;
                
}
<SSTATE>[^\"\n]*\\\r {

                st=yytext;
                st.pop_back();
                st.pop_back();
                tex+=st;
                line_count++;
               
              
     
}
<SSTATE>[^\n\r\"]*\" {
                
                tex+=yytext;
                 fprintf(tokenout,"<STRING,%s>",tex);
                fout<<"Line no "<<line2<<": TOKEN <STRING> Lexeme "<<tex<<" found\n";
                BEGIN INITIAL;
}

<SSTATE>[^\n\r\"]*[^\\\"]\r { 
               // fout<<yytext;
                tex+=yytext;
                fout<<"Error at line "<<line2<<": Unterminated string "<< tex<<"\n\n";
                error++;
               // line_count++;
                BEGIN INITIAL;
}
{NEWLINE} {line_count++;}

"if"	{
			fprintf(tokenout,"<IF>");
			fout<<"Line no "<<line_count<<": TOKEN <IF> Lexeme "<<yytext<<" found\n\n";
		}
		
"else"	{
			fprintf(tokenout,"<ELSE>");
			fout<<"Line no "<<line_count<<": TOKEN <ELSE> Lexeme "<<yytext<<" found\n\n";
		}
		
"for"	{
			fprintf(tokenout,"<FOR>");
			fout<<"Line no "<<line_count<<": TOKEN <FOR> Lexeme "<<yytext<<" found\n\n";
		}
		
"while"	{
			fprintf(tokenout,"<WHILE>");
			fout<<"Line no "<<line_count<<": TOKEN <WHILE> Lexeme "<<yytext<<" found\n\n";
		}
		
"do"	{
			fprintf(tokenout,"<DO>");
			fout<<"Line no "<<line_count<<": TOKEN <DO> Lexeme "<<yytext<<" found\n\n";
		}
		
"break"	{
			fprintf(tokenout,"<BREAK>");
			fout<<"Line no "<<line_count<<": TOKEN <BREAK> Lexeme "<<yytext<<" found\n\n";
		}
		
"int"	{
			fprintf(tokenout,"<INT>");
			fout<<"Line no "<<line_count<<": TOKEN <INT> Lexeme "<<yytext<<" found\n\n";
		}
		
"char"	{
			fprintf(tokenout,"<CHAR>");
			fout<<"Line no "<<line_count<<": TOKEN <CHAR> Lexeme "<<yytext<<" found\n\n";
		}
		
"float"	{
			fprintf(tokenout,"<FLOAT>");
			fout<<"Line no "<<line_count<<": TOKEN <FLOAT> Lexeme "<<yytext<<" found\n\n";
		}
		
"double"	{
			fprintf(tokenout,"<DOUBLE>");
			fout<<"Line no "<<line_count<<": TOKEN <DOUBLE> Lexeme "<<yytext<<" found\n\n";
		}
		
"void"	{
			fprintf(tokenout,"<VOID>");
			fout<<"Line no "<<line_count<<": TOKEN <VOID> Lexeme "<<yytext<<" found\n\n";
		}
		
"return"	{
			fprintf(tokenout,"<RETURN>");
			fout<<"Line no "<<line_count<<": TOKEN <RETURN> Lexeme "<<yytext<<" found\n\n";
		}
		
"switch"	{
			fprintf(tokenout,"<SWITCH>");
			fout<<"Line no "<<line_count<<": TOKEN <SWITCH> Lexeme "<<yytext<<" found\n\n";
		}
		
"case"	{
			fprintf(tokenout,"<CASE>");
			fout<<"Line no "<<line_count<<": TOKEN <CASE> Lexeme "<<yytext<<" found\n\n";
		}

"default"	{
			fprintf(tokenout,"<DEFAULT>");
			fout<<"Line no "<<line_count<<": TOKEN <DEFAULT> Lexeme "<<yytext<<" found\n\n";
		}

"continue"	{
			fprintf(tokenout,"<CONTINUE>");
            fout<<"Line no "<<line_count<<": TOKEN <CONTINUE> Lexeme "<<yytext<<" found\n\n";
		}


"+"		|

"-"		{
			fprintf(tokenout,"<ADDOP,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <ADDOP> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"ADDOP");
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}
		
"*" | 
"/"  |
"%" {
			fprintf(tokenout,"<MULOP,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <MULOP> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"MULOP");
            
        }

"++" | 
"--"   {
			fprintf(tokenout,"<INCOP,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <INCOP> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"INCOP");
            
        }
        
"<" | 
"<="  |
">" |
"==" |
"!=" {
			fprintf(tokenout,"<RELOP,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <RELOP> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"RELOP");
            
        }
        

"=" {
			fprintf(tokenout,"<ASSIGNOP,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <ASSIGNOP> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"ASSIGNOP");
            
        }
        
"&&" | 
"||"  |
"!" {
			fprintf(tokenout,"<LOGICOP,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <LOGICOP> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"LOGICOP");
            
        }
"(" | 
")" {
			fprintf(tokenout,"<PAREN,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <PAREN> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"PAREN");
            
        }        

"{" | 
"}" {
			fprintf(tokenout,"<CURL,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <CURL> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"CURL");
            
        }
"[" | 
"]" {
			fprintf(tokenout,"<BRACKET,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <BRACKET> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"BRACKET");
            
        }
        
"," {
			fprintf(tokenout,"<COMMA,%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <COMMA> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"COMMA");
            
        }
";" {
			fprintf(tokenout,"<SEMICOLON%s>",yytext);
            fout<<"Line no "<<line_count<<": TOKEN <SEMICOLON> Lexeme "<<yytext<<" found\n";
            hs=hash2(yytext)%size;
            obj.insert(hs,yytext,"SEMICOLON");
            
        }
		
{DIGIT}+ 	{
				fprintf(tokenout,"<CONST_INT,%s>",yytext);
				//fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n",line_count,yytext);
                fout<<"Line no "<<line_count<<": TOKEN <CONST_INT> Lexeme "<<yytext<<" found\n";
				//insert in symbol table and print symbol table content(only non empty buckets)
                hs=hash2(yytext)%size;
                obj.insert(hs,yytext,"CONST_INT");
			}
			
{DIGIT}*[.]{DIGIT}+ |
{DIGIT}*[.]?{DIGIT}*[E][+-]?{DIGIT}+ { 

                fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
                fout<<"Line no "<<line_count<<": TOKEN <CONST_FLOAT> Lexeme "<<yytext<<" found\n";
                 hs=hash2(yytext)%size;
                obj.insert(hs,yytext,"CONST_FLOAT");

}
({DIGIT})*[.]({DIGIT})*[.]({DIGIT}|\.)* {
                fout<<"Error at line "<<line_count<<": Too many decimal point "<< yytext<<"\n\n";
                error++;
}

({DIGIT})+[E][+-]?{DIGIT}*[.][^ \n\r]* {
                fout<<"Error at line "<<line_count<<": Ill formed number "<< yytext<<"\n\n";
                error++;
}

['](([\\](0|a|n|t|\\|f|r|b|v|\"))|[^\'\n\r])['] {

                fprintf(tokenout,"<CONST_CHAR,%s>",yytext);
                fout<<"Line no "<<line_count<<": TOKEN <CONST_CHAR> Lexeme "<<yytext<<" found\n";
                 hs=hash2(yytext)%size;
                obj.insert(hs,yytext,"CONST_CHAR");

}
[']\\[^n0at\\frbv\"]+['] |
['][^\'\n\r][^\'\n\r]+['] {
                 fout<<"Error at line "<<line_count<<": Ill formed character "<< yytext<<"\n\n";
                error++;
}
['][^\n\r\']*\r\n {
                fout<<"Error at line "<<line_count<<": Unterminated character "<< yytext<<"\n";
                error++;
}
{LETTER}({LETTER}|{DIGIT})* {

                fprintf(tokenout,"<ID,%s>",yytext);
                fout<<"Line no "<<line_count<<": TOKEN <ID> Lexeme "<<yytext<<" found\n";
                 hs=hash2(yytext)%size;
                obj.insert(hs,yytext,"ID");

}
{DIGIT}+{LETTER}+[^ \n\r ]* {
                fout<<"Error at line "<<line_count<<": Invalid ID "<< yytext<<"\n\n";
                error++;
}



\/\/([^\n\r])* {

                tex=yytext;
                tex.erase( tex.end()-1);
                fout<<"Line no "<<line_count<<": TOKEN <COMMENT> Lexeme "<<tex<<" found\n\n";
                
}
\/\*(.|\n)*\*\/ {
                fout<<"Line no "<<line_count<<": TOKEN <COMMENT> Lexeme "<<yytext<<" found\n\n";
                for (int i=0;i<strlen(yytext);i++)
                {
                    if(yytext[i]=='\n')line_count++;
                }
}


. {}



			

%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	//logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");
	fout.open("log.txt");
	

	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(tokenout);
	//fclose(logout);
	fout.close();
	return 0;
}
