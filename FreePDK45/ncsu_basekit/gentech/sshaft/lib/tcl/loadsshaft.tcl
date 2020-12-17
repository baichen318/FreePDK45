proc loadsshaft {} {
    global env
    source "$env(SSHAFT_TCL)/sshaft.tcl"
    source "$env(SSHAFT_TCL)/testproc.tcl"
    source "$env(SSHAFT_TCL)/ncsu.tcl"
}
loadsshaft
