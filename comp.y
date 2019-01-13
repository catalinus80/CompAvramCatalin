%{
#include <stdio.h>
#include <string.h>
	int yylex();
	int yyerror(const char *msg);
	int lista = 0;
	char msg[50];
	class TVAR
		 {
		 char* nume;
		 int valoare;
		 TVAR* next;

		 public:
			 static TVAR* head;
			 static TVAR* tail;
			 TVAR(char* n, int v = -1);
			 TVAR();
			 int exists(char* n);
			 void add(char* n, int v = -1);
			 int getValue(char* n);
			 void setValue(char* n, int v);
		 };
	 TVAR* TVAR::head;
	 TVAR* TVAR::tail;
	 TVAR::TVAR(char* n, int v)
		 {
		 this->nume = new char[strlen(n)+1];
		 strcpy(this->nume,n);
		 this->valoare = v;
		 this->next = NULL;
		 }
	TVAR::TVAR()
	 {
		 TVAR::head = NULL;
		 TVAR::tail = NULL;
	 }
	int TVAR::exists(char* n)
	 {
		 TVAR* tmp = TVAR::head;
		 while(tmp != NULL)
		 {
		 if(strcmp(tmp->nume,n) == 0)
		 return 1;
		 tmp = tmp->next;
		 }
		 return 0;
	 }
	void TVAR::add(char* n, int v)
	 {
		 TVAR* elem = new TVAR(n, v);
		 if(head == NULL)
		 {
		 TVAR::head = TVAR::tail = elem;
		 }
		 else
		 {
		 TVAR::tail->next = elem;
		 TVAR::tail = elem;
		}
	}
	int TVAR::getValue(char* n)
	 {
		 TVAR* tmp = TVAR::head;
		 while(tmp != NULL)
		 {
		 if(strcmp(tmp->nume,n) == 0)
		 	return tmp->valoare;
		 tmp = tmp->next;
		 }
		 return -1;
	 }
	void TVAR::setValue(char* n, int v)
	 {
		 TVAR* tmp = TVAR::head;
		 while(tmp != NULL)
		 {
		 if(strcmp(tmp->nume,n) == 0)
		 {
		 tmp->valoare = v;
		 }
		 tmp = tmp->next;
		 }
	}
	TVAR* ts = NULL;
%}
%union { char* sir; int val; }
%token TOK_PROGRAM TOK_TO TOK_DO TOK_FOR TOK_INTEGER TOK_BEGIN TOK_END TOK_READ
%token TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT TOK_DECLARE TOK_PRINT TOK_ERROR TOK_EQUAL
%token <val> TOK_NUMBER
%token <sir> TOK_VARIABLE
%type <val> exp term factor
%start prog
%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE
%locations
%%
prog : TOK_PROGRAM progname TOK_DECLARE declist TOK_BEGIN stmtlist TOK_END									    
;
progname : TOK_VARIABLE
;
declist : dec ';' 
 |
 declist dec ';' 
;
dec : idlist ':' type 
;
type : TOK_INTEGER 
;
idlist : TOK_VARIABLE { 
			if(lista==0){
				 if(ts != NULL)
				 {
				 if(ts->exists($1) == 0)
				 {
				 ts->add($1);
				 }
				 else
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $1);
				 yyerror(msg);
				 YYERROR;
				 }
				 }
				 else
				 {
				 ts = new TVAR();
				 ts->add($1);
				 }
			      }
			else
			 if(lista==2){
				if(ts != NULL)
			 	{
				 if(ts->exists($1) == 1)
				 {
				 int newval = 100;      /*NEW VALUE*/
				 ts->setValue($1,newval);
				 }
				else
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,@1.first_column, $1);
				 yyerror(msg);
				 YYERROR;
				 }
				 }
				 else
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,@1.first_column, $1);
				 yyerror(msg);
				 YYERROR;
				 }	
			}
					else{
					 if(ts != NULL)
					 {
						 if(ts->exists($1) == 1)
						 {
						 if(ts->getValue($1) == -1)
						 {
						 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $1);
						 yyerror(msg);
						 YYERROR;
						 }
						 else
						 {
						 printf("%d\n",ts->getValue($1));
						 }
						 }
						else
						 {
						 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,@1.first_column, $1);
						 yyerror(msg);
						 YYERROR;
						 }
					 }
					 else
					 {
					 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,@1.first_column, $1);
					 yyerror(msg);
					 YYERROR;
					 }
					 }
			}
	 |
	 idlist ',' TOK_VARIABLE {
				 if(lista==0){
				 if(ts != NULL)
				 {
				 if(ts->exists($3) == 0)
				 {
				 ts->add($3);
				 }
				 else
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $3);
				 yyerror(msg);
				 YYERROR;
				 }
				 }
				 else
				 {
				 ts = new TVAR();
				 ts->add($3);
				 }
			      }
			      else
			 if(lista==2){
				if(ts != NULL)
			 	{
				 if(ts->exists($3) == 1)
				 {
				 int newval = 100;      /*NEW VALUE*/
				 ts->setValue($3,newval);
				 }
				else
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,@1.first_column, $3);
				 yyerror(msg);
				 YYERROR;
				 }
				 }
				 else
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,@1.first_column, $3);
				 yyerror(msg);
				 YYERROR;
				 }	
			}
					else{
					 if(ts != NULL)
					 {
						 if(ts->exists($3) == 1)
						 {
						 if(ts->getValue($3) == -1)
						 {
						 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $3);
						 yyerror(msg);
						 YYERROR;
						 }
						 else
						 {
						 printf("%d\n",ts->getValue($3));
						 }
						 }
						else
						 {
						 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,@1.first_column, $3);
						 yyerror(msg);
						 YYERROR;
						 }
					 }
					 else
					 {
					 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line,@1.first_column, $3);
					 yyerror(msg);
					 YYERROR;
					 }
					 }
				}

; 
stmtlist : stmt ';'
 |
 stmtlist stmt ';'
; 
stmt : assign | read | write | for
;
assign : TOK_VARIABLE TOK_EQUAL exp {
				 if(ts != NULL)
				 {
				 if(ts->exists($1) == 1)
				 {
				 ts->setValue($1, $3);
				 }
				 else
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
				 yyerror(msg);
				 YYERROR;
				 }
				 }
				else
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
				 yyerror(msg);
				 YYERROR;
				 }
				}
;
exp : term
 |
 exp TOK_PLUS term { $$ = $1 + $3; }
 |
 exp TOK_MINUS term { $$ = $1 - $3; }
;
term : factor
 | term TOK_MULTIPLY factor { $$ = $1 * $3; }
 | term TOK_DIVIDE factor {
			 if($3 == 0)
			 {
			 sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
			 yyerror(msg);
			 YYERROR;
			 }
			 else { $$ = $1 / $3; }
			 }
;
factor : TOK_VARIABLE {
			 if(ts != NULL)
			 {
				 if(ts->exists($1) == 1)
				 {
				 if(ts->getValue($1) == -1)
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $1);
				 yyerror(msg);
				 YYERROR;
				 }
				 else
				 {
				 $$ = ts->getValue($1);
				 }
				 }
				else
				 {
				 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
				 yyerror(msg);
				 YYERROR;
				 }
			 }
			 else
			 {
			 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
			 yyerror(msg);
			 YYERROR;
			 }
			 }
 |
 TOK_NUMBER { $$ = $1; }
 |
 TOK_LEFT exp TOK_RIGHT { $$ = $2; }
;
triggerW: {lista=1; }
;
triggerR: {lista=2; }
;
read : triggerR TOK_READ TOK_LEFT idlist TOK_RIGHT
;
write : triggerW TOK_PRINT TOK_LEFT idlist TOK_RIGHT
;
for : TOK_FOR indexexp TOK_DO body
;
indexexp : TOK_VARIABLE TOK_EQUAL exp TOK_TO exp {
			 if(ts != NULL)
			 {
			 if(ts->exists($1) == 1)
			 {
			 ts->setValue($1, $3);
			 }
			 else
			 {
			 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
			 yyerror(msg);
			 YYERROR;
			 }
			 }
			else
			 {
			 sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
			 yyerror(msg);
			 YYERROR;
			 }
			} 
;
body: stmt ';'
 |
 TOK_BEGIN stmtlist TOK_END
;
%%

int main()
{
 yyparse();
 return 0;
}
int yyerror(const char *msg)
{
 printf("Error: %s\n", msg);
 return 1;
}