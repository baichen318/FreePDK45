###################################################
#
# gentech.py
#
# Created 1/3/2007 by Rhett Davis (rhett_davis@ncsu.edu)
#
#####################################################

import sshaft, os, sys, testproc

sshaft.beginstep('gentech.py')

# Parse arguments
args=sys.argv[1:]
while (len(args)>0):
    arg=args[0]
    args=args[1:]
    sshaft.logf('LOG_WARN',"WARNING: Unrecognized argument "+arg)

#filename=os.environ['PDK_DIR']+'/techfile/'+sshaft.gettechvar('GenTech::CdsTechFile')
#libname=sshaft.gettechvar('GenTech::TechLibName')
#tech=sshaft.gettechvar('GenTech::CdsTechData')
#path=os.environ['PDK_DIR']+'/lib/'+libname
#sshaft.dir_init('run/cds','cds')
#cmd='pdkCompileTechLibrary( ?libname "'+libname+'" ?path "'+path+'"'
#cmd+=' ?filename "'+filename+'" ?tech "'+tech+'" )'
#sshaft.substep(mode='cds_step', cmd=cmd, rundir='run/cds')

filename=os.environ['PDK_DIR']+'/ncsu_basekit/techfile/cni/Santana.tech'
libname='NCSU_TechLib_FreePDK45'
pycellname=os.environ['PDK_DIR']+'/ncsu_basekit/lib/'+libname
path=os.environ['PDK_DIR']+'/ncsu_basekit/lib/'+libname
if os.access(path,os.F_OK):
    os.system('rm -rf '+path)
    os.system('rm -rf '+pycellname)
#cmd='cngenlib -c --techfile '+filename+' tech:only '+libname+' '+path+' >& cngenlib.log'
#cmd2='cngenlib --techlib '+libname+' pkg:pycells Xtors '+pycellname+' >& cngenlib2.log'
cmd='cngenlib -c --techfile '+filename+' pkg:pycells  '+libname+' '+path+' >& cngenlib.log'
sshaft.substep(mode='unix_prog', cmd=cmd, env='cadence')
#sshaft.substep(mode='unix_prog', cmd=cmd2, env='pycell') 
#               log='cngenlib.log', logcheck=r"Error", checkmode='fail')

sshaft.dir_init('run/cds','cds')
sshaft.substep(mode='cds_step', cmd='pdkAppendTechfile()', rundir='run/cds')

#inpath=os.environ['PDK_DIR']+'/techfile'
#outpath=path #os.environ['PDK_DIR']+'/techfile/assura'
#sshaft.verify_dir(outpath)
#cmd='genDRC.py -in '+inpath+' -out '+outpath+' >& genDRC.log'
#sshaft.substep(mode='unix_prog',cmd=cmd)
#calibrefile = os.environ['PDK_DIR']+'/ncsu_basekit/techfile/calibre/calibreDRC.rul'
#cmd = 'cp '+calibrefile+' '+path
#sshaft.substep(mode='unix_prog',cmd=cmd)

viadir = os.environ['PDK_DIR']+'/ncsu_basekit/techfile/customvia/*'
cmd = 'cp -r '+viadir+' '+path
sshaft.substep(mode='unix_prog',cmd=cmd)

sshaft.endstep()
