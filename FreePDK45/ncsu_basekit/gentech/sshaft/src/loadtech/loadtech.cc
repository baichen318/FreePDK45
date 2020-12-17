/************************************************************
* Author: Rhett Davis                                       *
* Filename: parsetech.cc                                    *
************************************************************/

#include <stdio.h>
#include <string>
#include <iostream>
#include <vector>
#include "data_types.h"
//#include <GetOpt.h>


/* FLEX/BISON variables/functions */
extern int yylval;

extern FILE *yyin;
extern int yyparse();
int yyerror (char *s);

#ifdef YYDEBUG
extern int yydebug;
#endif


/* My variables */
extern int mylineno;

/* Global variables */
list <TechVar> tech;
list <TechVar> envtech;
NameSpace rootns("root",NULL);
NameSpace *ns=&rootns;
NameSpace *scopens=&rootns;
string currenttechfile;

int DEBUG = 0;

main( int argc, char *argv[], char *env[] )
{

  //GetOpt getopt(argc, argv, "d:t:");
  char *techfile=NULL;
  char *outputns=NULL;
  int printall=0;
/*
  while ((optchar=getopt()) != EOF) {
    switch ((char)optchar) {
    case 'd': 
      DEBUG = atoi(getopt.optarg); 
      cout << "Debugging line " << DEBUG << "\n";
      break;
    case 't':
      techfile = new char[strlen(getopt.optarg)];
      strcpy(techfile,getopt.optarg);
      break;
    case '?': 
      cout << "Usage: " << argv[0] << " [ -d line_no ] [ -t techfile ]\n";
      exit(-1);
    }
  }
*/
  int argi=1;
  while (argi!=argc) {
    if (!strcmp(argv[argi],"-d")) {
      argi++;
      DEBUG = atoi(argv[argi]); 
    }
    else if (!strcmp(argv[argi],"-t")) {
      argi++;
      techfile = new char[strlen(argv[argi])+1];
      strcpy(techfile,argv[argi]);
    }
    else if (!strcmp(argv[argi],"-n")) {
      argi++;
      outputns = new char[strlen(argv[argi])+1];
      strcpy(outputns,argv[argi]);
    }
    else if (!strcmp(argv[argi],"-a")) {
      printall=1;
    }
    else if (!strcmp(argv[argi],"-?")) {
      cout << "Usage: " << argv[0] << " [ -d line_no ] [ -t techfile ] [ -n namespace ] [ -a ]\n";
      exit(-1);
    }
    else {
      cout << "Uregognized option: " << argv[argi] << endl;
    }
    argi++;
  }

  // Parse the environment variables
  int ep;
  char *cp;
  for (ep=0; env[ep] != NULL; ep++) {
    cp=env[ep];
    for (cp=env[ep];*cp!='=';cp++);
    *cp=0; cp++;
    envtech.push_back(TechVar(env[ep],cp,&rootns));
    //cout << env[ep] << "\n";
  }

  // Get the techfile name(s)
  list<TechVar>::iterator i;
  if (!techfile) {
    i = getTechVar(envtech,"SSHAFT_TECHFILE",&rootns);
    if (i == NULL) {
      cerr << "ERROR: SSHAFT_TECHFILE Environment Variable not declared\n";
      exit(1);
    }
    techfile = new char[strlen(i->val.data())+1];
    strcpy(techfile,i->val.data());
  }

  // Build the list of techfiles
  list<string> techfilelist;
  char *singletechfile=strtok(techfile,":");
  while (singletechfile) {
    techfilelist.push_back(string(singletechfile));
    singletechfile=strtok(NULL,":");
  }

  // Parse each techfile
  list<string>::iterator k;
  for (k = techfilelist.begin(); k != techfilelist.end(); k++) {
    yyin = fopen(k->data(),"r");
    if (!yyin) {
      cerr << "ERROR: Could not open " << k->data() << " for reading\n";
      exit(-1);
    }
    currenttechfile=k->data();
    mylineno=1;
    if (DEBUG)
      cout << "Debugging line " << DEBUG << " in file " << currenttechfile << endl;
    yyparse();
    fclose(yyin);
  }

  // Find the scope Namespace
  if (outputns) {
    scopens = rootns.findChild(outputns);
    if (!scopens) {
      cerr << "ERROR: Could not find namespace " << outputns << ", using root namespace\n";
      scopens=&rootns;
    }
  }

  if (DEBUG)
    exit(0);

  i = NULL;
  string str;
  for(i = tech.begin(); i != tech.end(); i++) {
    str=i->ns->getPrefix(scopens);
    if (str[0]!=':' || !str.length() || printall) {
      cout << str << i->var << endl;
      //cout << i->var << endl;
      cout << i->val << endl;
    }
  }

}


int yyerror (char *s)  /* Called by yyparse on error */

{
  printf ("\n%s on Line no. %d of file %s\n", s, mylineno, currenttechfile.data());
};

list<TechVar>::iterator getTechVar(list<TechVar> &tech, string var, NameSpace *scopens) {
  string str;
  list<TechVar>::iterator i = NULL;
  for(i = tech.begin(); i != tech.end(); i++) {
    str=i->ns->getPrefix(scopens);
    str=str + i->var;
    if (str == var) {
      return i;
    }
  }  
  return NULL;
}

string getTechVarString(string var) {
  list<TechVar>::iterator i = getTechVar(envtech, var, &rootns);
  if (i==NULL) {
    i = getTechVar(tech, var, ns);
    if (i==NULL) {
      cerr << "ERROR: Attempt to reference variable " << var << ", which has not been defined, on line " << mylineno << "\n";
      return "";
    }
  }
  return i->val;
}

void insertTechVar(string var, string val) {
  list<TechVar>::iterator i = getTechVar(tech, var, ns);
  if (i==NULL) {
    tech.push_back(TechVar(var,val,ns));
  }
  else {
    i->val=val;
  }
  return;
}


string &NameSpace::getPrefix(NameSpace *scope) {
  // If scope is a parent of this namespace, include all 
  // namespaces up to (but not including) the scope.
  // Otherwise, print all namespaces up to (but not 
  // including) the root, and include the prefix "::".
  static string str;
  NameSpace *cns=this;
  str="";
  if (cns==&rootns && cns!= scope) {
    str="::"+str;
  }
  while (cns != &rootns && cns != scope) {
    str=cns->name+"::"+str;
    cns=cns->parent;
    if (cns->name == "root")  {
      if (scope!=NULL) {
        if (scope->name != "root") {
          str="::"+str;
        }
      }
      else {
        str="::"+str;
      }
    }
  }
  return str;
}

NameSpace *NameSpace::getChild(string newname) {
  list<NameSpace>::iterator i = NULL;
  for(i = children.begin(); i != children.end(); i++) {
    if (i->name == newname) {
      return &(*i);
    }
  }
  NameSpace *childns = new NameSpace(newname,this);
  children.push_back(*childns);

  // The following code is messy, but I don't know a cleaner way to
  // get back a pointer to the list member that I just created.
  delete childns;
  for(i = children.begin(); i != children.end(); i++) {
    if (i->name == newname) {
      childns = &(*i);
    }
  }

  return childns;
}

NameSpace *NameSpace::findChild(char *findname) {
  NameSpace *retval=NULL;
  NameSpace *cns=this;
  char *tempname = new char[strlen(findname)+1];
  strcpy(tempname,findname);
  list<string> namelist;
  char *nstok=strtok(tempname,":");
  while (nstok) {
    namelist.push_back(string(nstok));
    nstok=strtok(NULL,":");
  }
  delete tempname;
  list<string>::iterator n = NULL;
  list<NameSpace>::iterator i = NULL;
  int found;
  for(n = namelist.begin(); n != namelist.end(); n++) {
    found=0;
    for(i = cns->children.begin(); i != cns->children.end(); i++) {
      if (i->name == *n) {
        cns=&(*i);
        found=1;
        break;
      }
    } 
    if (!found) {
      cerr << "ERROR: Namespace " << cns->name << " has no child " << *n << endl;
      return NULL;
    }
  }
  return cns;
}

void NameSpace::print() {
  string &str=this->getPrefix(&rootns);
  cout << str << endl;
  list<NameSpace>::iterator i = NULL;
  for(i = children.begin(); i != children.end(); i++) {
    i->print();
  }
}




