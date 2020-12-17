# Copyright (c) 2001, Regents of the University of California.
#
# See the file "License.terms" for information on usage and redistribution
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.


package sshaft;

use Exporter ();
@ISA    = qw(Exporter);
@EXPORT = qw(beginstep endstep logopen logclose logf dief copy_file substep 
             subprog verify_dir gettechvar dumptech dir_init getopcstr 
             edif_info create_lib map_si_name );

$usage=<<EOM;

Generic SSHAFT UNIX Step
Options:
    -log logfile
    -ll  loglevel
    -li  logindent

EOM


$LOG_MIN =	0;
$LOG_FERR = 	0;
$LOG_ERR =	1;
$LOG_WARN =	2;
$LOG_INFO =	3;
$LOG_ENTRYEXIT =4;
$LOG_DEBUG =	5;
$LOG_LOOP1 = 	6;
$LOG_LOOP2 =	7;
$LOG_LOOP3 = 	8;
$LOG_LOOP4 = 	9;
$LOG_LOOP5 = 	10;
$LOG_LOOP6 =	11;
$LOG_MAX =	11;
$LOG_DEFAULT = 	$LOG_DEBUG;


sub logf {
    $ll = shift;
    if (defined ${$sshaft::{$ll}}) {
	$ll=${$sshaft::{$ll}};
    }
    push @_, "\n";
    unshift @_, $logprefix;
    $loglevel < $ll || print LOG @_;
}


sub logopen {
    if ($logfile) {
        if (!open(LOG,">>$logfile")) {
            die "ERROR: Cannot open $logfile for writing: $!";
	}
    }
    else {
        open(LOG,">-");
    }
    $logprefix = "\t" x $logindent;
}


sub logclose {
    close(LOG);
}


sub timef {
    $sec=$_[0];
    $hrs=int $sec/3600;
    $sec=$sec-($hrs*3600);
    $min=int $sec/60;
    $sec=int $sec-($min*60);
    return sprintf("%dh %dm %ds",($hrs,$min,$sec));
}


sub beginstep {
    $begintime=time;
    $loglevel=$LOG_DEFAULT;
    $logindent=0;
    $tolerance="low";
    $stepname=$_[0];

    @args=();
    while (@ARGV) {
        $_ = shift @ARGV;
        if (/^-log$/) {
            $logfile = shift @ARGV;
        }
        elsif (/^-ll$/) {
            $loglevel = shift @ARGV;
        }
        elsif (/^-li$/) {
            $logindent = shift @ARGV;
        }
        elsif (/^-la$/) {
            $logappend = 1;
        }
        elsif (/^-tol$/) {
            $tolerance = shift @ARGV;
            if ($tolerance ne "high" && $tolerance ne "low") {
                &dief("ERROR: Unrecognized tolerance value: $tolerance (should be low or high)");
            }
        }
        elsif (/^-h$/ || /^help$/ || /^\?$/ || /^-\?$/ || /^-help$/) {
            if (defined $usage) {
		print $usage;
                exit 0;
	    }
        }
        else {
            push @args, $_;
	}
    }
    @ARGV=@args;

    if ($logfile && !$logappend) {
        if (!open(LOG,">$logfile")) {
            die "ERROR: Cannot open $logfile for writing: $!";
	}
        close(LOG);
    }
    &logopen;
    &logf($LOG_ENTRYEXIT,"Begin $stepname");
}

sub endstep {
    $endtime=time;
    ($u_time, $s_time, $cu_time, $cs_time)=times;
    $atime=&timef($endtime-$begintime);
    $utime=&timef($u_time+$cu_time);
    $stime=&timef($s_time+$cs_time);
    &logf($LOG_ENTRYEXIT,"Finished $stepname (elapsed time: $atime actual $utime user $stime system)");
    &logclose;
    exit 0;
}


sub dief {
    if (@_) {
        &logf(0,@_);
        print "@_\n";
    }
    else {
	print "ERROR: Program Terminated.  See log file for details.\n";
    }
    $endtime=time;
    ($u_time, $s_time, $cu_time, $cs_time)=times;
    $atime=&timef($endtime-$begintime);
    $utime=&timef($u_time+$cu_time);
    $stime=&timef($s_time+$cs_time);
    &logf($LOG_FERR,"Terminated $stepname (elapsed time: $atime actual $utime user $stime system)");
    &logclose;
    exit 1;
}


sub substep {
    my $mode = $_[0];     
    my $cmdstr = $_[1];     # command string
    my $rundir = $_[2];     # run directory
    my $log = $_[3];        # filename, STATUS if false
    my $logcheck = $_[4];   # String to find in log file
    my $checkmode = $_[5];  # "pass" (default) or "fail"
    my @deps = @{$_[6]};    # Dependencies for timestamp checking
    my @targs = @{$_[7]};   # Targets for timestamp checking
    my $tol = $_[8];        # "low" (default) if false, "high" if true
    my $logcapture;
    my @cmds;
    my $cmd;

    ##### Check Dependencies #####
    # If any dependency is younger than any target, 
    #    then run the substep.
    $continue=0;
    foreach $targ (@targs) {
        foreach $dep (@deps) {
            $agedep= -M $dep;
            if (!defined $agedep) {
                &dief("ERROR: sshaft.pm: substep: Could not determine age of dependency: $dep");
	    }

            $agetarg= -M $targ;
            if (!defined $agetarg) {
                $continue=1;
                last;
	    }

            if ( $agedep < $agetarg ) {
		$continue=1;
		last;
	    }
	}
        if ($continue) {
	    last;
	}
    }
    if ( $#deps < 0 || $#targs < 0 ) {
        $continue=1;
    }        
    if (!$continue && check_logfile($log,$logcheck,$checkmode)) {
        &logf(3,"Target(s) up-to-date: Skipping substep");
        return;
    }


    ##### Change the working directory #####
    if ($rundir =~ /^\//) {
        &dief("ERROR: sshaft.pm: substep: run directory $rundir is an absolute path.\nOnly relative paths are supported for substep run directories");
    }
    $oldlogfile=$logfile;
    if ( defined $rundir ) {
        &logf($LOG_DEBUG,"Chdir $rundir");
        if (!chdir $rundir) {
            &dief("ERROR: sshaft.pm: substep: Could not chdir to $rundir: $!");
        }
        # Log file path needs to be updated after changing the directory
        @temp = split "/",$rundir;
        foreach $tmp (@temp) {
            if ($tmp eq "." || $tmp eq "..") {
                &dief("ERROR: sshaft.pm: substep: run directory $rundir contains \".\" or \"..\" (not allowed)");
	    }
	}
        $dirprefix = "../" x ($#temp+1);
        if ( $logfile && !($logfile =~ /^\//) ) {
            $logfile="$dirprefix$logfile";
        } 
        if ( $log && !($log =~ /^\//)) {
            $logcapture="$dirprefix$log";
	}
    }   

    #### Set up tolerance ####
    if (!defined $tol) {
        $tol=$tolerance;
    }
    if ($tol ne "high" && $tol ne "low") {
        &dief("ERROR: sshaft.pm: substep: Unrecognized tolerance value: $tol (should be low or high)");
    }

    ##### Execute the step #####
    if ( $mode eq unix_step ) {
        @cmds = split ';',$cmdstr;
        foreach $cmd (@cmds) {
            ### Add Logging info to arguments ###
            @args = split ' ', $cmd;
            if ( defined $logfile ) {
                push @args,("-log",$logfile,"-la");
            }
            if ( $loglevel <= 0) {
                push @args,("-ll",0);
            }
            else {
                push @args,("-ll",$loglevel);
            }
            push @args, ("-li",$logindent+1);
            push @args, ("-tol",$tol);
            $cmd = join ' ', @args;

            ### Execute ###
            &logf($LOG_INFO,"Executing: $cmd");
            &logclose;
            $retval=system(@args)/256;
            &logopen;
            if ($retval) {
                if ($tol eq "high") {
                    &logf(0,"ERROR: $args[0] did not run successfully");
	        }
                else {
                    &dief("ERROR: $args[0] did not run successfully");
	        }
            }
	}
    }
    elsif ( !defined $mode || $mode eq unix_prog ) {
        @cmds = split ';',$cmdstr;
        foreach $cmd (@cmds) {
            if ($cmd =~ /([^>&]+)(>\s*>?\s*&?\s*)(\S+)(.*)/) {
                $cmd=$1.$4;
                @args = split ' ',$cmd;
                $capturemode=join '',split ' ',$2;
                $logcapture=$3;

                ### Execute ###
                &logf($LOG_INFO,"Executing: $cmd $capturemode $logcapture");
                &logclose;
                if ($capturemode =~ /^>>/) {
                    if (!open(PROGLOG,">>$logcapture")) {
                        &logopen;
                        &dief("ERROR: Could not open $logcapture for writing: $!");
	            }
	        }
                else {
                    if (!open(PROGLOG,">$logcapture")) {
                        &logopen;
                        &dief("ERROR: Could not open $logcapture for writing: $!");
	            }
	        }

                if ($capturemode =~ /&$/) {
                    if (!open(PROG,"$cmd 2>&1 |")) {
                        &logopen;
                        &dief("ERROR: Could not execute \"$cmd\": $!");
		    }
	        }
                else {
                    if (!open(PROG,"$cmd |")) {
                        &logopen;
                        &dief("ERROR: Could not execute \"$cmd\": $!");
		    }
	        }
                &logopen;

                while (<PROG>) {
                    print PROGLOG;
	        }
                close(PROG);
                $retval=$?/256;
                &logf($LOG_INFO,"$args[0] returned with value $retval");
                close(PROGLOG);
	    }
            else {
                @args = split ' ',$cmd;
                &logf($LOG_INFO,"Executing: $cmd");
                $retval=system(@args)/256;
                &logf($LOG_INFO,"$args[0] returned with value $retval");
	    }
        }
    }
    elsif ($mode eq skill_step) {
        $logcapture="CDS.log";
        $log="$rundir/CDS.log";
        $logcheck='/^\\\\t t/';

        #### Add Logging Arguments ####
        if (!($cmdstr =~ /(.*)\)\s*$/)) {
            dief("ERROR: sshaft.pm: substep: incorrectly formatted command string: $cmdstr");
	}
        $temp=$logindent+1;
        if ($logfile) {
            $cmdstr="$1 ?stepargs list( \"$logfile\" t $loglevel $temp \"$tol\" ))";
        }
        else {
            $cmdstr="$1 ?stepargs list( nil nil $loglevel $temp \"$tol\" ))";
	}
        #### Create SKILL File ####
        &logf($LOG_INFO,"Creating SKILL script \"exe.il\" for command: $cmdstr");
        if (!open(SKILL,">exe.il")) {
            &dief("ERROR: sshaft.pm: substep: could not create exe.il: $!");
	}
        print SKILL "$cmdstr\n";
        close(SKILL);

        #### Run icfb ####
        @args = ("icfb","-log",$logcapture,"-nograph","-replay","exe.il");
        $cmd=join ' ',@args;
        &logf($LOG_INFO,"Executing: $cmd");
        &logclose;
        $retval=system(@args)/256;
        &logopen;
        &logf($LOG_INFO,"$args[0] returned with value $retval");
    }
    elsif ($mode eq skill_proc) {
        if (!$logcapture) {
            $logcapture="CDS.log";
	}
        if (!$log) {
            $log="$rundir/CDS.log";
	}
        if (!defined $logcheck) {
            $logcheck='/^\\\\t t/';
	}
        else {
            $logcheck='/^\\\\t '.$logcheck.'/';
	}

        #### Create SKILL File ####
        &logf($LOG_INFO,"Creating SKILL script \"exe.il\" for command: $cmdstr");
        if (!open(SKILL,">exe.il")) {
            &dief("ERROR: sshaft.pm: substep: could not create exe.il: $!");
	}
        print SKILL "$cmdstr\n";
        close(SKILL);

        #### Run icfb ####
        @args = ("icfb","-log",$logcapture,"-nograph","-replay","exe.il");
        $cmd=join ' ',@args;
        &logf($LOG_INFO,"Executing: $cmd");
        $retval=system(@args)/256;
        &logf($LOG_INFO,"$args[0] returned with value $retval");
    }
    elsif ($mode eq pillar_step) {
        #### Determine areaPdp logfile name ####
        # This code allows the flow to work, even if someone is
        # currently running areaPdp
        if (!-e ".hld/areaPdp.log.lck") {
            $log="$rundir/areaPdp.log";
        }
        else {
            $log=undef;
            $idx=1;
            while (!defined $log) {
                if (!-e ".hld/areaPdp.log.$idx.lck") {
                    $log="$rundir/areaPdp.log.$idx";
                }
                $idx++;
                # Safety for infinite loop...
                if ($idx > 1000) {
                    &dief("ERROR: sshaft.pm: substep: Could not determine areaPdp log file name");
                } 
            }
        }

        $logcheck='/exe.cl completed successfully/';

        #### Add Logging Arguments ####
        if (!($cmdstr =~ /(.*)\)\s*$/)) {
            dief("ERROR: sshaft.pm: substep: incorrectly formatted command string: $cmdstr");
	}
        $temp=$logindent+1;
        if ($logfile) {
            $cmdstr="$1 ?stepargs (list \"$logfile\" $loglevel $temp \"$tol\" ))";
        }
        else {
            $cmdstr="$1 ?stepargs (list nil $loglevel $temp \"$tol\" ))";
	}
        #### Create CLISP File ####
        &logf($LOG_INFO,"Creating CLISP script \"exe.cl\" for command: $cmdstr");
        if (!open(CLISP,">exe.cl")) {
            &dief("ERROR: sshaft.pm: substep: could not create exe.cl: $!");
	}
        print CLISP "(if $cmdstr then\n";
        print CLISP "  (printf \"exe.cl completed successfully\\n\")\n";
        print CLISP ") ;if\n";
        print CLISP "(excl:exit)\n";
        close(CLISP);

        #### Run areaPdp ####
        @args = ("areaPdp","-ge","-gui","-logwin","-noss",
                 "-eval","(load \"exe.cl\")");
        $cmd=join ' ',@args;
        &logf($LOG_INFO,"Executing: $cmd");
        &logclose;
        $retval=system(@args)/256;
        &logopen;
        &logf($LOG_INFO,"$args[0] returned with value $retval");
    }
    else {
        &dief("ERROR: sshaft.pm: substep: Unrecognized mode $mode");
    }


    ##### Change back to the root directory #####
    if ( defined $rundir ) {
        &logf($LOG_DEBUG,"Chdir $dirprefix");
        if (!chdir $dirprefix) {
            &dief("ERROR: Could not chdir to root directory: $!");
        }
        $logfile=$oldlogfile;
    }

    if (!check_logfile($log,$logcheck,$checkmode,$retval)) {
        if ($log) {
            $logcheckcue="\nSee $log for details";
        }
        elsif ($logcapture) {
            $logcheckcue="\nSee $logcapture for details";
        }
        else {
            $logcheckcue="";
        }

        if ($tol eq "high") {
            &logf(0,"ERROR: $args[0] did not run successfully$logcheckcue");
        }
        else {
            &dief("ERROR: $args[0] did not run successfully$logcheckcue");
        }
    }
}

sub check_logfile {
    my $log=$_[0];
    my $logcheck=$_[1];
    my $checkmode=$_[2];
    my $retval=$_[3];
    my $check=0;

    if (!defined $logcheck) {
	return(1);
    }
    #### Check the LOG File ####
    if ($log) {
        if (!open(PROGLOG,"$log")) {
            &dief("ERROR: sshaft.pm: check_logfile: Could not open $log for reading: $!");
	}
        while (<PROGLOG>) {
            if (eval $logcheck) {
                $check=1;
                last;
	    }
	}
        close(PROGLOG);
    }
    else {
        if ($retval == $logcheck) {
            $check=1;
	}
    }

    if (($checkmode eq "fail" && $check) ||
        ($checkmode ne "fail" && !$check)) {
	return(0);
    }
    return(1);
}


sub verify_dir {
    # Verifies that a directory exists
    my $dir="";
    my $subdir;
    my @dirs = split '/',$_[0];
    if ($_[0] =~ /^\//) {
        $dir = "/";
    }
    foreach $subdir (@dirs) {
        $dir=$dir.$subdir;
        if (!-e $dir) {
            if (!mkdir $dir, 0755) {
                &dief("ERROR: Could not create directory $dir: $!");
	    }
	}
        elsif (!-d $dir) {
            &dief("ERROR: $dir exists and is not a directory");
	}
        $dir=$dir.'/';
    }
}


sub gettechvar {
    my $var=$_[0];
    my $val;
    if (!defined %TECH) {
        &read_techfile();
    }
    $val=$TECH{$var};
    if (!defined $val) {
	$val=$ENV{$var};
    }
    return $val;
}

sub dumptech {
    &logf(0,"Technology Info:");
    foreach $key (keys(%TECH)) {
        &logf(0,"$key\t$TECH{$key}");
    }
}

sub read_techfile {
    my $var;
    my $val;
    open(PROG,"loadtech |");
    while (<PROG>) {
        chop;
        $var=$_;
        $_=<PROG>;
        chop;
        $val=$_;
        $TECH{$var}=$val
    }
    close(PROG);
}

sub read_techfile_old {
    my $lastchar;
    if (!open(TECHFILE,$ENV{SSHAFT_TECHFILE})) {
        dief("ERROR: sshaft.pm: read_techfile: Cannot open \"$ENV{SSHAFT_TECHFILE}\" (techfile) for reading!");
    }
    while (<TECHFILE>) {
        $lastchar = chop;
        while (($lastchar eq " ") || ($lastchar eq "\t") || 
               ($lastchar eq "\n")) {
            $lastchar = chop;
	}
        $_=$_.$lastchar;
        if (!/^\s*#/ && !/^\s*$/) {   # Ignore Comments
            if (/^\s*\+\s*(.*)/) {
                $line=$line.' '.$1;
	    }
            else {
                &process_techline();
                $line=$_;
	    }
	}
    }
    close(TECHFILE);
    &process_techline();
}


sub process_techline {
    if (!defined $line) {
        return;
    }
    $line=&expand_techvar($line);
    if ($line =~ /^\s*(\w+)\s*=\s*(.*)/) {
        if (defined $ENV{$1}) {
            $TECH{$1}=$ENV{$1};
        }
        else {
            $TECH{$1}=$2;
        }
    }
}
    
sub expand_techvar {
    my $line = $_[0];
    my $head;
    my $tail;
    my $var;
    my $val;

    if ( $line =~ /^(.*)(\$\{?)(\w*)(\}?)(.*)$/) {
        if (!$3) {
            $head=$1;
            $val=$2;
            $tail=$3.$4.$5;
            $head=&expand_techvar($head);
            $tail=&expand_techvar($tail);
            return $head.$val.$tail;
	}
        $head=$1;
        $var=$3;
        $tail=$5;
        $val=$TECH{$var};
        if (!defined $val) {
            $val=$ENV{$var};
            if (!defined $val) {
                &logf(0,"ERROR: sshaft.pm: expand_techvar: Attempt to dereference undefined macro \"$var\" in techfile, line \"$line\"");
                &dumptech;
	        &dief;
            }
        }
        $head=&expand_techvar($head);
        $tail=&expand_techvar($tail);
        $line=$head.$val.$tail;
    }
    return $line;
}




sub copy_file {
    if (!open(SRC,$_[0])) {
        &dief("ERROR: sshaft.pm: copy_file: Could not open $_[0] for reading");
    }
    if (!open(DEST,">$_[1]")) {
        &dief("ERROR: sshaft.pm: copy_file: Could not open $_[1] for writing");
    }
    while (<SRC>) {
        print DEST;
    }
    close(SRC);
    close(DEST);
}
    
sub dir_init {
    my $dirname=$_[0];
    my $mode=$_[1];
    my $filelist=gettechvar("Sshaft::Apps::${mode}::InitFiles");
    my @files=split ' ',$filelist;
    my $srcname, $destname;

    while (@files) {
        $destname = shift @files;
        $srcname = shift @files;
        if (!-e "$dirname/$destname") {
            &logf($LOG_INFO,"Creating $dirname/$destname file");
            &copy_file($srcname,"$dirname/$destname");
        }
    }
}

sub getopcstr {
    my $type=$_[0];
    my $opc=$_[1];
    my $str,$count,$ident,$descr,$value,$default;

    my $opcstr=gettechvar("SshaftOpCondStrings");

    while ( $opcstr ) {
        if ($opcstr =~ /^\s*\(\s*(\w+)(.*)/ )  {
            $str=$1;
            $opcstr=$2;
            $count=1;
            while ( $opcstr ) {
                if ($opcstr =~ /^\s*\(([^\)]*)\)(.*)/ ) {
                    $line=$1;
                    $opcstr=$2;
                    if ($str eq $type &&
                        $line =~ /^\s*(\w+)\s+\"([^\"]*)\"\s*\"([^\"]*)\"(.*)/) {
                        $ident=$1;
                        $descr=$2;
                        $value=$3;
                        if ($4 =~ /^\s*(\S+)/) {
                            $default=$1;
		        }
		        else {
                            $default=undef;
	    	        }
                        if ($opc == $count || $opc eq $ident) {
                            logf($LOG_DEBUG,"Operating Condition: $descr");
                            return $value;
			}
                        elsif ( (!defined $opc || $opc eq "0") 
                                && defined $default ) {
                            logf($LOG_DEBUG,"Default Operating Condition: $descr");
                            return $value;
			}
                        $count++;
                    }
	        }
                elsif ($opcstr =~ /^\s*\)(.*)/) {
                    if ($str eq $type) {
                        logf($LOG_ERR,"ERROR: sshaft.pm: getopcstr: Could not find operating condition $opc");
                        $opcstr=undef;
		    }
                    else {
                        $opcstr=$1;
		    }
                    last;
                } 
                else {
                    last;
	        }
            }
        }
        else {
            last;
        }
    }
    logf($LOG_ERR,"ERROR: sshaft.pm: getopcstr: Failed to handle $type");

    $opcstr=gettechvar("SshaftOpCondStrings");

    while ( $opcstr ) {
        if ($opcstr =~ /^\s*\(\s*(\w+)(.*)/ )  {
            $str=$1;
            $opcstr=$2;
            $count=1;
            if ($str eq $type) {
                logf($LOG_ERR,"Possible Values for $type:");
                logf($LOG_ERR,"Default\tNumber\tIdentifier\tDescription");
	    }
            while ( $opcstr ) {
                if ($opcstr =~ /^\s*\(([^\)]*)\)(.*)/ ) {
                    $line=$1;
                    $opcstr=$2;
                    if ($str eq $type &&
                        $line =~ /^\s*(\w+)\s+\"([^\"]*)\"\s*\"([^\"]*)\"(.*)/) {
                        $ident=$1;
                        $descr=$2;
                        $value=$3;
                        if ($4 =~ /^\s*(\S+)/) {
                            $default=$1;
		        }
		        else {
                            $default=undef;
	    	        }
                        if ($ident =~ /^\w{1,7}$/) {
                            $ident="$ident\t";
        	        }
                        logf($LOG_ERR,"$default\t$count\t$ident\t$descr");
                        $count++;
                    }
	        }
                elsif ($opcstr =~ /^\s*\)(.*)/) {
                    $opcstr=$1;
                    last;
                } 
                else {
                    last;
	        }
            }
        }
        else {
            last;
        }
    }

    endstep;

}


sub edif_info {

    # This subroutine returns an array of arrays and a string:
    # ( 
    #   @liblist   - list of strings containing libraries
    #   @celllist  - list of "libname cellname viewname" strings for each cell
    #   $design    - the top-level cell in the form "libname cellname"
    # )
    #
    # This procedure assumes that the edif non-terminals "library",
    # "cell", "view" and "design" do not appear on the same line or more
    # than once on a line.
    #
    # It also ignores all "rename" non-terminals.

    my $edifname = $_[0];
    my $line;
    my $libname;
    my $cellname;
    my $viewname;

    my @celllist=();
    my @liblist=();  
    my $design;

    if (!open(EDIF,"$edifname")) {
        &dief("ERROR: sshaft.pm: edif_celllist: Could not open $edifname for reading");
    }
    while (<EDIF>) {
        if (/[\(\s](library[\s\Z].*)/) {
            $line=$1;
        }
        elsif ($libname && /[\(\s](cell[\s\Z].*)/) {
            $line=$1;
        }
        elsif ($libname && /[\(\s](view[\s\Z].*)/) {
            $line=$1;
        }
        elsif (/[\(\s](design[\s\Z].*)/) {
            $line=$1;
        }
        elsif (/[\(\s](external[\s\Z].*)/) {
            $libname=undef;
	}

        if ($line) {
            if ($line =~ /^library\s+(\w+)/) {
                $libname = $1;
                $line = undef;
                push @liblist,$libname;
	    }
            elsif ($line =~ /^cell\s+(\w+)/) {
                $cellname = $1;
                $line = undef;
	    }
            elsif ($line =~ /^view\s+(\w+)/) {
                $viewname = $1;
                $line = undef;
                push @celllist,"$libname $cellname $viewname";
	    }
            elsif ($line =~ /^design\s+\w+\s*\(\s*cellRef\s+(\w+)\s*\(\s*libraryRef\s+(\w+)/) {
                $design = "$2 $1";
                $line = undef;
	    }
            else {
                $line=$line.$_;
	    }
	}
    }

    close(EDIF);

    return(\@liblist,\@celllist,$design);
}

sub map_si_name {
    my $mode = $_[0];
    my $name = $_[1];
    my $cellname = $_[2];
    my $viewname = $_[3];
    my $check=0;

    my $mapname;

    my $mapfile=&gettechvar("SshaftSiGlobalMapFile");

    if (!open(MAP,"$mapfile")) {
        &dief("ERROR: sshaft.pm: map_si_name: Could not open $mapfile for reading");
    }
    if ($mode eq model) {
        while (<MAP>) {
            if (/^\$model$/) {
                $check=1;
            }
            if (/^\$endmodel$/) {
                last;
            }
            if ($check) {
                if (/$name\/$cellname\/$viewname\s+(\w+)/) {
                    $mapname=$1;
                    last;
                }
	    }
        }
    }
    elsif ($mode eq net) {
        while (<MAP>) {
            if (/^\$net$/) {
                $check=1;
            }
            if (/^\$endnet$/) {
                last;
            }
            if ($check) {
                if (/$name\s+(\w+)/) {
                    $mapname=$1;
                    last;
                }
	    }
        }
    }
    else {
        dief("ERROR: sshaft.pm: map_si_name: Unrecognized mode $mode");
    }

    close(MAP);
    return($mapname);
}
