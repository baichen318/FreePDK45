#########################################################################
#  SSHAFT Setup Script
#########################################################################

# BEGIN customizable section

setenv MUSE_HOME /afs/eos.ncsu.edu/lockers/research/ece/wdavis
setenv PDK_DIR /local/home/wdavis/freepdk/FreePDK45
setenv SSHAFT_HOME $PDK_DIR/ncsu_basekit/gentech/sshaft

# New Path Entries
set newdirs = ( \
		$SSHAFT_HOME/bin \
		)

# New Environment Variables
#setenv XKEYSYMDB /usr/X11/lib/X11/XKeysymDB

# Environment variables for the automated design flow
setenv SSHAFT_PERL $SSHAFT_HOME/lib/pl
setenv SSHAFT_SKILL $SSHAFT_HOME/lib/il
setenv SSHAFT_TCL $SSHAFT_HOME/lib/tcl

# END customizable section



# Extend path
foreach dir ($newdirs)
    set present = `printenv PATH | /bin/grep $dir`
    if ($present == "") then
        set path= ( $path $dir )
    endif
    unset present
end
unset dir newdirs

# Setup Python 2.4
# (Need to prepend these directories, since some versions of Linux 
# include older versions of Python)
if ( `arch` == sun4 ) then
  set present = `printenv PATH | /bin/grep $MUSE_HOME/bin`
  if ($present == "") then
    set path= ( $MUSE_HOME/bin.sun4v $path )
  endif
  setenv PYTHONHOME $MUSE_HOME/tools/Python-2.4.1
  set present = `printenv PYTHONPATH | /bin/grep $MUSE_HOME`
  if ($present == "") then
    setenv PYTHONPATH $PYTHONHOME/Lib:$PYTHONHOME/Lib/lib-tk:$PYTHONHOME/build/lib.solaris-2.8-sun4u-2.4:$SSHAFT_HOME/lib/py
  endif
else
  set present = `printenv PATH | /bin/grep $MUSE_HOME/bin`
  if ($present == "") then
    set path= ( $MUSE_HOME/bin.lnx86 $path )
  endif
  setenv PYTHONHOME $MUSE_HOME/tools/Python-2.4.3
  set present = `printenv PYTHONPATH | /bin/grep $MUSE_HOME`
  if ($present == "") then
    setenv PYTHONPATH $PYTHONHOME/Lib:$PYTHONHOME/Lib/lib-tk:$PYTHONHOME/build/lib.linux-i686-2.4:$SSHAFT_HOME/lib/py
  endif
endif

