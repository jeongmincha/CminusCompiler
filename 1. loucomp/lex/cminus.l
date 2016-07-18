/****************************************************/
/* File: tiny.l                                     */
/* Lex specification for TINY                       */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%%

"else"          {return ELSE;}
"if"            {return IF;}
"int"           {return INT;}
"return"        {return RETURN;}
"void"          {return VOID;}
"while"         {return WHILE;}

"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}

"<"             {return SM;}
"<="            {return SE;}
">"             {return LG;}
">="            {return LE;}
"=="            {return EQ;}
"!="            {return NEQ;}

"="             {return ASSIGN;}
"("             {return LPAREN;}
")"             {return RPAREN;}
"["             {return SLPAREN;}
"]"             {return SRPAREN;}
"{"             {return CLPAREN;}
"}"             {return CRPAREN;}

";"             {return SEMI;}
","             {return COMMA;}

{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}

"/*"            { char c; // current character
                  char n; // next character
                  do
                  { c = input();
                    if (c == '\n')
                      lineno ++;
                    if (c == '*')
                    { n = input();
                      if (n == '/')
                        return COMMENT;
                      else
                        unput(n);
                    }
                  } while (1);
                }
%%

TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = source;
    yyout = listing;
  }
  currentToken = yylex();
  strncpy(tokenString, yytext, MAXTOKENLEN);

  if (TraceScan)
  { 
    if (currentToken != COMMENT) {
      fprintf(listing, "\t%d: ", lineno);
      printToken(currentToken, tokenString);
    }
  }
  return currentToken;
}

