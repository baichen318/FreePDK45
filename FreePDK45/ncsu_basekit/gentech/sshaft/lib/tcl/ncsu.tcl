###################################################
#
# ncsu.tcl
#
# 10/3/2005 Rhett Davis (rhett_davis@ncsu.edu)
#
#####################################################

proc PRInit {args} {
    beginstep PRInit

    # Default argument values
    set modname [gettechvar "SimplePR::TopModule"]

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-mod"] {
            set modname [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    # Load the Setup File
    loadConfig vlogin.conf
    commitConfig

    # Set up the default Floorplan
    eval [gettechvar "SimplePR::EncounterDefaultFloorplan"]
    eval [gettechvar "SimplePR::EncounterDefaultRing"]
    eval [gettechvar "SimplePR::EncounterDefaultStripe"]

    defOut ${modname}_init.def
    saveDesign ./${modname}_init.enc

    endstep
} 


proc PRPlace {args} {
    beginstep PRPlace

    # Default argument values
    set modname [gettechvar "SimplePR::TopModule"]

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-mod"] {
            set modname [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    restoreDesign ./${modname}_init.enc.dat $modname
    loadTimingCon vlogin.tc

    # Load the IO Constraint file, if it exists
    if [file exists io.place] {
        logf LOG_INFO "Reading IO Constraint file: io.place"
        loadIoFile io.place
        set save_io 0
    } else {
        logf LOG_INFO "IO Constraint file (io.place) not found, saving template in (io.tmpl)"
        logf LOG_INFO "Suggest modifying io.tmpl and saving as io.place"
        set save_io 1
    }

    # Place
    amoebaPlace
    checkPlace

    # Save the IO Constraint Template
    if $save_io {
        saveIoFile io.tmpl
    }

    saveDesign ./${modname}_placed.enc
    setCteReport
    reportTA > timing_placed.rpt

    endstep
} 


proc PRCTS {args} {
    beginstep PRCTS

    # Default argument values
    set modname [gettechvar "SimplePR::TopModule"]

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-mod"] {
            set modname [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    restoreDesign ./${modname}_placed.enc.dat $modname
    loadTimingCon vlogin.tc

    # Load the Clock-Tree Specification file, if it exists
    if [file exists clock.ctstch] {
        logf LOG_INFO "Reading Clock-Tree Specification file: clock.ctstch"
        specifyClockTree -clkfile clock.ctstch
        ckSynthesis -report clock.ctsrpt
        saveClockNets -output clock.ctsntf
    } else {
        logf LOG_INFO "Clock-Tree Specification file (clock.ctstch) not found, saving template in (clock.tmpl)"
        logf LOG_INFO "Suggest modifying clock.tmpl and saving as clock.ctstch"
        createClockTreeSpec -output clock.tmpl -bufFootprint buf -invFootprint inv
    }

    saveDesign ./${modname}_cts.enc

    endstep
} 


proc PRRoute {args} {
    beginstep PRRoute

    # Default argument values
    set modname [gettechvar "SimplePR::TopModule"]

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-mod"] {
            set modname [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    restoreDesign ./${modname}_cts.enc.dat $modname
    loadTimingCon vlogin.tc

    sroute -noBlockPins -noPadRings
    wroute
    addFiller -cell FILL -prefix FILL -fillBoundary

    defOut -floorplan -placement -cutRow -routing $modname.def
    saveDesign ./${modname}_routed.enc

    setCteReport
    reportTA > timing_routed.rpt
    setExtractRCMode -detail
    extractRC
    rcOut -spef $modname.spef
    reportTA > timing_extracted.rpt

    endstep
} 



proc ptClockSkew {args} {
    beginstep ptClockSkew

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-out"] {
            set filename [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-src"] {
            set src [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-sinks"] {
            set sinks [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-drivers"] {
            set drivers [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    set mindelay 0
    set maxdelay 0
    set f [open $filename w]
    foreach sink $sinks {
        set path [get_timing_paths -rise_from $src -to $sink]
        if {$path==""} {
            puts $f -1
	} else {
            set delay [get_attribute $path arrival]
            puts $f $delay
            if {$mindelay==0 || $delay < $mindelay} {
                set mindelay $delay
	    }
            if {$maxdelay==0 || $delay > $maxdelay} {
                set maxdelay $delay
	    }
	}
        
    }
    close $f
    set mintrans 0
    set maxtrans 0
    foreach driver $drivers {
        set trans [get_attribute [find pin $driver] actual_rise_transition_max]
        if {$mintrans==0 || $trans < $mintrans} {
            set mintrans $trans
	}
        if {$maxtrans==0 || $trans > $maxtrans} {
            set maxtrans $trans
	}
    }

    logf LOG_INFO "Sinks: [llength $sinks]"
    logf LOG_INFO "Min Delay: $mindelay"
    logf LOG_INFO "Max Delay: $maxdelay"
    logf LOG_INFO "Skew: [expr $maxdelay - $mindelay]"
    logf LOG_INFO "Last Stage Drivers: [llength $drivers]"
    logf LOG_INFO "Min Transition Time: $mintrans"
    logf LOG_INFO "Max Transition Time: $maxtrans"

    endstep
}

proc ptVerifyTiming {args} {
    beginstep ptVerifyTiming

    # Default argument values
    set sinkfile "../oa/sinks.tcl"
    set modname [gettechvar "SimplePR::TopModule"]
    set netlist [gettechvar "SimplePR::NetlistFile"]
    set netlist "../../$netlist"
    set period [gettechvar "SimplePR::ClockPeriod"]  
    set clksrc [gettechvar "SimplePR::ClockPort"]  
    set indrv [gettechvar "SimplePR::InputDriverCell"]  
    set indrvpin [gettechvar "SimplePR::InputDriverPin"]  

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-mod"] {
            set modname [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-netlist"] {
            set netlist [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-period"] {
            set period [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-clksrc"] {
            set clksrc [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    source $sinkfile
    read_file -format verilog $netlist
    current_design $modname
    create_clock $clksrc -period $period
    set all_inputs_wo_clk [all_inputs]
    set all_inputs_wo_clk [remove_from_collection $all_inputs_wo_clk $clksrc]
    #set_input_delay 200 -clock $clksrc $all_inputs_wo_clk
    set_driving_cell -lib_cell $indrv -pin $indrvpin $all_inputs_wo_clk

    report_timing -delay max > timing.rpt
    #clockskew $clksrc $sinks $laststage_drivers clockskew_nowire.out >> clockskew.rpt
    read_parasitics -format spef ../enc/$modname.spef
    report_timing -delay max > timing_extracted.rpt
    #clockskew clk_i $sinks $laststage_drivers clockskew.out >> clockskew.rpt

    endstep
}


proc dcVerifyPower {args} {
    beginstep dcVerifyPower

    # Default argument values
    set modname [gettechvar "SimplePR::TopModule"]
    set netlist [gettechvar "SimplePR::NetlistFile"]
    set netlist "../../$netlist"
    set period [gettechvar "SimplePR::ClockPeriod"]  
    set clksrc [gettechvar "SimplePR::ClockPort"]  
    set spef "../enc/${modname}.spef"

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-mod"] {
            set modname [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-netlist"] {
            set netlist [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-period"] {
            set period [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-clksrc"] {
            set clksrc [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-vcd"] {
            set vcd [lindex $args 0]
            set args [lrange $args 1 end]
         } elseif [string eq $arg "-spef"] {
            set spef [lindex $args 0]
            set args [lrange $args 1 end]
       } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    read_verilog $netlist
    current_design $modname
    link    

    logf LOG_DEBUG "Creating Clock" 
    create_clock $clksrc -period $period

    report_power > power.rpt

    if [file readable $spef] {
        logf LOG_DEBUG "Reading SPEF file: $spef" 
        #read_parasitics -format spef $spef
        read_parasitics $spef
        report_power > power_extracted.rpt
    }

    endstep
}


proc dcSynth {args} {
    beginstep dcSynth

    # Default argument values
    set modname [gettechvar "SimplePR::TopModule"]
    set src [gettechvar "SimplePR::SourceFile"]
    set src "../../$src"
    set period [gettechvar "SimplePR::ClockPeriod"]  
    set clksrc [gettechvar "SimplePR::ClockPort"]  

    # Parse arguments
    while {[llength $args]>0} {
        set arg [lindex $args 0]
        set args [lrange $args 1 end]
        if [string eq $arg "-mod"] {
            set modname [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-src"] {
            set src [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-period"] {
            set period [lindex $args 0]
            set args [lrange $args 1 end]
        } elseif [string eq $arg "-clksrc"] {
            set clksrc [lindex $args 0]
            set args [lrange $args 1 end]
        } else {
            logf LOG_WARN "WARNING: Unrecognized argument $arg"
        }
    }

    read_verilog $src
    create_clock $clksrc -period $period
    compile
    report_area > area.rpt
    report_timing > timing.rpt
    #write_file -output "${modname}_netl.db"
    write_file -format verilog -output "${modname}_netl.v"

    endstep
}

