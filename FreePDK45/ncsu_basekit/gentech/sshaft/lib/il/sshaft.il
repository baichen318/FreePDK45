; Copyright (c) 2001, Regents of the University of California.
;
; See the file "License.terms" for information on usage and redistribution
; of this file, and for a DISCLAIMER OF ALL WARRANTIES.


; Steps:
; Read Variables:          logfile loglevel logindent tolerance
; Used Variables:          logport logprefix stepname begintime
; 

; Generators:
; Read Variables:          srclib srccell srcview destlib destcell destview
; Used Variables:          cdb

; Traversals:
; Used Variables:          travlist

LOG_MIN =	0
LOG_FERR = 	0
LOG_ERR =	1
LOG_WARN =	2
LOG_INFO =	3
LOG_ENTRYEXIT =	4
LOG_DEBUG =	5
LOG_LOOP1 = 	6
LOG_LOOP2 =	7
LOG_LOOP3 = 	8
LOG_LOOP4 = 	9
LOG_LOOP5 = 	10
LOG_LOOP6 =	11
LOG_MAX =	11

LOG_DEFAULT = 	LOG_DEBUG

procedure( logf( level format @rest args )
  let( (logfile loglevel)
    if( boundp( 'stepargs ) then
      logfile=car(stepargs)
      loglevel=cadr(stepargs)
    ) ;if
    if( !numberp( loglevel ) then
      loglevel=LOG_DEFAULT
    ) ;if
    if( !boundp( 'logprefix ) then
      logprefix=""
    ) ;if  

    if( (loglevel >= level) then
      format = strcat( logprefix format "\n" )
      args = cons( format args )
      apply( 'printf args )
      if( logfile then
        args = cons( logport args )
        apply( 'fprintf args )
      ) ;if
    ) ;if
  ) ;let
) ;procedure


procedure( logopen()
  prog( (logfile logappend loglevel logindent i)
    if( boundp( 'stepargs ) then
      logfile=car(stepargs)
      logappend=cadr(stepargs)
      loglevel=caddr(stepargs)
      logindent=cadddr(stepargs)
    ) ;if
    if( !numberp( loglevel ) then
      loglevel=LOG_DEFAULT
    ) ;if
    if( !numberp( logindent ) then
      logindent=0
    ) ;if

    if( logfile then
      if( logappend then
        logport = outfile( logfile "a" )
      else
        logport = outfile( logfile "w" )
      ) ;if
      if( (!logport) then
        printf( "ERROR: could not open logfile %s\n" logfile )
        return( nil )
      ) ;if
    ) ;if

    logprefix = ""
    for( i 1 logindent 
      logprefix = strcat( "\t" logprefix)
    ) ;for
    return( t )
  ) ;prog
) ;procedure


procedure( logclose()
  let( (logfile)
    if( boundp( 'stepargs ) then
      logfile=car(stepargs)
    ) ;if

    if( logfile then close( logport ))
    logport=nil
  ) ;let
) ;procedure


procedure( timef( sec )
  prog( (hrs min)
    hrs=sec/3600
    sec=sec-(hrs*3600)
    min=sec/60
    sec=sec-(min*60)
    return( sprintf( nil "%dh %dm %ds" hrs min sec ))
  ) ;prog
) ;procedure timef



procedure( beginstep( name )
  logopen()
  
  if( !stringp( name ) then
    logf(LOG_WARN "WARNING: beginstep: step name %L is not a string" name)
    stepname="Unknown"
  else
    stepname=name
  ) ;if

  begintime=getCurrentTime()
  logf(LOG_ENTRYEXIT "Begin %s" stepname)
) ;procedure beginstep


procedure( endstep( )
  prog( (endtime elapsedtime)
    endtime=getCurrentTime()
    elapsedtime=compareTime( endtime begintime )
    logf(LOG_ENTRYEXIT "Finished %s (elapsed time: %s actual)" stepname 
            timef( elapsedtime ))
  ) ;prog
  logclose()
  return( t )
) ;procedure endstep


procedure( dief( @rest args )
  prog( (endtime elapsedtime)
    args=cons( 0 args )
    apply( 'logf args )
    endtime=getCurrentTime()
    elapsedtime=compareTime( endtime begintime )
    logf(LOG_FERR "Terminated %s (elapsed time: %s actual)" stepname 
            timef( elapsedtime ))
  ) ;prog
  logclose()
  return( nil )
) ;procedure dief


procedure( get_dir_prefix( rundir )
  prog( (workingdirs dir dirlist prefix newdirlist)
    if( !stringp( rundir ) then
      return( nil )
    ) ;if

    if( 0==strncmp( "/" rundir 1 ) then
      ; Handle absolute path
      return( getWorkingDir()  )
    else
      dirlist=parseString(rundir "/")
      foreach( dir dirlist
        if( dir==".." then
          if( !car(newdirlist) || car(newdirlist) == ".." then
            newdirlist=cons( ".." newdirlist)
          else
            newdirlist=cdr(newdirlist)
          ) ;if
        else
          if( dir != "." then
            newdirlist=cons( dir newdirlist )
          ) ;if
        ) ;if
      ) ;foreach
      if( length(newdirlist) == 0 then
        return( "" )
      ) ;if
      workingdirs=reverse( parseString( getWorkingDir() "/" ))
      dirlist=nil
      prefix=nil
      foreach( dir newdirlist
        if( dir != ".." then
          prefix=cons( ".." prefix )
        else
          if( length( workingdirs ) == 0 then
            logf(LOG_ERR "ERROR: sshaft.il: get_dir_prefix: Directory %L nonexistent" rundir)
            return(nil)
          ) ;if
          dirlist=cons( car(workingdirs) dirlist )
          workingdirs=cdr(workingdirs)
        ) ;if
      ) ;foreach
    ) ;if
    dirlist=append( prefix dirlist )
    prefix = buildString( dirlist "/" )
    return(prefix )
  ) ;prog
) ;procedure get_dir_prefix
    

procedure( substep( @key (mode 'skill_step) (cmd nil) (rundir nil)
                    (log nil) (logcheck nil) (checkmode nil)
                    (deps nil) (targs nil) (tol nil)
                    (src nil) (dest nil))
  let( (logfile loglevel logindent tolerance newargs retval skillpath 
        dirprefix oldlogfile continue files file fileage objpath)
    if( boundp( 'stepargs ) then
      logfile=car(stepargs)
      loglevel=cadr(stepargs)
      logindent=caddr(stepargs)
      tolerance=cadddr(stepargs)
    ) ;if
    if( !numberp( loglevel ) then
      loglevel=LOG_DEFAULT
    ) ;if
    if( !numberp( logindent ) then
      logindent=0
    ) ;if
    if( !stringp( tolerance ) then
      tolerance="low"
    ) ;if

    ; Check Dependencies
    ; If any dependency is younger than any target, 
    ;      then run the substep.
    continue=prog( (targ dep agedep agetarg ddid)
      foreach( targ targs
  
        ; Find age of target
        if( stringp(targ) then
          agetarg=fileTimeModified(targ)
          if( agetarg then
            agetarg=tmieToString(agetarg)
          else
            ; Target does not exist, substep must run
            ;logf(LOG_DEBUG "Could not find %L" targ)
            return(t)
          ) ;if
        else
          if( listp(targ) then
            ddid=ddGetObj(car(targ) cadr(targ) caddr(targ))
            if( !ddid then
              ; Target does not exist, substep must run
              logf(LOG_DEBUG "Could not find %L" targ)
              return(t)
            ) ;if
            objpath=ddGetObjReadPath(ddid)
            files=ddGetObjFiles(ddid)
            file=car(files)
            agetarg=timeToString(fileTimeModified(
                                    strcat( objpath "/" file~>name)))
            if( length(files)>1 then
              foreach( file cdr(files)
                fileage=timeToString(fileTimeModified(
                                        strcat( objpath "/" file~>name)))
                if( compareTime(agetarg fileage) < 0
                  agetarg=fileage
                ) ;if
              ) ;foreach
            ) ;if
          else
            dief( "ERROR: unrecognized target %L" targ)
          ) ;if
        ) ;if

        foreach( dep deps
          ; Find age of dependency
          if( stringp(dep) then
            agedep=tmieToString(fileTimeModified(dep))
            if( agedep then
              agedep=tmieToString(agedep)
            else
              logf(LOG_ERR "ERROR: Could not find %L to determine age" dep)
              return("Error")
            ) ;if
          else
            if( listp(dep) then
              ddid=ddGetObj(car(dep) cadr(dep) caddr(dep))
              if( !ddid then
                logf(LOG_ERR "ERROR: Could not find %L to determine age" dep)
                return("Error")
              ) ;if
              objpath=ddGetObjReadPath(ddid)
              files=ddGetObjFiles(ddid)
              file=car(files)
              agedep=timeToString(fileTimeModified(
                                      strcat( objpath "/" file~>name)))
              if( length(files)>1 then
                foreach( file cdr(files)
                  fileage=timeToString(fileTimeModified(
                                          strcat( objpath "/" file~>name)))
                  if( compareTime(agedep fileage) < 0
                    agedep=fileage
                  ) ;if
                ) ;foreach
              ) ;if
            else
              logf(LOG_ERR "ERROR: unrecognized dependency %L" dep)
              return("Error")
            ) ;if
          ) ;if

          if( compareTime(agedep agetarg) > 0 then
            ; Target is older than dependency, substep must run
            logf(LOG_DEBUG "%L is older than %L" targ dep)
            return(t)
          ) ;if
        ) ;foreach
      ) ;foreach
      return(nil)
    ) ;prog
    if( length(deps)==0 || length(targs)==0 then
      continue=t
    ) ;if

    if( continue=="Error" then
      dief("ERROR: Could not process dependencies")
    else
      if( !continue && check_logfile(log logcheck checkmode) then
        logf(LOG_INFO "Target(s) up-to-date: Skipping substep")
      else


        ; Change working directory
        if( rundir then
          if( !stringp(rundir) then
            dief( "ERROR: sshaft.il: substep: Run directory %L is not a string"
                  rundir)
          ) ;if
          oldlogfile=logfile
          dirprefix=get_dir_prefix(rundir)
          if( logfile && 00!=strncmp("/" logfile 1) then
            logfile=strcat(dirprefix "/" logfile )
            if( boundp( 'stepargs ) then
              stepargs=list( logfile loglevel logindent tolerance )
            ) ;if
          ) ;if
          logf(LOG_DEBUG "Chdir %L" rundir)
          if( !changeWorkingDir( rundir ) then
            dief("ERROR: sshaft.il: substep: Could not chdir to %L" rundir)
          ) ;if
        ) ;if

        ; Set up tolerance
        if( !tol then
          tol=tolerance
        ) ;if
        if( ( tol != "high" && tol != "low" ) then
          dief("ERROR: sshaft.il: substep: Unrecognized tolerance value: %L (should be low or high)" tol )
        ) ;if

        ; Execute the step
        cond(
          ( mode == 'unix_step
            if( !stringp( cmd ) then
              dief( "ERROR: sshaft.il: substep: UNIX Command %L is not a string"
                     cmd )
            ) ;if
            if( stringp(logfile) then
              sprintf(cmd "%s -log -la %s" cmd logfile)
            ) ;if
            sprintf(cmd "%s -ll %d -li %d -tol %s" cmd loglevel logindent tol)
            logf(LOG_DEBUG "Executing: %s" cmd)
            logclose()
            retval=system(cmd)
            logopen()
            if( retval!=0 then
              if( tol == "high" then
                logf(LOG_ERR "ERROR: substep did not run successfully")
              else
                dief("ERROR: substep did not run successfully")
              ) ;if
            ) ;if
          )
          ( mode == 'unix_prog
            if( !stringp( cmd ) then
              dief( "ERROR: sshaft.il: substep: UNIX Command %L is not a string"
                     cmd )
            ) ;if
            logf(LOG_DEBUG "Executing: %s" cmd)
            logclose()
            retval=system(cmd)
            logopen()
            logf(LOG_DEBUG "Program returned with value %L" retval)  
          )
          ( mode == 'skill_step
            newargs = list( ?stepargs list( 'list logfile t loglevel logindent+1 tol))
            if( src then
              newargs=append( newargs list( ?src append( list( 'list ) src )))
            ) ;if
            if( dest then
              newargs=append( newargs list( ?dest append( list( 'list) dest )))
            ) ;if
            cmd = append( cmd newargs )
            logf(LOG_DEBUG "Executing: %L" cmd )
            logclose()
            let( (logport logprefix stepname begintime cdb )
              retval=eval( cmd )
            ) ;let
            logopen()
            logf(LOG_DEBUG "Step returned with value %L" retval )
            if( !retval then
              if( tol == "high" then
                logf(LOG_ERR "ERROR: Substep did not run successfully")
              else
                dief("ERROR: Substep did not run successfully")
              ) ;if
            ) ;if
          )
          ( mode == 'skill_proc
            logf( LOG_DEBUG "Executing: %L" cmd)
            let( (logport logprefix stepname begintime cdb )
              retval=eval( cmd )
            ) ;let
            logf( LOG_DEBUG "Procedure returned with value %L" retval )
          )
          ( t
            dief("ERROR: sshaft.il: substep: Unrecognized mode %L" mode)
          )
        ) ;cond

        ; Change back to the root directory
        if( rundir then
          logf(LOG_DEBUG "Chdir %L" dirprefix)
          if( !changeWorkingDir( dirprefix ) then
            dief("ERROR: sshaft.il: substep: Could not chdir to root directory")
          ) ;if
          logfile=oldlogfile
          if( boundp( 'stepargs ) then
            stepargs=list( logfile loglevel logindent tolerance )
          ) ;if
        ) ;if
        
        ; Check Logflie
        if( !check_logfile(log logcheck checkmode retval) then
          if( tol == "high" then
            logf(LOG_ERR "ERROR: substep did not run successfully")
          else
            dief("ERROR: substep did not run successfully")
          ) ;if
        ) ;if
      ) ;if
    ) ;if
  ) ;let
) ;procedure substep


procedure( begingen( name )
  beginstep( name )
  let( (srclib srccell srcview)
    if( boundp( 'src ) then
      srclib=car(src)
      srccell=cadr(src)
      srcview=caddr(src)
    ) ;if

    if( !srclib || !srccell || !srcview then
      cdb=geGetEditCellView( getCurrentWindow())
    else
      cdb=dbOpenCellViewByType( srclib srccell srcview nil "a" )
    ) ;if

    if( !cdb then
      dief( "ERROR: sshaft.il: begingen: could not open source cell in append mode" )
    ) ;if
  ) ;let
) ;procedure begingen


procedure( endgen( @optional (save t) )
  if( save then
    let( (destlib destcell destview)
      if( boundp( 'dest ) then
        destlib=car(dest)
        destcell=cadr(dest)
        destview=caddr(dest)
      ) ;if

      if( !destlib then
        destlib=cdb~>libName
      ) ;if
      if( !destcell then
        destcell=cdb~>cellName
      ) ;if
      if( !destview then
        destview=cdb~>viewName
      ) ;if
      if( !dbSave( cdb destlib destcell destview) then
        dief("ERROR: Could not save cell view as %L %L %L" 
               destlib destcell destview )
      ) ;if
    ) ;let
  ) ;if

  if( boundp( 'src ) then
    if( src then
      ; Must reopen cellview in scratch mode to ensure that
      ; changes are discarded when icfb exits.
      dbReopen(cdb "s")
      dbClose(cdb)
    ) ;if
  ) ;if
  endstep()
) ;procedure endgen


procedure( traverse( @key (libname nil) (cellname nil) (viewname nil)
                          (pregen nil) (postgen nil) 
                          (stopcond nil) (travcond nil) )
  prog( (travlist cdb retval)

    if( !libname || !cellname || !viewname then
      cdb=geGetEditCellView( getCurrentWindow())
    else
      cdb=dbOpenCellViewByType( libname cellname viewname nil "r" )
    ) ;if

    if( !cdb then
      logf(LOG_ERR "ERROR: could not open source cell in read mode" )
      return( nil )
    ) ;if

    retval=traverse_check( cdb )

    if( libname && cellname && viewname then
      dbClose(cdb)
    ) ;if
    return( retval )
  ) ;prog
) ;procedure traverse


procedure( traverse_check( cdb )
  prog( (hdr travhdrs newcmd newargs)


    ; Return if already visited, otherwise add to travlist
    if( visited() then
      return( t )
    else
      visit()
    ) ;if

    ; Return if stopcond evaluates to true
    if( ( listp( stopcond ) && ( length(stopcond) > 0 ) ) then
      logf(LOG_LOOP2 "Evaluating: %L" stopcond )
      if( eval( stopcond ) then
        logf(LOG_LOOP3 
             "Stopping at %L %L %L" cdb~>libName cdb~>cellName cdb~>viewName)
        return( t )
      ) ;if
    ) ;if

    logf(LOG_LOOP1 "Traversing %L %L %L" cdb~>libName cdb~>cellName cdb~>viewName)

    ; Add to travlist

    ; Execute pregen
    if( pregen then
      newargs = list( ?src list( 'list cdb~>libName 
                                  cdb~>cellName cdb~>viewName ))
      newcmd = append( pregen newargs )
      substep( ?mode 'skill_step ?cmd newcmd )
    ) ;if

    ; If travcond evaluates to true, traverse instances
    if( ( listp( travcond ) && ( length(travcond) > 0 ) ) then
      logf(LOG_LOOP2 "Evaluating: %L" travcond )
      travhdrs=eval( travcond )
    else
      travhdrs=t
    ) ;if

    if( travhdrs then
      foreach( hdr cdb~>instHeaders
        if( !traverse_check( hdr~>master ) then
          return( nil )
        ) ;if
      ) ;foreach
    ) ;if

    ; Execute postgen
    if( postgen then
      newargs = list( ?src list( 'list cdb~>libName 
                                  cdb~>cellName cdb~>viewName ))
      newcmd = append( postgen newargs )
      substep( ?mode 'skill_step ?cmd newcmd )
    ) ;if

    ; Return
    return( t )
  ) ;prog
) ;procedure traverse_check


procedure( visited()
  prog( (entry found)
    if( !boundp( 'travlist ) then
      logf(LOG_ERR "ERROR: sshaft.il: visited: travlist not found")
      return( nil )
    ) ;if
    if( !boundp( 'cdb ) then
      logf(LOG_ERR "ERROR: sshaft.il: visited: cdb not found")
      return( nil )
    ) ;if

    foreach( entry travlist
      if( (car(entry) == cdb~>libName && cadr(entry) == cdb~>cellName
          && caddr(entry) == cdb~>viewName) then
        return(t)
      ) ;if
    ) ;foreach
    return(nil)
  ) ;prog
) ;procedure visited


procedure( visit()
  prog( ()
    if( !boundp( 'travlist ) then
      logf(LOG_ERR "ERROR: sshaft.il: visit: travlist not found")
      return( nil )
    ) ;if
    if( !boundp( 'cdb ) then
      logf(LOG_ERR "ERROR: sshaft.il: visit: cdb not found")
      return( nil )
    ) ;if

    travlist=cons( list( cdb~>libName cdb~>cellName cdb~>viewName nil ) 
                   travlist )
    return( t )
  ) ;prog
) ;procedure visit


procedure( settravdata( data @optional (libname nil) (cellname nil) 
                                       (viewname nil))
  prog( (entry head tail)
    if( !boundp( 'travlist ) then
      logf(LOG_ERR "ERROR: sshaft.il: visited: travlist not found")
      return( nil )
    ) ;if
    if( !boundp( 'cdb ) then
      logf(LOG_ERR "ERROR: sshaft.il: visited: cdb not found")
      return( nil )
    ) ;if

    if( !libname || !cellname || !viewname then
      libname=cdb~>libName
      cellname=cdb~>cellName
      viewname=cdb~>viewName
    ) ;if

    head=nil
    tail=travlist
    foreach( entry travlist
      if( car(entry) == libname && cadr(entry) == cellname
          && caddr(entry) == viewname then
        travlist=append(head cons( 
                   list( cdb~>libName cdb~>cellName cdb~>viewName data) 
                   cdr(tail)))
        return(t)
      ) ;if
      head=cons(entry head)
      tail=cdr(tail)
    ) ;foreach
    return(nil)
  ) ;prog
) ;procedure settravdata


procedure( gettravdata( @optional (libname nil) (cellname nil) (viewname nil))
  prog( (entry found)
    if( !boundp( 'travlist ) then
      logf(LOG_ERR "ERROR: sshaft.il: visited: travlist not found")
      return( nil )
    ) ;if
    if( !boundp( 'cdb ) then
      logf(LOG_ERR "ERROR: sshaft.il: visited: cdb not found")
      return( nil )
    ) ;if

    if( !libname || !cellname || !viewname then
      libname=cdb~>libName
      cellname=cdb~>cellName
      viewname=cdb~>viewName
    ) ;if

    foreach( entry travlist
      if( car(entry) == libname && cadr(entry) == cellname
          && caddr(entry) == viewname then
        return(nth(3 entry))
      ) ;if
    ) ;foreach
    return(nil)
  ) ;prog
) ;procedure gettravdata


procedure( listterm( @optional (cDb nil) )
  prog( (pin term)

    if( !cDb then
      cDb=geGetEditCellView( getCurrentWindow())
    )
    printf( "Terminals (Pins): \n")
    foreach( term cDb~>terminals
      printf( "%L: ( " term~>name )
      foreach( pin term~>pins
        printf( "%L " pin~>name )
      ) ;foreach
      printf( ")\n")
    ) ;foreach

    return( t)
  ) ;prog
) ;procedure listterm
 

procedure( listnet( @optional (cDb nil) )
  prog( (net iterm)

    if( !cDb then
      cDb=geGetEditCellView( getCurrentWindow())
    )
    printf( "Nets ([global] sigType): { [terminal] inst[instTerm] ... }: \n")
    foreach( net cDb~>nets
      if( car(net~>signals)~>isGlobal then
        printf( "%L (global %L): { " net~>name car(net~>signals)~>sigType)
      else
        printf( "%L (%L): { " net~>name car(net~>signals)~>sigType )
      ) ;if
      if( net~>term then
        printf( "[%L] " net~>term~>name )
      ) ;if
      foreach( iterm net~>instTerms
        printf( "%L[%L] " iterm~>inst~>name iterm~>name )
      ) ;foreach
      printf( "}\n")
    ) ;foreach

    return( t)
  ) ;prog
) ;procedure listnet


procedure( listinst( @optional (cDb nil) )
  (prog (inst hdr shrec celllist)

    if( !cDb then
      cDb=geGetEditCellView( getCurrentWindow())
    )
    printf( "libName cellName viewName (instNames): \n")
    foreach( hdr cDb~>instHeaders
      printf( "%L %L %L: ( " hdr~>libName hdr~>cellName hdr~>viewName )
      foreach( inst hdr~>instances
        printf( "%L " inst~>name )
      ) ;foreach
      printf( ")\n")
    ) ;foreach

    return( t)
  ) ;prog
) ;procedure listinst


procedure( listnetexpr( @optional (cDb nil) )
  (prog (sig)

    if( !cDb then
      cDb=geGetEditCellView( getCurrentWindow())
    )

    printf( "Signal ([global] sigType): Net Expression: \n")
    foreach( sig dbGetCellViewInheritedSig(cDb)
      if( sig~>isGlobal then
        printf( "%L (global %L): %L\n" sig~>name sig~>sigType 
               dbGetSigNetExpr(sig))
      else
        printf( "%L (%L): %L\n" sig~>name sig~>sigType 
               dbGetSigNetExpr(sig))
      ) ;if
    ) ;foreach

    return( t)
  ) ;prog
) ;procedure listnetexpr


procedure( check_logfile( log logcheck checkmode @optional (retval nil))
  prog( (check proglogport)

    if( !logcheck then
      return( t )
    ) ;if

    if( stringp(log) && stringp(logcheck) then
      proglogport=infile(log)
      if( !proglogport then
        logf(LOG_ERR "ERROR: sshaft.il: check_logfile: Could not open %L for reading" log )
        return( nil )
      ) ;if
      prog( (line)
        while( gets(line proglogport)
          if( rexMatchp( logcheck line ) then
            check=t
            return()
          ) ;if
        ) ;while
      ) ;prog
      close(proglogport)
    else
      if( listp(logcheck) && length(logcheck) > 0 then
        if( retval == car(logcheck) then
          check=t
        ) ;if
      else
        if( logcheck && logcheck==retval then
          check=t
        ) ;if
      ) ;if
    ) ;if

    if( (checkmode == "fail" && check) || (checkmode != "fail" && !check) then
      return(nil)
    ) ;if
    return( t )
  ) ;prog
) ;procedure check_logfile


procedure( verify_dir( dirname )
  prog( (dir subdir dirs path)
    if( !stringp( dirname ) then
      logf(LOG_ERR "ERROR: sshaft.il: verify_dir: Directory %L is not a string"
           dirname)
      return(nil)
    ) ;if
    dir=""
    dirs=parseString(dirname "/")
    if( 0==strncmp(dirname "/" 1) then
      dir="/"
    ) ;if
    path=getSkillPath()
    setSkillPath(nil)
    foreach( subdir dirs
      dir=strcat(dir subdir)
      if( !isFileName( dir ) then
        if( !createDir( dir ) then
          logf(LOG_ERR 
             "ERROR: sshaft.il: verify_dir: Could not create directory %L" dir)
          return(nil)
        ) ;if
      else
        if( !isDir( dir ) then
          logf(LOG_ERR 
               "ERROR: sshaft.il: verify_dir %L exists and is not a directory" 
               dir )
          return(nil)
        ) ;if
      ) ;if
      dir=strcat(dir "/")
    ) ;foreach
    setSkillPath(path)
    return(t)
  ) ;prog
) ;procedure verify_dir


procedure( gettechvar( var )
  prog( (val)
    if( !plist( 'TECH ) then
      read_techfile()
    ) ;if
    if( stringp( var ) then
      var=stringToSymbol( var )
    else
      if( !symbolp( var ) then
        logf(LOG_ERR "ERROR: sshaft.il: gettechvar: argument %L is not of type symbol or string" var )
        return( nil )
      ) ;if
    ) ;if
    val=get( 'TECH var )
    if( !val then
      val=getShellEnvVar(symbolToString(var))
    ) ;if
    if( !stringp( val ) then
      logf(LOG_ERR "ERROR: sshaft.il: gettechvar: variable %L not defined in techfile\nRun loadtech from UNIX command line to debug techfile" var )
      return( nil )
    ) ;if
    return( val )
  ) ;prog
) ;procedure gettechvar


procedure( dumptech()
  logf(LOG_ERR "Technology Info:")
  if( boundp( 'logport) then
    pprint( plist('TECH) logport )
  else
    pprint( plist('TECH))
  ) ;if
) ;procedure dumptech

procedure( read_techfile()
  prog( (cid lines)
    cid = ipcBeginProcess("loadtech")
    vars=nil
    ; ipcReadProcess does not necessarily read all of the lines,
    ; so we must repeatedly call it until the entire techfile is read
    while( lines = ipcReadProcess(cid 5)
      lines = parseString( lines "\n")
      ;logf(LOG_DEBUG "Read %L lines" length(lines))
      if( vars then
        lines=cons(car(vars) lines)
      ) ;if
      while( cadr(lines)
        putprop( 'TECH cadr(lines) stringToSymbol(car(lines)) )
        lines=cddr(lines)
      ) ;while
      vars=lines
    ) ;while
    return(t)
  ) ;prog
) ;procedure read_techfile

procedure( read_techfile_old()
  prog( (techfilename techport line newline temp)
    techfilename=getShellEnvVar("SSHAFT_TECHFILE")
    techport=infile(techfilename)
    if( !techport then
      logf(LOG_ERR "ERROR: sshaft.il: read_techfile: Cannot open %L (techfile) for reading!" techfilename )
      return( nil )
    ) ;if
    while( gets(newline techport)
      ;logf( 1 "Processing line: %L" newline)
      newline=strip_leading_whitespace( newline )
      newline=strip_trailing_whitespace( newline )
      ;logf(0 "Check 1")
      if( newline && 0!=strncmp( "#" newline 1) then
        if( 0==strncmp( "+" newline 1) then
          newline=strip_leading_whitespace(substring(newline 2))
          if( !newline then
            newline=""
          ) ;if
          line=strcat(line " " newline)
        else
          ;logf(0 "Check 2")
          process_techline()
          ;logf(0 "Check 3")
          line=newline
        ) ;if 
      ) ;if
    ) ;while
    process_techline()
    close(techport)
    return( t)
  ) ;prog
) ;procedure read_techfile_old

procedure( process_techline()
  prog( (temp var val)
    ;logf(0 "Check 1")
    if( !boundp( 'line ) then
      return()
    ) ;if
    ;logf(0 "Check 2")
    line=expand_techvar(line)
    ;logf(0 "Check 3")
    if( line then
      temp=parseString(line "=")
      var=stringToSymbol(car(parseString(car(temp))))
      val=strip_leading_whitespace(strip_trailing_whitespace(cadr(temp)))
      ;logf(1 "Adding %L = %L" var val)
      if( getShellEnvVar(symbolToString(var)) then
        putprop( 'TECH getShellEnvVar(symbolToString(var)) var)
      else
        putprop( 'TECH val var )
      ) ;if
    ) ;if
  ) ;prog
) ;procedure process_techline

procedure( strip_leading_whitespace( line )
  prog( ()
    if( !stringp( line ) then
      return( line )
    ) ;if
    while( line && (0==strncmp( " " line 1) || 0==strncmp( "\t" line 1) 
           || 0==strncmp( "\n" line 1))
      line=substring(line 2)
    ) ;while
    return( line )
  ) ;prog
) ;procedure strip_leading_whitespace

procedure( strip_trailing_whitespace( line )
  prog( (len tail)
    if( !stringp( line ) then
      return( line )
    ) ;if
    len=strlen(line)
    tail=substring(line len)
    while( 0==strncmp( " " tail 1) || 0==strncmp( "\t" tail 1) 
           || 0==strncmp( "\n" tail 1)
      len--
      if( len==0 then
        return( nil )
      ) ;if
      tail=substring(line len)
    ) ;while
      return( substring(line 1 len))
  ) ;prog
) ;procedure strip_trailing_whitespace

procedure( contains_substring(str substr)
  prog( (str1len substrlen pos)
    if( !stringp(str) || !stringp(substr) then
      return( nil )
    ) ;if
    str1len=strlen(str)
    substrlen=strlen(substr)
    pos=0
    while( pos <= str1len-substrlen
      if( 0==strncmp( str substr substrlen) then
        return( t )
      ) ;if
      str=substring( str 2 )
      pos++
    ) ;while
    return( nil )
  ) ;prog
) ;contains substring

procedure( expand_techvar( line )
  ; This has got to be the grossest piece of code I have ever written.
  ; Remind me never to try Perl-style variable expansion in lisp ever again.
  prog( ( headlen beginvar tail varlen brace varname temp pos val)
    if( !stringp(line) then
      return( line )
    ) ;if
    ; Advance to the $ character
    ;logf(0 "Check 1")
    tail=line
    pos=0
    while( 0!=strncmp(tail "$" 1)
      tail=substring(tail 2)
      pos++
      if( !tail then
        return( line )
      ) ;if
    ) ;while
    headlen=pos
    ; Skip the $
    ;logf(0 "Check 2")
    tail=substring(tail 2)
    pos++
    if( !tail then
      return( line )
    ) ;if
    ; Check to see if there is a brace
    ;logf(0 "Check 3")
    if( 0==strncmp(tail "{" 1) then
      brace=t
      tail=substring(tail 2)
      pos++
      if( !tail then
        return( line )
      ) ;if
      ; Skip whitespace
      while( 0==strncmp( tail " " 1) || 0==strncmp( tail "\t" 1) || 
             0==strncmp( tail "\n" 1)
        tail=substring(tail 2)
        pos++
        if( !tail then
          return( line )
        ) ;if
      ) ;while
    ) ; if
    ; Find the variable name
    ;logf(0 "Check 4")
    varlen=0
    while( !varname && varlen <= strlen(tail)
      if( !parseString( substring( tail 1 varlen )
           "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_")
           then
        varlen++
      else
        varname=substring( tail 1 varlen-1 )
      ) ;if
    ) ;while
    if( varlen > strlen(tail) then
      varname=tail
      tail=""
    else
      tail=substring( tail varlen)
    ) ;if
    pos=pos+varlen
    ; Check for a null varname
    ;logf(0 "Check 5")
    if( 0==strlen( varname ) then
      return( strcat( substring( line 1 pos-1 ) expand_techvar( tail )))
    ) ;if
    ; Check for a closing brace
    ;logf(0 "Check 6")
    if( brace then
      if( !contains_substring(tail "}") then
        return( strcat( substring( line 1 pos-1 ) expand_techvar( tail )))
      ) ;if
      ; Skip to brace character
      while( 0!=strncmp( tail "}" 1)
        tail=substring(tail 2)
        pos++
        if( !tail then
          return( line )
        ) ;if
      ) ;while
      ; Skip the brace
      tail=substring(tail 2)
      pos++
    ) ;if
    if( !tail then
      tail = ""
    ) ;if
    ; Get the value of the variable
    ;logf(0 "Check 7")
    val=get( 'TECH stringToSymbol(varname) )
    if( !val then
      val=getShellEnvVar(varname)
      if( !val then
        dumptech()
        logf(LOG_ERR "ERROR: sshaft.il: expand_techvar: Attempt to dereference undefined macro %L in techfile, line %L" varname line)
        return( nil )
      ) ;if
    ) ;if

    ;logf(0 "Check 8")
    return( strcat( substring( line 1 headlen ) val expand_techvar(tail)) )
  ) ;prog
) ;procedure expand_techvar


procedure( copy_file(src dest)
  prog( (retval)
    retval=system( strcat( "cp " src " " dest))
    if( 0 != retval then
      logf(LOG_ERR "ERROR: sshaft.il: copy_file: Could not copy %L to %L" src dest)
      return( nil )
    ) ;if
    return( t )
  ) ;prog
) ;procedure copy_file


procedure( dir_init( dirname mode )
  prog( (path srcname destname )
    if( stringp( mode ) then 
      mode=stringToSymbol(mode)
    ) ;if

    cond( 
      ( mode == 'CadenceDFII
        if( !verify_dir( dirname ) then
          return( nil )
        ) ;if
        path=getSkillPath()
        setSkillPath(nil)
        destname=strcat( dirname "/cds.lib")
        if( !isFile( destname ) then
          srcname=gettechvar("SshaftCdsLibTemplate")
          if( stringp( srcname ) then
            copy_file(srcname destname)
          ) ;if
        ) ;if
        destname=strcat( dirname "/.cdsinit")
        if( !isFile( destname ) then
          srcname=gettechvar("SshaftCdsinitTemplate")
          if( stringp( srcname ) then
            copy_file(srcname destname)
          ) ;if
        ) ;if
        setSkillPath(path)
      )
      ( mode == 'DesignCompiler
        if( !verify_dir( dirname ) then
          return( nil )
        ) ;if
        path=getSkillPath()
        setSkillPath(nil)
        destname=strcat( dirname "/.synopsys_dc.setup")
        if( !isFile( destname ) then
          srcname=gettechvar("SshaftSynDCSetupTemplate")
          if( stringp( srcname ) then
            copy_file(srcname destname)
          ) ;if
        ) ;if
        destname=strcat( dirname "/lib.dc")
        if( !isFile( destname ) then
          srcname=gettechvar("SshaftSynLibTemplate")
          if( stringp( srcname ) then
            copy_file(srcname destname)
          ) ;if
        ) ;if
        setSkillPath(path)
      )
      ( mode == 'ModuleCompiler
        if( !verify_dir( dirname ) then
          return( nil )
        ) ;if
        path=getSkillPath()
        setSkillPath(nil)
        destname=strcat( dirname "/mc.env")
        if( !isFile( destname ) then
          srcname=gettechvar("SshaftSynMCEnvTemplate")
          if( stringp( srcname ) then
            copy_file(srcname destname)
          ) ;if
        ) ;if
        setSkillPath(path)
      )
      ( mode == 'DesignPlanner
        if( !verify_dir( dirname ) then
          return( nil )
        ) ;if
        path=getSkillPath()
        setSkillPath(nil)
        destname=strcat( dirname "/local.dpux")
        if( !isFile( destname ) then
          srcname=gettechvar("SshaftPdpLocalDPUXTemplate")
          if( stringp( srcname ) then
            copy_file(srcname destname)
          ) ;if
        ) ;if
        destname=strcat( dirname "/.hldLocal.cl")
        if( !isFile( destname ) then
          srcname=gettechvar("SshaftPdpHldLocalTemplate")
          if( stringp( srcname ) then
            copy_file(srcname destname)
          ) ;if
        ) ;if
        setSkillPath(path)
      )
      ( t
        logf(LOG_ERR "ERROR: sshaft.il: dir_init: mode %L not recognized" mode)
        return(nil)
      )
    ) ;cond
    return(t)
  ) ;prog
) ;procedure dir_init


procedure( getopcstr( type @optional (opc nil) )
  prog( (opcstr retval str entry count ident)
    opcstr=gettechvar("SshaftOpCondStrings")

    if( !stringp(opcstr) then
      logf(LOG_ERR "ERROR: sshaft.il: getopcstr: SshaftOpCondStrings techfile variable not set")
      return(nil)
    ) ;if

    if( stringp(opc) then
      opc=stringToSymbol(opc)
    ) ;if
    if( stringp(type) then
      type=stringToSymbol(type)
    ) ;if
    if( !symbolp(type) then
      logf(LOG_ERR "ERROR: sshaft.il: getopcstr: type %L is not a symbol or string" type)
      return(nil)
    ) ;if

    opcstr=linereadstring(opcstr)
    retval=prog( ()
      foreach( str opcstr
        if( car(str) == type then
          count=1
          foreach( entry cdr(str)
            if( opc == count || opc == car(entry) then
              logf(LOG_DEBUG "Operating Condition: %L" cadr(entry))
              return(caddr(entry))
            else
              if( (!opc || opc==0 || opc==stringToSymbol("") )
                   && cadddr(entry) then
                logf(LOG_DEBUG "Default Operating Condition: %L" cadr(entry))
                return(caddr(entry))
              ) ;if
            ) ;if
            count++
          ) ;foreach
          logf(LOG_ERR "ERROR: sshaft.il: getopcstr: Could not find operating condition %L for string %L" opc type)
          return(nil)
        ) ;if
      ) ;foreach
      logf(LOG_ERR "ERROR: sshaft.il: getopcstr: Could not find string %L" type)
      return(nil)
    ) ;prog

    if( !retval then
      foreach( str opcstr
        if( car(str) == type then
          logf(LOG_ERR "Possible Values for %L:" type)
          logf(LOG_ERR "Default\tNumber\tIdentifier\tDescription")
          count=1
          foreach( entry cdr(str)
            ident=symbolToString(car(entry))
            if( strlen(ident) < 8 then
              sprintf(ident "%s\t" ident)
            ) ;if
            if( cadddr(entry) then
              logf(LOG_ERR "%L\t%L\t%s\t%s" cadddr(entry) count ident
                   cadr(entry))
            else
              logf(LOG_ERR "\t%L\t%s\t%s" count ident cadr(entry))
            ) ;if
            count++
          ) ;foreach
        ) ;if
      ) ;foreach
    ) ;if

    return(retval)
  ) ;prog
) ;procedure getopcstr      


procedure( create_library( libs libpath )
  prog( (libname ddId bagId path lib techLib attachLibName inList 
         cdsLibPort retval)
    if( stringp( libs ) then
      libs=list(libs)
    ) ;if
    if( !stringp( libpath ) then
      logf(LOG_ERR "ERROR: sshaft.il: create_library: second argument %L is not a string" libpath)
      return( nil )
    ) ;if
    if( !listp( libs ) then
      logf(LOG_ERR "ERROR: sshaft.il: create_library: first argument %L is not a list or string" libs )
      return( nil )
    ) ;if 

    foreach( libname libs
      if( !stringp( libname ) then
        logf(LOG_ERR "ERROR: sshaft.il: create_library: attempt to create library %L which is not a string" libname )
        return( nil )
      ) ;if
      ; Create the library if it doesn't exist
      ddId=ddGetObj( libname )
      if( (!ddId) then
        logf(LOG_INFO "Creating library %L" libname)
        path=strcat( libpath "/" libname )
        ddId=ddCreateLib( libname path )
        if( (!ddId) then
          logf(LOG_ERR "ERROR: Could not create library %L" libname)
          return( nil )
        ) ;if
        ; The following was taken from the NCSU CDK function createLibCB
        ; in the file skill/menus/ciw/createLib.il
        if( getd( 'NCSU_libCreateUserFunc ) then
          NCSU_libCreateUserFunc( ddId )
        ) ;if

        ; The following was modified from the NCSU CDK function
        ; getAttachLibName in the file skill/menus/ciw/attachTech.il
        techLib = gettechvar('NcsuCdk\:\:CdsTechData)
        if( (!techLib) then
          logf(LOG_ERR "ERROR: Techfile variable CdsNcsuCdkTechData not defined")
          return( nil )
        ) ;if
        attachLibName = NCSU_techData[techLib]->techLib
        if( (!attachLibName) then
          logf(LOG_ERR "ERROR: No NCSU_techData entry for %L" techLib)
          return( nil )
        ) ;if
        foreach( lib ddGetLibList() 
          if( lib~>name == attachLibName
            inList = t
          ) ;if
        ) ;foreach
        if( (!inList) then
          cdsLibPort = outfile( "./cds.lib" "a" )
          if( (!cdsLibPort) 
            cdsLibPort = outfile( strcat( "~/cds.lib" ) "a" )
            if( (!cdsLibPort)
              logf(LOG_WARN "Can't update cds.lib file!" )
            ) ;if
          ) ;if

          if( cdsLibPort then
            fprintf( cdsLibPort "DEFINE %s %s/lib/%s\n" 
                                      attachLibName
                                      getShellEnvVar( "CDS_SITE" )
                                      attachLibName )
            close( cdsLibPort )
            ddUpdateLibList()
            logf(LOG_INFO "Updated cds.lib file and library path..." )
          ) ;if
        ) ;if

        ; The following was modified from the NCSU CDK function createLibCB
        ; in the file skill/menus/ciw/createLib.il

        ; refresh libID variable since lib list might have changed
        ddId=ddGetObj(libname)
        retval = techBindTechFile( ddId attachLibName "techfile.cds" t )
        if( (!retval) then
          logf(LOG_ERR "ERROR: sshaft.il: create_library: Technology file attach failed!")
          return( nil )
        ) ;if


        ;bagId=dbOpenBag( ddId "a" )
        ;dbCreateProp( bagId "techLibName" "string" gettechvar('CdsTechLib ))
        ;dbSaveBag( bagId )
        ;dbCloseBag( bagId "a")

      ) ;if
    ) ;foreach

    return( t )
  ) ;prog
) ;procedure create_library



procedure( use_library( libname libpath )
  prog( (lib ddId bagId path in out line rex found plrprfx dirname)
    if( !stringp( libname ) then
      logf(LOG_ERR "ERROR: sshaft.il: use_library: first argument %L is not a list or string" libname )
      return( nil )
    ) ;if 
    if( !stringp( libpath ) then
      logf(LOG_ERR "ERROR: sshaft.il: use_library: second argument %L is not a string" libpath)
      return( nil )
    ) ;if

    ; Define library if not already defined
    ddId=ddGetObj( libname )
    if( (!ddId) then
      logf(LOG_INFO "Defining library %L" libname)
      ddId=ddCreateLib( libname libpath )
      if( (!ddId) then
        logf(LOG_ERR "ERROR: Could not define library %L at path" libname
                     libpath )
        return( nil )
      ) ;if
    ) ;if

    plrprfx=gettechvar("SshaftPdpLibDirPrefix")
    sprintf(dirname "%s/%s" plrprfx libname)
    verify_dir(dirname)

    in=infile("../dp/local.dpux")
    if( !in then
      logf(LOG_ERR "ERROR: sshaft.il: use_library: Could not open ../dp/local.dpux for reading")
      return(nil)
    ) ;if

    out=outfile("../dp/local.dpux.temp")
    if( !out then
      logf(LOG_ERR "ERROR: sshaft.il: use_library: Could not open ../dp/local.dpux.temp for writing")
      return(nil)
    ) ;if

    while( gets(line in)
      if( !rexMatchp( "^[ \\t\\n]*#" line) then
        sprintf( rex "^[ \\t\\n]*(LIBPATH[ \\t\\n]+%s[ \\t\\n]+" libname)
        if( rexMatchp( rex line) then
          found=t
        ) ;if
        if( rexMatchp( "^[ \\t\\n]*ENDDEFLIBPATH)" line ) then
        ;if( contains_substring( line "ENDDEFLIBPATH)") then
          if( !found then
            fprintf( out "    (LIBPATH %s %s )\n" libname dirname )
          ) ;if
        ) ;if
      ) ;if
      fprintf( out "%s" line )
    ) ;while

    close(in)
    close(out)

    copy_file("../dp/local.dpux.temp" "../dp/local.dpux")
    if( !deleteFile("../dp/local.dpux.temp") then
      logf(LOG_ERR "ERROR: sshaft.il: use_library: Could not delete ../dp/local.dpux.temp")
      return(nil)
    ) ;if

    return( t )
  ) ;prog
) ;procedure use_library










