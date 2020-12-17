#########################################################################
#  ICOA Setup Script
#########################################################################

# BEGIN customizable section
setenv CDSHOME          /afs/eos/dist/cadence2010/ic
setenv OA_HOME		/afs/eos/dist/cadence2010/oa
if (`arch` == sun4) then
    setenv CNI_ROOT         /afs/bp/contrib/pycell425/.install/solaris
    setenv CNI_PLAT_ROOT    ${CNI_ROOT}/plat_solaris_32
else
    setenv CNI_ROOT         /afs/bp/contrib/pycell425/.install/linux32
    setenv CNI_PLAT_ROOT    ${CNI_ROOT}/plat_linux_gcc411_32
endif

# New Path Entries
set newdirs = ( \
		$CDSHOME/tools/bin \
		$CDSHOME/tools/dfII/bin \
		$OA_HOME/bin \
		$CNI_PLAT_ROOT/3rd/bin \
		$CNI_PLAT_ROOT/3rd/oa/bin/linux_rhel30_gcc411_32/opt \
		$CNI_PLAT_ROOT/bin \
		$CNI_ROOT/bin \
		/afs/eos/dist/cadence2010/edi/bin \
		/afs/eos/dist/cadence2008/edi/tools/bin \
		)

# New LD_LIBRARY_PATH Entries
set newlibs = ( \
		$CDSHOME/tools/lib \
		$OA_HOME/lib \
		$CNI_PLAT_ROOT/3rd/lib \
		$CNI_PLAT_ROOT/3rd/oa/lib/linux_rhel30_gcc411_32/opt \
		$CNI_PLAT_ROOT/lib \
		)

# New Environment Variables
setenv SKIP_CDS_DIALOG
setenv CDS_LIC_FILE 2101@ece-lic-03.ece.ncsu.edu:2101@ece-lic-04.ece.ncsu.edu:2101@ece-lic-05.ece.ncsu.edu
setenv CDS_Netlisting_Mode Analog
#setenv LD_ASSUME_KERNEL 2.4.1
setenv PYTHONHOME $CNI_PLAT_ROOT/3rd
setenv PYTHONPATH $CNI_ROOT/pylib:$CNI_PLAT_ROOT/pyext:$CNI_PLAT_ROOT/lib:.
# The following gets rid of the annoying messages that pycell prints to stdout
setenv CNI_LOG_DEFAULT /dev/null


# END customizable section



# Extend path
foreach dir ($newdirs)
    set present = `printenv PATH | /bin/grep $dir`
    if ($present == "") then
        set path= ( $dir $path )
    endif
    unset present
end
unset dir newdirs

# Extend LD_LIBRARY_PATH
if ( ! $?LD_LIBRARY_PATH ) then
    setenv LD_LIBRARY_PATH
endif
foreach dir ($newlibs)
    set present = `printenv LD_LIBRARY_PATH | /bin/grep $dir`
    if ($present == "") then
        setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${dir}
    endif
    unset present
end
unset dir newdirs


