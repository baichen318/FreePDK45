###################################################
#
# testproc.py
#
# 8/12/2005 Rhett Davis (rhett_davis@ncsu.edu)
#
# This file defines the python substeps that serve
# as part of the SSHAFT-API regression test suite.
# It also serves as a template for other python
# substeps written in the SSHAFT framework.  
# The complete test calls the following procedures:
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

import sshaft, sys, string

def substep1(depth="", diedepth="", **args):
    sshaft.beginstep('substep1',args)
    depth=depth+":substep1"
    if (depth==diedepth):
        sshaft.dief("ERROR: Error depth reached: "+diedepth)

    sshaft.substep(cmd=[substep2,[],{'depth':depth, 'diedepth':diedepth }])
    
    return sshaft.endstep()

def substep2(depth="", diedepth="", **args):
    sshaft.beginstep('substep2',args)
    depth=depth+":substep2"
    if (depth==diedepth):
        sshaft.dief("ERROR: Error depth reached: "+diedepth)

    cmd="testsshaft.tcl"
    cmd=cmd+" -depth "+depth
    cmd=cmd+" -return"
    if (diedepth):
        cmd=cmd+" -die "+diedepth
    sshaft.substep(mode='unix_step',cmd=cmd)
    
    for app in string.split(sshaft.gettechvar('Sshaft::Apps::AppList')):
        sshaft.dir_init('run/'+app,app)
        cmd=sshaft.gettechvar('Sshaft::Apps::'+app+'::TestCmd')
        sshaft.substep(mode=app+'_step',cmd=cmd,rundir='run/'+app)

    return sshaft.endstep()

def substep3(depth="", diedepth="", **args):
    sshaft.beginstep('substep3',args)
    depth=depth+":substep3"
    if (depth==diedepth):
        sshaft.dief("ERROR: Error depth reached: "+diedepth)

    return sshaft.endstep()
