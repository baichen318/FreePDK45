
import sys, os, time, string, subprocess, re
import setup

loglevels = { 'LOG_MIN':       0 ,\
              'LOG_FERR':      0 ,\
              'LOG_ERR':       1 ,\
              'LOG_WARN':      2 ,\
              'LOG_INFO':      3 ,\
              'LOG_ENTRYEXIT': 4 ,\
              'LOG_DEBUG':     5 ,\
              'LOG_LOOP1':     6 ,\
              'LOG_LOOP2':     7 ,\
              'LOG_LOOP3':     8 ,\
              'LOG_LOOP4':     9 ,\
              'LOG_LOOP5':     10 ,\
              'LOG_LOOP6':     11 ,\
              'LOG_MAX':       11 ,\
              'LOG_DEFAULT':   5 \
            }

class Context:
    """The Context class holds all of the information necessary
    to nest substeps.
    """

    def __init__(self):
        self.logfile=""
        self.logindent=0
        self.logappend=0
        self.tolerance="low"
        self.loglevel=loglevels['LOG_DEFAULT']
        self.logport=sys.stdout
        self.stepname=""
        self.logprefix=""
        self.begintime=int(time.time())
        self.techns=None
        self.tech={}

context=Context()
        
def logf(ll,msg):
    """Writes the message string [msg] to the logfile and appends
    a newline character.  If the the logfile has not been opened
    (with a call to logopen), then the message is printed to stdout.

    The message is printed only if the current log-level is greater
    than or equal to the level specified by [ll].  [ll] is a string
    that references one of the available log-levels.  See the
    sshaft.loglevels dictionary for the complete list of possibilities
    for the [ll] argument.
    """
    global context
    if (context.loglevel >= loglevels[ll]):
        context.logport.write(context.logprefix+msg+'\n')
    
def logopen():
    global context
    if (context.logfile!=""):
        try:
            context.logport=open(context.logfile,"a")
        except:
            dief("ERROR: sshaft.py: logopen: Cannot open "+context.logfile+" for writing: "+str(sys.exc_info()[0]))
    context.logprefix='\t'*context.logindent
    
def logclose():
    global context
    if (context.logfile!=""):
        context.logport.close()

def timef(sec):
    hrs=sec/3600
    sec=sec%3600
    min=sec/60
    sec=sec%60
    return str(hrs)+"h "+str(min)+"m "+str(sec)+"s"

def beginstep(name,args=None):
    global context
    context.stepname=name
    if (args):
        for key in args.keys():
            if (key=='log'):
                context.logfile=args['log']
            elif (key=='ll'):
                context.loglevel=args['ll']
            elif (key=='li'):
                context.logindent=args['li']
            elif (key=='la'):
                context.logappend=args['la']
            elif (key=='tol'):
                context.tolerance=args['tol']
            else:
                logf('LOG_WARN',"WARNING: sshaft.py: beginstep: unrecognized argument: "+key)
    else:
        newargs=[]
        while (len(sys.argv)>0):
            arg=sys.argv[0]
            sys.argv=sys.argv[1:]
            if (arg=="-log"):
                context.logfile=sys.argv[0]
                sys.argv=sys.argv[1:]
            elif (arg=="-ll"):
                context.loglevel=int(sys.argv[0])
                sys.argv=sys.argv[1:]
            elif (arg=="-li"):
                context.logindent=int(sys.argv[0])
                sys.argv=sys.argv[1:]
            elif (arg=="-la"):
                context.logappend=1
            elif (arg=="-tol"):
                context.tolerance=sys.argv[0]
                sys.argv=sys.argv[1:]
            else:
                newargs.append(arg)
        sys.argv=newargs
    if (context.logfile and not context.logappend):
        try:
            context.logport=open(context.logfile,"w")
        except:
            dief("ERROR: sshaft.py: beginstep: Cannot open "+context.logfile+" for writing: "+str(sys.exc_info()[0]))
        context.logport.close()
    if (not context.logappend):
        # Add mytech.sshaft to the SSHAFT_TECHFILE variable, if it exists
        if os.access('techfile.sshaft',os.R_OK):
            if os.environ.has_key('SSHAFT_TECHFILE'):
                os.environ['SSHAFT_TECHFILE']=os.environ['SSHAFT_TECHFILE'] \
                +':'+os.getcwd()+'/techfile.sshaft'
            else:
                os.environ['SSHAFT_TECHFILE']=os.getcwd()+'/'+techfile.sshaft
    context.begintime=int(time.time())
    logopen()
    logf('LOG_ENTRYEXIT',"Begin "+context.stepname)

def endstep():
    global context
    endtime=int(time.time())
    logf('LOG_ENTRYEXIT',"Finished "+context.stepname+" (elapsed time: " \
         +timef(endtime-context.begintime)+" actual)")
    logclose()

def dief(msg):
    global context
    endtime=int(time.time())
    logf('LOG_FERR',msg)
    logf('LOG_FERR',"Terminated "+context.stepname+" (elapsed time: " \
         +timef(endtime-context.begintime)+" actual)")
    raise Exception, msg

#def get_dir_prefix(rundir):

def substep(mode='py_step',cmd='', rundir='', env='', log='', logcheck='', \
            checkmode='', checkpoint='', deps=[], targs=[], tol=''):
    global context


    ##### Load the Environment ####
    m=re.search(r"^([a-z]+)_step$",mode)
    if m and m.group(1)!='unix' and m.group(1)!='py' :
        app=m.group(1)
        env=setup.Apps[app]['Environment']
    if env:
        tempenv={}
        for var in setup.Env[env]['NewEnvVars']:
            if os.environ.has_key(var):
                tempenv[var]=os.environ[var]
            os.environ[var]=setup.Env[env][var]
        for var in setup.Env[env]['AppendEnvVars']:
            if os.environ.has_key(var):
                tempenv[var]=os.environ[var]
            os.environ[var]=os.environ[var]+setup.Env[env][var]
        for var in setup.Env[env]['PrependEnvVars']:
            if os.environ.has_key(var):
                tempenv[var]=os.environ[var]
            os.environ[var]=setup.Env[env][var]+os.environ[var]

    ##### Check Dependencies ####
    # If any dependency is out of date with respect to any target,
    # then run the substep
    skip=True
    for targ in targs:
        for dep in deps:
            if out_of_date(dep,targ):
                skip=False
                break
        if not skip:
            break
    if len(deps)==0 or len(targs)==0:
        skip=False

    ##### Change the Working Directory #####
    if (context.logfile):
        logfile=context.logfile
    else:
        logfile=None
    if rundir:
        logf('LOG_DEBUG','Chdir '+rundir)
        errorflag=""
        try:
            os.chdir(rundir)
        except:
            errorflag=str(sys.exc_info()[0])
        if (errorflag):
            dief('ERROR: sshaft.py: substep: could not chdir to '+rundir+': '+str(errorflag))
        logdirs=dirlist(rundir)
        context.logfile=str(logdirs.here_to_there(logfile))

    ##### Execute the Step #####
    m=re.search(r"^([a-z]+)_step$",mode)
    if (mode=='py_step'):
	func=cmd[0]
	if (len(cmd)>1):
	    arglist=cmd[1]
	    if (type(arglist)!=list):
		dief("ERROR: sshaft.py: substep: Command argument list "+str(arglist)+" is not a list")
	else:
	    arglist=[]
	if (len(cmd)>2):
	    argdict=cmd[2]
	    if (type(argdict)!=dict):
		dief("ERROR: sshaft.py: substep: Command argument dict "+str(argdict)+" is not a dict")
	else:
	    argdict={}
        if (context.logfile):
            argdict['log']=context.logfile
            argdict['la']=1
        argdict['ll']=context.loglevel
        argdict['li']=context.logindent+1
        argdict['tol']=context.tolerance
        if skip:
            logf('LOG_DEBUG',"Targets up to date, skipping substep: "+func.__name__+" with arglist "+str(arglist)+" and argdict "+str(argdict))
        else:
            logf('LOG_DEBUG',"Executing: "+func.__name__+" with arglist "+str(arglist)+" and argdict "+str(argdict))
        logclose()
        tempcontext=context
        context=Context()
        errorflag=""
        retval=None
        try:
            if not skip:
                retval=func(*arglist,**argdict)
        except Exception, msg:
            errorflag=msg
        context=tempcontext
        logopen()
        if (errorflag):
            if (context.tolerance=="high"):
                logf('LOG_ERR',"ERROR: Substep did not run successfully: "+str(errorflag))
            else:
                dief("ERROR: Substep did not run successfully: "+str(errorflag))
        logf('LOG_DEBUG',"Step returned with value "+str(retval))
    elif (mode=='unix_step'):
        if (logfile):
            cmd=cmd+" -log "+logfile+" -la"
        cmd=cmd+" -ll "+str(context.loglevel)
        cmd=cmd+" -li "+str(context.logindent+1)
        cmd=cmd+" -tol "+context.tolerance
	#print cmd
        logf('LOG_DEBUG',"Executing: "+cmd)
        if skip:
            logf('LOG_DEBUG',"Targets up to date, skipping substep: "+cmd)
        else:
            logf('LOG_DEBUG',"Executing: "+cmd)
        logclose()
        errorflag=""
        retval=None
        try:
            if not skip:
                retval=os.system(cmd)
        except:
            errorflag=str(sys.exc_info()[0])
        logopen()
        if (errorflag or retval):
            if (context.tolerance=="high"):
                logf('LOG_ERR',"ERROR: Substep did not run successfully: "+str(errorflag))
            else:
                dief("ERROR: Substep did not run successfully: "+str(errorflag))
    elif (mode=='unix_prog'):
        m=re.search(r"([^>]+)(>\s*>?\s*&?\s*)(\S+)(.*)",cmd)
        if m:
            newcmd=m.group(1)
            capturemode=string.join(string.split(m.group(2)),'')
            logcapture=m.group(3)
            if len(capturemode)>=2 and capturemode[:2]=='>>':
                proglog=open(logcapture,"a")
            else:
                proglog=open(logcapture,"w")
        else:
            logcapture=''
        if skip:
            logf('LOG_DEBUG',"Targets up to date, skipping substep: "+cmd)
        else:
            logf('LOG_DEBUG',"Executing: "+cmd)
        logclose()
        errorflag=""
        retval=None
        try:
            if logcapture and not skip:
                if capturemode[len(capturemode)-1]=='&':
                    (stdin,stdout)=os.popen4(newcmd,'r')
                elif logcapture:
                    stdout=os.popen(newcmd,'r')
                    stdin=0
                for line in stdout:
                    proglog.write(line)
                proglog.close()
                retval=stdout.close()
                if stdin:
                    stdin.close()
            elif not skip:
                retval=os.system(cmd)
        except:
            errorflag=str(sys.exc_info()[0])
        logopen()
        if (errorflag or retval):
            if (context.tolerance=="high"):
                logf('LOG_ERR',"ERROR: Substep did not run successfully: "+str(errorflag))
            else:
                dief("ERROR: Substep did not run successfully: "+str(errorflag))
    elif app:
        logindent=context.logindent+1
        log=rundir+'/'+setup.Apps[app]['LogCheck']
        logcheck=setup.Apps[app]['LogCheckRegExp']
        checkmode=setup.Apps[app]['LogCheckMode']
        # Insert logging arguments
        regexp=setup.Apps[app]['CmdParseRegExp']
        m=re.search(regexp,cmd)
        if not m:
            dief('ERROR: sshaft.py: substep: Incorrectly formatted command string, should be parsed with regular expression '+regexp)
        cmdhdr=m.group(1)
        if (logfile):
            m=re.search(r"^([^%]*)%s([^%]*)%s([^%]*)%d([^%]*)%d([^%]*)%s(.*)$",setup.Apps[app]['CmdLogFormat'])
            if not m:
                dief('ERROR: sshaft.py: substep: Could not parse CmdLogFormat')
            #print cmd
	    if len(cmd)>9 and cmd[0:9]=="partition" or cmd[0:19]=="ncsu3dMakeLib3Tiers" or cmd[0:22]=="ncsu3dImportMergeViews":
	       cmd=cmd
	    else:
  	       cmd=m.group(1)+cmdhdr+m.group(2)+context.logfile+m.group(3)+str(context.loglevel)
               cmd=cmd+m.group(4)+str(logindent)+m.group(5)+context.tolerance+m.group(6)
	    #print cmd
        else:
            m=re.search(r"^([^%]*)%s([^%]*)%d([^%]*)%d([^%]*)%s(.*)$",setup.Apps[app]['CmdNoLogFormat'])
            if not m:
                dief('ERROR: sshaft.py: substep: Could not parse CmdNoLogFormat')
            cmd=m.group(1)+cmdhdr+m.group(2)+str(context.loglevel)
            cmd=cmd+m.group(3)+str(logindent)+m.group(4)+context.tolerance+m.group(5)
        f=open('exe.'+setup.Apps[app]['Language'],"w")
        src=open(setup.Apps[app]['TemplateDir']+'/'+setup.Apps[app]['ExeHeaderFile'],"r")
        for line in src:
            f.write(line)
        src.close()
        f.write(cmd+'\n')
        src=open(setup.Apps[app]['TemplateDir']+'/'+setup.Apps[app]['ExeFooterFile'],"r")
        for line in src:
            f.write(line)
        src.close()
        f.close()
        if skip:
            logf('LOG_DEBUG',"Targets up to date, skipping substep: "+cmd)
        else:
            logf('LOG_DEBUG',"Writing command to exe."+setup.Apps[app]['Language']+": "+cmd)
        cmd=setup.Apps[app]['ExecuteCommand']
        logcapture=setup.Apps[app]['LogCapture']
        proglog=open(logcapture,"w")
        if not skip:
            logf('LOG_DEBUG',"Executing: "+cmd)
        logclose()
        errorflag=""
        retval=None
        try:
            if not skip:
                (stdin,stdout)=os.popen4(cmd,'r')
                for line in stdout:
                    proglog.write(line)
                proglog.close()
                retval=stdout.close()
                stdin.close()
        except:
            errorflag=str(sys.exc_info()[0])
        logopen()
        if (errorflag or retval):
            if (context.tolerance=="high"):
                logf('LOG_ERR',"ERROR: Substep did not run successfully: "+str(errorflag))
            else:
                dief("ERROR: Substep did not run successfully: "+str(errorflag))
        logf('LOG_DEBUG',"Step returned with value "+str(retval))


    else:
        dief("ERROR: sshaft.py: substep: Unrecognized mode "+str(mode))

    ##### Change back to the root directory #####
    if rundir:
        backdir=str(logdirs.here_to_there('.'))
        logf('LOG_DEBUG','Chdir '+backdir)
        errorflag=""
        try:
            os.chdir(backdir)
        except:
            errorflag=str(sys.exc_info()[0])
        if (errorflag):
            dief('ERROR: sshaft.py: substep: could not chdir to '+backdir+': '+str(errorflag))
        context.logfile=logfile

    ##### Restore the Environment ####
    if env:
        for var in setup.Env[env]['NewEnvVars']:
            del os.environ[var]
        for var in setup.Env[env]['AppendEnvVars']:
            del os.environ[var]
        for var in setup.Env[env]['PrependEnvVars']:
            del os.environ[var]
        for var in tempenv.keys():
            os.environ[var]=tempenv[var]


    ##### Check the Log File for errors #####
    if not check_logfile(log, logcheck, checkmode):
        if tol=='high':
            logf('LOG_ERR','ERROR: Substep did not run successfully')
        else:
            dief('ERROR: Substep did not run successfully')
    elif checkpoint:
        # The check-point file can be used for dependency checking
        f=open(checkpoint,"w")
        f.close()


def check_logfile(log, logcheck, checkmode):
    check=False

    if not logcheck:
        return True

    if os.access(log,os.R_OK):
        f=open(log,"r")
        for line in f:
            m=re.search(logcheck,line)
            if m:
                check=True
                break
        f.close()

    if checkmode=='fail' and check:
        logf('LOG_ERR','ERROR: Expression "'+logcheck+'" matched in file '+log)
        return False
    elif checkmode!='fail' and not check:
        logf('LOG_ERR','ERROR: Expression "'+logcheck+'" did not match in file '+log)
        return False
    else:
        return True
        
        

def verify_dir(dirname):
    dir=dirlist(dirname)
    dir.verify()



def copy_file(srcname,destname):

    try:
        src=open(srcname,"r")
    except:
        dief("ERROR: sshaft.py: copy_file: Cannot open "+srcname+" for reading: "+str(sys.exc_info()[0]))
    try:
        dest=open(destname,"w")
    except:
        dief("ERROR: sshaft.py: copy_file: Cannot open "+destname+" for writing: "+str(sys.exc_info()[0]))
    for line in src:
        dest.write(line)
    src.close()
    dest.close()


def dir_init(dirname,mode):
    verify_dir(dirname)
    srcdir=setup.Apps[mode]['TemplateDir']
    srcfiles=setup.Apps[mode]['InitSrcFiles']
    destfiles=setup.Apps[mode]['InitDestFiles']
    #print srcdir
    #print srcfiles
    #print destfiles
    for i in range(len(srcfiles)):
        srcfile=srcdir+'/'+srcfiles[i]
        destfile=dirname+'/'+destfiles[i]
        if not os.access(destfile,os.R_OK):
            logf('LOG_INFO','Creating '+destfile)
            copy_file(srcfile,destfile)
    files=os.listdir(srcdir)
    for each in files:
        if each[len(each)-6:len(each)]==".dctcl" or each[len(each)-3:len(each)]==".py" or each[len(each)-7:len(each)]==".ctstch" or each[len(each)-3:len(each)]==".pl" or each=="add_LL18_3D":
	   srcfile=srcdir+'/'+each
	   destfile=dirname+'/'+each
	   logf('LOG_INFO','Creating '+destfile)
	   copy_file(srcfile,destfile)
        elif each=="kmetis":
	   srcfile=srcdir+'/'+each
	   destfile=dirname+'/'+each
	   os.system('cp '+srcfile+' '+destfile)

class dirlist:
    def __init__(self,dirs=''):
        # Sets self.dirs to be a list of strings, each containing the
        # directory name (no slashes).  If the first character in the
        # directory name is a slash, then the first entry in self.dirs
        # will be an empty string ''.
        if type(dirs)==str:
            self.dirs=string.split(dirs,'/')
            # Get rid of leading blank, if 1st char is not slash
            if self.dirs[0]=='':
                if len(dirs)==0 or dirs[0]!='/':
                    self.dirs=self.dirs[1:]
            # Get rid of the trailing slash, if it exists
            if len(self.dirs)>0 and self.dirs[len(self.dirs)-1]=='':
                self.dirs.pop()
        elif type(dirs)==list:
            self.dirs=list(dirs)
        self.compress()

    def __str__(self):
        return string.join(self.dirs,'/')

    def __add__(self,adddir):
        if type(adddir)==str:
            adddir=dirlist(adddir)
            newdir=dirlist(self.dirs+adddir.dirs)
        elif type(adddir)==list:
            newdir=dirlist(self.dirs+adddir)
        elif isinstance(adddir,dirlist):
            newdir=dirlist(self.dirs+adddir.dirs)
        else:
            raise TypeError, str(type(adddir))+" is not one of the expected types (dirlist, str, or list)"
        return newdir

    def pop(self,num=1):
        if len(self.dirs)>=num or (self.dirs[0]=='' and len(self.dirs)>=num+1):
            self.dirs=self.dirs[:(len(self.dirs)-num)]
            return True
        else:
            return False


    def absolute(self):
        if len(self.dirs)>0 and self.dirs[0]=='':
            return True
        else:
            return False

    def compress(self):
        newdirlist=[]
        for d in self.dirs:
            if d=='..':
                if len(newdirlist)==0:
                    newdirlist.append('..')
                elif newdirlist[0]=='..':
                    newdirlist.append('..')
                elif newdirlist[0]=='':
                    raise Exception, "No way to chdir to .. from /"
                else:
                    newdirlist.pop()
            else:
                if d!='.':
                    newdirlist.append(d)
        self.dirs=newdirlist

    def verify(self):
        for i in range(1,len(self.dirs)+1):
            if i==1 and self.dirs[0]=='':
                continue
            if not os.access(string.join(self.dirs[:i],'/'),os.R_OK):
                os.mkdir(string.join(self.dirs[:i],'/'))
            

    def get_dir_prefix(self,rundir):
        # Returns a dirlist instance which gives a path to the directory
        # specified by this instance when currently in the directory 
        # specified by the [rundir] argument.  For example:
        #
        # This directory      rundir        return value
        # /usr/local          X11/bin       ../..
        # /usr/local          X11/../bin    ..
        # /usr/local          /etc          /usr/local
        # run/cds             ..            cds
        # run/cds             ../dc         ../cds
        # run/cds             ../../..      (error - no way to know)
        # run/cds             /etc          (error - no way to know)
        if type(rundir)==str:
            rundir=dirlist(rundir)
        elif type(rundir)==list:
            rundir=dirlist(rundir)
        elif isinstance(rundir,dirlist):
            pass
        else:
            raise TypeError, str(type(rundir))+" is not one of the expected types (dirlist, str, or list)"
        if len(rundir.dirs)>0 and rundir.dirs[0]=='':
            if len(self.dirs)>0 and self.dirs[0]=='':
                return self
            else:
                raise Exception, "No way to get to "+str(self)+" from "+str(rundir)
        rundir.compress()
        if str(rundir)=='':
            return dirlist()
        prefix=[]
        workingdirs=list(self.dirs)
        dirs=[]
        for d in reversed(rundir.dirs):
            if d!='..':
                prefix.append('..')
            else:
                if len(workingdirs)==0:
                    raise Exception, "Directory "+str(rundir)+" nonexistent"
                dirs.append(workingdirs.pop())
        dirs=prefix+dirs
        return dirlist(dirs)

    def here_to_there(self,there):
        # Returns a dirlist instance which gives a path to the directory
        # specified by [there] from the directory specified by this instance.
        # For example:
        #
        # here                there         return value
        # run/cds             run/dc        ../dc
        # (none)              run/dc        run/dc
        # run/cds             (none)        ../..
        # /usr                /bin          ../bin
        # /usr                run/dc        (error - no way to know)
        # run/cds             /bin          /bin
        if type(there)==str:
            there=dirlist(there)
        elif type(there)==list:
            there=dirlist(there)
        elif isinstance(there,dirlist):
            pass
        else:
            raise TypeError, str(type(there))+" is not one of the expected types (dirlist, str, or list)"
        there.compress()
        if (self.absolute() and not there.absolute()):
            raise Exception, "No way to get to "+str(there)+" from "+str(self)
        if (there.absolute() and not self.absolute()):
            return there
        heredirs=list(self.dirs)
        theredirs=list(there.dirs)
        # Advance to point where directories diverge
        while len(heredirs)>0:
            if len(theredirs)==0:
                break
            else:
                if heredirs[0]!=theredirs[0]:
                    break
            if len(theredirs)>1:
                theredirs=theredirs[1:]
            else:
                theredirs.pop()
            if len(heredirs)>1:
                heredirs=heredirs[1:]
            else:
                heredirs.pop()
        pathdirs=[]
        for d in heredirs:
            pathdirs.append('..')        
        return dirlist(pathdirs+theredirs)

def out_of_date(dep,targ):
    if not os.access(targ,os.F_OK):
        return True
    if not os.access(dep,os.F_OK):
        raise Exception, "File "+dep+" does not exist"
    if os.stat(dep)[8]>os.stat(targ)[8]:
        return True
    else:
        return False

