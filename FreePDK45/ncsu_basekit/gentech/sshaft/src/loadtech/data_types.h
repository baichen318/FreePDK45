#ifndef DATA_TYPES_H_INCLUDED
#define DATA_TYPES_H_INCLUDED

#include <stdio.h>
#include <iostream>
#include <string>
#include <list>

using namespace std;

/* Since we are using C++, we need to specify the prototypes for some 
   internal yacc functions so that they can be found at link time.
*/
extern int yylex(void);
extern int yyerror(char *msg);
extern int mylineno;

class NameSpace {
 public:
  string name;
  list<NameSpace> children;
  NameSpace *parent;
  NameSpace (string newname, NameSpace *newparent) { name=newname; parent=newparent; }
  NameSpace *getChild(string newname);
  NameSpace *getParent() {return parent;}
  NameSpace *findChild(char *findname);
  string &getPrefix(NameSpace *scope=NULL);
  void print();
};

class TechVar {
 public:
  string var;
  string val;
  NameSpace *ns;
  TechVar(string newvar, string newval, NameSpace *newns) {var=newvar; val=newval; ns=newns; }
  //string printName(NameSpace *scopens);
};

extern list<TechVar> tech;
extern list<TechVar> envtech;
extern NameSpace *ns;
extern list<TechVar>::iterator getTechVar(list<TechVar> &tech, string var, NameSpace *scopens);
extern string getTechVarString(string var);
extern void insertTechVar(string var, string val);
extern int DEBUG;
extern void print_debug(const char* message);
#define YYSTYPE string

#endif
