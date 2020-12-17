# comment out this line if you want parser debug info
#DEBUG=-DYYDEBUG
#DEBUG =
# comment out this line if you are using Eos else
#LINKOPTS=-L/usr/gnu/lib
# comment out this line if you are using cygwin
LINKOPTS = -L /ncsu/gnu/lib -ly -lfl -lstdc++

# TOOL is either gcc or g++
GNU_COMPILER = g++
GNU_COMPILER_FLAGS = -c -g  #-O # for optimization
ALL_H_FILES = $(wildcard *.h)
ALL_C_FILES = $(wildcard *.c)
ALL_CC_FILES = $(wildcard *.cc)
ALL_O_FILES = $(patsubst %.cc,%.o,$(ALL_CC_FILES))  $(patsubst %.c,%.o,$(ALL_C_FILES))



# FLEX is either flex or flex++
FLEX = flex

BISON = bison
BISON_FLAGS = --defines --verbose --debug

loadtech: loadtech.tab.o lex.yy.o  loadtech.o
		$(GNU_COMPILER) -o loadtech loadtech.tab.o loadtech.o lex.yy.o $(LINKOPTS)


loadtech.o: loadtech.cc $(ALL_H_FILES)
		$(GNU_COMPILER) $(GNU_COMPILER_FLAGS) $(DEBUG) loadtech.cc

loadtech.tab.o: loadtech.y $(ALL_H_FILES)
		$(BISON) $(BISON_FLAGS) loadtech.y
		$(GNU_COMPILER) $(GNU_COMPILER_FLAGS) $(DEBUG) loadtech.tab.c

lex.yy.o: loadtech.y loadtech.l $(ALL_H_FILES)
		$(FLEX) loadtech.l
		$(GNU_COMPILER) $(GNU_COMPILER_FLAGS) -I/ncsu/gnu/src/flex-2.5.4  lex.yy.c

%.o : %.c $(ALL_H_FILES)
#	@echo "Creating object file $@ from C file $(patsubst %.o,%.c,$@) ..."
	$(GNU_COMPILER) $(GNU_COMPILER_FLAGS) $< -o $@

%.o : %.cc $(ALL_H_FILES)
#	@echo "Creating object file $@ from C++ file $(patsubst %.o,%.cc,$@) ..."
	$(GNU_COMPILER) $(GNU_COMPILER_FLAGS) $< -o $@

#symbol.o: symbol.c 
#        $(GNU_COMPILER) -O -c $(DEBUG) symbol.c

#assembly.o: assembly.c 
#        $(GNU_COMPILER) -O -c $(DEBUG) assembly.c

clean:
		rm -f loadtech.o loadtech.tab.o lex.yy.o loadtech 
		rm -f loadtech.tab.h loadtech.tab.c loadtech.output lex.yy.cc lex.yy.c
		rm -f *.o loadtech

install: loadtech
		if test ! -d ../../../bin ; then mkdir ../../../bin ; fi
		install loadtech ../../../bin
