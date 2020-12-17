/* techparser.y -- Parser for SSHAFT Technology Files
 *
 * Rhett Davis 9/3/2004
 */

%token SPACE WORD EQ REF OPEN CLOSE CONT EOL OTHER NS BEGINNS ENDNS COLON REFOTHER

%{
#include <stdlib.h>
#include "data_types.h"

int mylineno=1;


%}

// define the type of semantic here

%start definitions

%%

definitions: /* empty */
        | definitions definition
        | definitions namespace
        | definitions optspace EOL
	;

namespace:
        nsopen definitions nsclose
        ;
        

nsopen:
        optspace NS optspace WORD optspace BEGINNS optspace { ns=ns->getChild($4); }
        ;

nsclose:
        optspace ENDNS optspace EOL { ns=ns->parent; }
        ;

definition:
        optspace WORD optspace EQ optspace value optspace EOL { insertTechVar($2,$6); }
        ;

optspace: /* empty */
        | SPACE                    { $$ = $1;}
        ;

value:  /* empty */
        | string                   { $$ = $1;}
        | value SPACE string       { $$ = $1 + $2 + $3;}
        | value optspace CONT optspace string { $$ = $1 + " " + $5;}
        ;


string: WORD                   { $$ = $1;}
        | OTHER                { $$ = $1;}
        | OPEN                 { $$ = "{";}
        | CLOSE                { $$ = "}";}
        | reference            { $$ = $1;}
        | nonref               { $$ = $1;}
        | COLON                { $$ = $1;}
        | REFOTHER             { $$ = $1;}
        | string WORD          { $$ = $1 + $2;}
        | string OTHER         { $$ = $1 + $2;}
        | string OPEN          { $$ = $1 + "{";}
        | string CLOSE         { $$ = $1 + "}";}
        | string reference     { $$ = $1 + $2;}
        | string nonref        { $$ = $1 + $2;}
        | string COLON         { $$ = $1 + $2;}
        | string REFOTHER      { $$ = $1 + $2;}
        ;

variable: WORD                       { $$ = $1;}
        | COLON COLON WORD           { $$ = $1 + $2 + $3;}
        | variable COLON COLON WORD  { $$ = $1 + $2 + $3 + $4;}
        ;

reference: REF variable            { $$ = getTechVarString($2); }
        | REF OPEN optspace variable optspace CLOSE { $$ = getTechVarString($4);}
        ;

nonref: REF                           { $$ = "$"; cout << "ERROR: $ found with no reference.  Use $$ to indicate $\n";}
        | REF REF                     { $$ = "$";}

%%





