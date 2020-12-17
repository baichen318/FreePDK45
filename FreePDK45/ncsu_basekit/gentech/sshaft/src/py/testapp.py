###################################################
#
# testapp.py
#
# 8/12/2005 Rhett Davis (rhett_davis@ncsu.edu)
#
# This file defines the python script-application
# that serves as part of the SSHAFT-API regression
# test suite.  It also serves as a template for other 
# script-applications (scriptapps) written 
# in the SSHAFT framework.  The complete test
# calls the following procedures:
#
# -- testsshaft.tcl
#    foreach scriptapp
#      |-- scriptapp
#          |-- substep1
#              |-- substep2
#                  |-- testsshaft.tcl -return
#                  foreach app
#                    |-- app:substep3
#    foreach app
#      |-- app:substep1
#          |-- substep2
#              |-- testsshaft.tcl -return
#              foreach app
#                |-- app:substep3
#
# The -depth argument to each step indicates the
# depth of descent.  The stepname and appname are
# added to this argument (separated by a colon) 
# and passed to each substep.  If -depth is omitted, 
# it is assumed to be and empty string.  It is 
# assumed that the first call to testsshaft.tcl will 
# leave the -depth argument blank, meaning that the 
# depth will be "testsshaft.tcl" for substep1,
# "testsshaft.tcl:substep1" in substep2, and so on.
#
# The -die argument tells the depth at which the
# dief API function should be called.  For example,
# assuming that the first scriptapp called is
# testapp.tcl, if the -die argument is set to 
# testsshaft.tcl:testapp.tcl:substep1, then dief
# will be called in substep1 before calling substep2.
#
# The -return argument tells testsshaft.tcl to return
# without calling any of the substeps.  This argument
# is used so that testsshaft.tcl can double as a
# leaf-node in the regression test tree.
#
# testsshaft.tcl is defined in 
#     dist/src/tcl/testsshaft.tcl
# The other scriptapps are defined in 
#     dist/src/[lang]/testapp.[lang]
#     where [lang] is tcl, py, or pl
# substep1, substep2, and substep3 are defined in
#     dist/lib/[lang]/testproc.[lang]
#     where [lang] is tcl, py, or il
#
#####################################################

import sshaft, sys, testproc

sshaft.beginstep('testapp.py')

ret=0
depth=""
diedepth=""

# Parse arguments
args=sys.argv[1:]
sshaft.logf('LOG_INFO',"Arguments: "+str(args))
while (len(args)>0):
    arg=args[0]
    args=args[1:]
    if (arg=="-return"):
        ret=1
    elif (arg=="-depth"):
        depth=args[0]
        args=args[1:]
    elif (arg=="-die"):
        diedepth=args[0]
        args=args[1:]
    else:
        sshaft.logf('LOG_WARN',"WARNING: Unrecognized argument "+arg)

if (not depth):
    depth="testapp.py"
else:
    depth=depth+":testapp.py"

if (depth==diedepth):
    sshaft.dief("ERROR: Error depth reached: "+diedepth)

if (not ret):
    sshaft.substep(cmd=[testproc.substep1,[],{'depth':depth, 'diedepth':diedepth }])
    
sshaft.endstep()
