procedure( loadsshaft()
  let( (path)
    path=getSkillPath()

    setSkillPath( getShellEnvVar( "SSHAFT_SKILL" ) )
    loadi("sshaft.il")
    loadi("testproc.il")
    loadi("gentech.il")

    setSkillPath(path)
  ) ;let
) ;procedure loadsshaft
loadsshaft()

