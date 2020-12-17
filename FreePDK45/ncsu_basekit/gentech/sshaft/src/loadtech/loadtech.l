/* techlexer.l -- Lexical analyzer for SSHAFT Technology file
 *
 * Rhett Davis 9/3/2004
 */

%option noyywrap

%{

#include "data_types.h"
#include "loadtech.tab.h"

extern int DEBUG;

void print_debug(const char* message)
{
    if (DEBUG && mylineno == DEBUG)  {
        printf(message);
    }
}

%}

Comment		([ \f\t\r]*"#".*"\n")

%s value inref

%%

<INITIAL>{Comment}     {print_debug("Comment\n");mylineno++;}
<INITIAL>namespace     {print_debug("NS "); return NS;}
[ \f\t\r]+             {print_debug("SPACE "); yylval=yytext; return SPACE;}
[a-zA-Z0-9_]+          {print_debug("WORD "); yylval=yytext; return WORD;}
":"                    {print_debug("COLON "); yylval=yytext; return COLON; }
<INITIAL>"="           {print_debug("EQ "); BEGIN(value); return EQ;}
<INITIAL>"{"           {print_debug("BEGINNS "); return BEGINNS;}
<INITIAL>"}"           {print_debug("ENDNS "); return ENDNS;}
<value>"$"             {print_debug("REF "); return REF;}
<value>"{"             {print_debug("OPEN "); BEGIN(inref); return OPEN;}
<inref>"}"             {print_debug("CLOSE "); BEGIN(value);return CLOSE;}
<value>"\\"[ \f\t\r]*"\n"|"\n"[ \f\t\r]*"+"   {print_debug("CONT "); mylineno++; return CONT;}
"\n"                   {print_debug("EOL\n"); mylineno++; BEGIN(0);return EOL;}
<value>[^  \f\t\r\n${a-zA-Z0-9_:]+ {print_debug("OTHER "); yylval=yytext; return OTHER;}
<inref>[^  \f\t\r\n}a-zA-Z0-9_]+ {print_debug("REFOTHER "); yylval=yytext; return REFOTHER;}
%%





