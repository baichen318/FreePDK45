

namespace eval sshaft {
  array set loglevels {
    LOG_MIN       0
    LOG_FERR      0
    LOG_ERR       1
    LOG_WARN      2
    LOG_INFO      3
    LOG_ENTRYEXIT 4
    LOG_DEBUG     5
    LOG_LOOP1     6
    LOG_LOOP2     7
    LOG_LOOP3     8
    LOG_LOOP4     9
    LOG_LOOP5     10
    LOG_LOOP6     11
    LOG_MAX       11
    LOG_DEFAULT   5
  }

  variable logfile ""  loglevel 0 logindent 0 logappend 0
  variable tolerance "low"
  variable loglevel $loglevels(LOG_DEFAULT)
  variable logport stdout logprefix "" begintime 0
  variable techns "" stepname ""
  variable tech

  namespace export logf beginstep endstep dief substep verify_dir gettechvar read_techfile dumptech dir_init

}


proc sshaft::getcontext {} {
  set context [list logfile $sshaft::logfile loglevel $sshaft::loglevel \
               logindent $sshaft::logindent logappend $sshaft::logappend \
               tolerance $sshaft::tolerance logport $sshaft::logport \
               logprefix $sshaft::logprefix begintime $sshaft::begintime \
               techns $sshaft::techns stepname $sshaft::stepname ]
  return $context
}

proc sshaft::restorecontext {context} {
  foreach {var val} $context {
    set sshaft::$var $val
  }
}


proc sshaft::logf {ll msg} {
  if {$sshaft::loglevel >= $sshaft::loglevels($ll)} {
    puts $sshaft::logport "$sshaft::logprefix$msg"
  }
}


proc sshaft::logopen {} {
  if [string length $sshaft::logfile] {
    if [catch {open $sshaft::logfile "a"} sshaft::logport] {
      dief "ERROR: Cannot open $sshaft::logfile for writing: $sshaft::logport"
    }  
  }
  set sshaft::logprefix ""
  for {set i 0} {$i < $sshaft::logindent} {incr i} {
    set sshaft::logprefix "\t$sshaft::logprefix"
  }
}


proc sshaft::logclose {} {
  if [string length $sshaft::logfile] {
    close $sshaft::logport
  }
}


proc sshaft::timef {sec} {
  set hrs [expr $sec/3600]
  set sec [expr $sec-($hrs*3600)]
  set min [expr $sec/60]
  set sec [expr $sec-($min*60)]
  return "${hrs}h ${min}m ${sec}s"
}


proc sshaft::beginstep {name} {
  upvar args args
  if {![info exists args]} {
    upvar argv args
  }
  set sshaft::stepname $name
  set newargs {}
  while {[llength $args]>0} {
    set arg [lindex $args 0]
    set args [lrange $args 1 end]
    if [string equal $arg "-log"] {
      set sshaft::logfile [lindex $args 0]
      set args [lrange $args 1 end]
    } elseif [string equal $arg "-ll"] {
      set sshaft::loglevel [lindex $args 0]
      set args [lrange $args 1 end]
    } elseif [string equal $arg "-li"] {
      set sshaft::logindent [lindex $args 0]
      set args [lrange $args 1 end]
    } elseif [string equal $arg "-la"] {
      set sshaft::logappend 1
    } elseif [string equal $arg "-tol"] {
      set sshaft::tolerance [lindex $args 0]
      set args [lrange $args 1 end]
    } else {
      lappend newargs $arg
    }
  }
  if {[string length $sshaft::logfile] && !($sshaft::logappend)} {
    if [catch {open $sshaft::logfile "w"} sshaft::logport] {
      dief "ERROR: Cannot open $sshaft::logfile for writing: $sshaft::logport"
    }
    close $sshaft::logport
  }
  set sshaft::begintime [clock seconds]
  logopen
  logf LOG_ENTRYEXIT "Begin $sshaft::stepname"
  set args $newargs
}


proc sshaft::endstep {} {
  set endtime [clock seconds]
  set timestr [timef [expr $endtime-$sshaft::begintime]]
  logf LOG_ENTRYEXIT "Finished $sshaft::stepname (elapsed time: $timestr actual)"
  logclose
  return -code return
}



proc sshaft::dief {msg} {
  set endtime [clock seconds]
  set timestr [timef [expr $endtime-$sshaft::begintime]]
  logf LOG_FERR $msg
  logf LOG_FERR "Terminated $sshaft::stepname (elapsed time: $timestr actual)"
  error $msg
}


proc sshaft::read_techfile {args} {
  if [array exists sshaft::tech] {
    foreach var [array names sshaft::tech] {
      array unset sshaft::tech $var
    }
  }
    if {[llength $args]>0 && ![string eq [lindex $args 0] ""]} {
    set cmd "|loadtech -n [lindex $args 0]"
    set sshaft::techns [lindex $args 0]
  } else {
    set cmd "|loadtech"
  }
  set errorflag [catch {open $cmd "r"} techchan]
  if $errorflag {
    dief "ERROR: sshaft.tcl: read_techfile: error running $cmd"
  }
  while {[gets $techchan var] >= 0} {
    if {[gets $techchan val] < 0} {
      dief "ERROR: sshaft.tcl: read_techfile: no value for variable $var"
    }
    set sshaft::tech($var) $val
  }
  close $techchan
}


proc sshaft::gettechvar {var} {
  if {![array exists sshaft::tech]} {
    sshaft::read_techfile
  }
  if {[array names sshaft::tech $var]>0} {
    return $sshaft::tech($var)
  }
  logf LOG_ERR "ERROR: sshaft.tcl: gettechvar: variable $var not defined in techfile\nRun loadtech from UNIX command line to debug techfile"
}

proc sshaft::dumptech {} {
  logf LOG_ERR "Technology Info:"
  if [array exists sshaft::tech] {
    foreach var [array names sshaft::tech] {
      logf LOG_ERR "$var = $sshaft::tech($var)"
    }
  }
}


#proc sshaft::get_dir_prefix {rundir} {

proc sshaft::substep {args} {
  #### Parse Arguments ####
  array set options {
    -mode tcl_step
    -cmd ""
    -rundir ""
    -log ""
    -logcheck ""
    -checkmode ""
    -deps {}
    -targs {}
    -tol {}
  }
  set optstr [join [array names options *] ", "]
  foreach {flag value} $args {
    if [string match "*$flag,*" $optstr] {
      set options($flag) $value
    } else {
      logf LOG_WARN "WARNING: Uncrecognized option $flag, must be: $optstr"
    }
  }

  #### Execute the step ####
  if [string eq $options(-mode) tcl_step] {
    set cmd $options(-cmd)
    if [string length $sshaft::logfile] {
      set cmd [concat $cmd -log $sshaft::logfile -la ]
    }
    set cmd [concat $cmd -ll $sshaft::loglevel ] 
    set cmd [concat $cmd -li [expr $sshaft::logindent+1] ]
    set cmd [concat $cmd -tol $sshaft::tolerance ]
    logf LOG_DEBUG "Executing: $cmd"
    logclose
    set context [sshaft::getcontext]
    set errorflag [catch $cmd retval]
    set temptechns $sshaft::techns
    sshaft::restorecontext $context
    if {![string eq $sshaft::techns $temptechns]} {
      sshaft::read_techfile $sshaft::techns
    }
    logopen
    logf LOG_DEBUG "Step returned with value \"$retval\""
    if $errorflag {
      if [string eq $sshaft::tolerance "high"] {
        logf LOG_ERR "ERROR: Substep did not run successfully"
      } else {
        dief "ERROR: Substep did not run successfully"
      }
    }
  } elseif [string eq $options(-mode) unix_step] {
    set cmd $options(-cmd)
    if [string length $sshaft::logfile] {
      set cmd [concat $cmd -log $sshaft::logfile -la ]
    }
    set cmd [concat $cmd -ll $sshaft::loglevel ] 
    set cmd [concat $cmd -li [expr $sshaft::logindent+1] ]
    set cmd [concat $cmd -tol $sshaft::tolerance ]
    #set cmd [concat exec sh -c \"$cmd\"]
    set cmd [concat exec $cmd]
    logf LOG_DEBUG "Executing: $cmd"
    logclose
    #set context [sshaft::getcontext]
    set errorflag [catch $cmd retval]
    #sshaft::restorecontext $context
    logopen
    logf LOG_DEBUG "Step returned with value \"$retval\""
    if $errorflag {
      if [string eq $sshaft::tolerance "high"] {
        logf LOG_ERR "ERROR: Substep did not run successfully"
      } else {
        dief "ERROR: Substep did not run successfully"
      }
    }
  } else {
    dief "ERROR: sshaft.tcl: substep: Unrecognized mode $options(-mode)"
  }


} 

#proc sshaft::check_logfile {log logcheck checkmode args} {

proc sshaft::verify_dir {dirname} {
  set dir ""
  set dirs [split $dirname "/"]
  if [string eq [string index $dirname 0] "/"] {
    set dir "/"
  }
  foreach {subdir} $dirs {
    set dir "$dir$subdir"
    if {![file readable $dir]} {
      set errorflag [catch {file mkdir $dir} ]
      if $errorflag {
        dief "ERROR: sshaft.tcl: verify_dir: could not create directory $dir"
      }
    }
    set dir "$dir/"
  }
}


proc sshaft::copy_file {srcname destname} {
  set errorflag [catch {open $srcname "r"} src]
  if $errorflag {
    dief "ERROR: sshaft.tcl: copy_file: could not open file $srcname"
  }
  set errorflag [catch {open $destname "w"} dest]
  if $errorflag {
    dief "ERROR: sshaft.tcl: copy_file: could not open file $destname"
  }
  while {[gets $src line] >= 0} {
      puts $dest $line
  }
  close $src
  close $dest
}

proc sshaft::dir_init {dirname mode} {
    set tempns $sshaft::techns
    if {![string eq $tempns Sshaft::Apps]} {
        sshaft::read_techfile Sshaft::Apps
    }

    verify_dir $dirname
    set srcdir [gettechvar "${mode}::TemplateDir"]
    set srcfiles [gettechvar "${mode}::InitSrcFiles"]
    set destfiles [gettechvar "${mode}::InitDestFiles"]
    for {set i 0} {$i < [llength $srcfiles]} {incr i} {
	set srcfile "$srcdir/[lindex $srcfiles $i]"
        set destfile "$dirname/[lindex $destfiles $i]"
        if {![file exists $destfile]} {
            logf LOG_INFO "Creating $destfile"
            copy_file $srcfile $destfile
	}
    }

    if {![string eq $tempns Sshaft::Apps]} {
        sshaft::read_techfile $tempns
    }
}


namespace import -force sshaft::*
