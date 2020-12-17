;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; testproc.il
;
; 9/17/2005 Rhett Davis (rhett_davis@ncsu.edu)
;
; This file defines the SKILL substeps that serve
; as part of the SSHAFT-API regression test suite.
; It also serves as a template for other SKILL
; substeps written in the SSHAFT framework.  
; The complete test calls the following procedures:
;
; -- testsshaft.tcl
;    foreach scriptapp
;      |-- scriptapp
;          |-- substep1
;              |-- substep2
;                  |-- testsshaft.tcl -return
;                  foreach app
;                    |-- app:substep3
;    foreach app
;      |-- app:substep1
;          |-- substep2
;              |-- testsshaft.tcl -return
;              foreach app
;                |-- app:substep3
;
; The -depth argument to each step indicates the
; depth of descent.  The stepname and appname are
; added to this argument (separated by a colon) 
; and passed to each substep.  If -depth is omitted, 
; it is assumed to be and empty string.  It is 
; assumed that the first call to testsshaft.tcl will 
; leave the -depth argument blank, meaning that the 
; depth will be "testsshaft.tcl" for substep1,
; "testsshaft.tcl:substep1" in substep2, and so on.
;
; The -die argument tells the depth at which the
; dief API function should be called.  For example,
; assuming that the first scriptapp called is
; testapp.tcl, if the -die argument is set to 
; testsshaft.tcl:testapp.tcl:substep1, then dief
; will be called in substep1 before calling substep2.
;
; The -return argument tells testsshaft.tcl to return
; without calling any of the substeps.  This argument
; is used so that testsshaft.tcl can double as a
; leaf-node in the regression test tree.
;
; testsshaft.tcl is defined in 
;     dist/src/tcl/testsshaft.tcl
; The other scriptapps are defined in 
;     dist/src/[lang]/testapp.[lang]
;     where [lang] is tcl, py, or pl
; substep1, substep2, and substep3 are defined in
;     dist/lib/[lang]/testproc.[lang]
;     where [lang] is tcl, py, or il
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

procedure( substep1( @key (depth "") (diedepth "") (stepargs nil) )
  prog( (retval)
    beginstep("substep1")
    depth=strcat(depth ":substep1")
    if( depth==diedepth then
      dief("ERROR: Error depth reached: %L" diedepth)
    ) ;if

    ; sshaft.substep(cmd=[substep2,[],{'depth':depth, 'diedepth':diedepth }])

    endstep()
  ) ;prog
) ;procedure substep1

procedure( substep2( @key (depth "") (diedepth "") (stepargs nil) )
  prog( (retval)
    beginstep("substep2")
    depth=strcat(depth ":substep2")
    if( depth==diedepth then
      dief("ERROR: Error depth reached: %L" diedepth)
    ) ;if

    ;cmd="testapp.py"
    ;cmd=cmd+" -depth "+depth
    ;cmd=cmd+" -return"
    ;if (diedepth):
    ;    cmd=cmd+" -die "+diedepth
    ;sshaft.substep(mode='unix_step',cmd=cmd)

    endstep()
  ) ;prog
) ;procedure substep2


procedure( substep3( @key (depth "") (diedepth "") (stepargs nil) )
  prog( (retval)
    beginstep("substep3")
    depth=strcat(depth ":substep3")
    if( depth==diedepth then
      dief("ERROR: Error depth reached: %L" diedepth)
    ) ;if

    endstep()
  ) ;prog
) ;procedure substep3

