###################################################
#
# testproc.tcl
#
# 6/21/2005 Rhett Davis (rhett_davis@ncsu.edu)
#
# This file defines the tcl substeps that serve
# as part of the SSHAFT-API regression test suite.
# It also serves as a template for other tcl
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

proc substep1 {args} {
    beginstep substep1

    # Default argument values
    set depth ""
    set diedepth ""

    logf LOG_INFO "Arguments: $args"

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-depth"] {
            set depth [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-die"] {
            set diedepth [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    set depth "$depth:substep1"

    if [string eq $depth $diedepth] {
        dief "ERROR: Error depth reached: $diedepth"
    } 

    set cmd "substep2 -depth $depth"
    if {![string eq $diedepth ""]} {
        set cmd [concat $cmd "-die $diedepth"]
    }
    substep -cmd $cmd

    endstep
}


proc substep2 {args} {
    beginstep substep2

    # Default argument values
    set depth ""
    set diedepth ""

    logf LOG_INFO "Arguments: $args"

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-depth"] {
            set depth [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-die"] {
            set diedepth [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    set depth "$depth:substep2"

    if [string eq $depth $diedepth] {
        dief "ERROR: Error depth reached: $diedepth"
    } 
    set cmd "testsshaft.tcl -return -depth $depth"
    if {![string eq $diedepth ""]} {
        set cmd [concat $cmd "-die $diedepth"]
    }
    substep -mode unix_step -cmd $cmd

    endstep
}

proc substep3 {args} {
    beginstep substep3

    # Default argument values
    set depth ""
    set diedepth ""

    logf LOG_INFO "Arguments: $args"

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-depth"] {
            set depth [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-die"] {
            set diedepth [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    set depth "$depth:substep3"

    if [string eq $depth $diedepth] {
        dief "ERROR: Error depth reached: $diedepth"
    } 

    endstep
}

