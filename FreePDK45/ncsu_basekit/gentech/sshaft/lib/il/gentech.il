procedure( pdkCreateLib( @key  (lib "mylib") (stepargs nil) )
  prog( (datadir) 
    beginstep("fpkCreateLib")

    create_library(lib ".")

    endstep()
  ) ;prog
) ;procedure fpkCreateLib


procedure( pdkAppendTechfile( @key (libname "NCSU_TechLib_FreePDK45") 
            (filename "FreePDK45.tf") (stepargs nil) )
  prog( (libID techFileID ret )
    beginstep("pdkAppendTechfile")

    filename = strcat( getShellEnvVar( "PDK_DIR" ) "/ncsu_basekit/techfile/" filename)
    path = strcat( getShellEnvVar( "PDK_DIR" ) "/ncsu_basekit/lib/" libname )
    logf(LOG_INFO "Loading %L into %L..." filename path )
    techFileID = techOpenTechFile( libname "tech.db" "a" )
    ret = tcLoadTechFile( techFileID filename )
    if( ret == t then
        techSaveTechFile( techFileID )
    else
        dief("ERROR: Aborting tech file compilation..." )
    ) ;if
    logf(LOG_INFO "Techfile successfully appended." )

    ; Update the CDF for the NCSU_Devices_FreePDK45 library
    loadi( strcat( getShellEnvVar("PDK_DIR") "/ncsu_basekit/skill/cdf/loadSkill.il"))
    logf(LOG_INFO "CDF Data for Devices library successfully updated." )
   
    endstep()
  ) ;prog
) ;procedure pdkAppendTechfile


procedure( pdkCompileTechLibrary( @key (libname nil) 
            (path nil) (filename nil) (stepargs nil) (tech nil) )
  prog( (libID techFileID ret )
    beginstep("pdkCompileTechLibrary")

    if( !libname then
      libname = gettechvar("GenTech::TechLibName")
    ) ;if
    libID = ddGetObj( libname )
    if( libID then
        ddDeleteObj(libID)
    ) ;if

    if( !filename then
      filename = strcat( getShellEnvVar( "PDK_DIR" ) "/ncsu_basekit/techfile/" 
                         gettechvar("GenTech::CdsTechFile"))
    ) ;if
    libID = ddGetObj( libname )
    if( libID then
        ddDeleteObj(libID)
    ) ;if

    if( path=='install then
      path = strcat( getShellEnvVar( "PDK_DIR" ) "/ncsu_basekit/lib/" libname )
    ) ;if

    logf(LOG_DEBUG "libname = %L filename = %L path = %L" 
                   libname filename path)

    /*
     * actually create the library
     */
    libID = ddCreateLib( libname path )
    if( libID == nil then
        dief("ERROR: Creation of library %L failed!" libname )
    ) ;if

    ; make your own tech library
    logf(LOG_INFO "Loading technology file..." )
    techFileID = techOpenTechFile( libname "tech.db" "w" )
    ret = tcLoadTechFile( techFileID filename )
    if( ret == t then
        techSaveTechFile( techFileID )
    else
        dief("ERROR: Aborting tech file compilation..." )
    ) ;if

    ; set lambda & technology properties so Diva rules can access them later on
    bag = dbOpenBag( libID "w" )
    if( bag == nil then
        printf( "ERROR: Can't open library property bag! Aborting..." )
        return( nil )
    ) ;if
    dbCreateProp( bag "PadType" "string" "Perimeter")
    dbCreateProp( bag "technology" "string" tech )
    dbCreateProp( bag "model" "string" NCSU_techData[tech]->fetModelPrefix )
    dbCreateProp( bag "gridResolution" "float" NCSU_techData[tech]->gridRes )
    dbCreateProp( bag "minLength" "float" NCSU_techData[tech]->minL )
    dbCreateProp( bag "minWidth" "float" NCSU_techData[tech]->minW )
    dbSaveBag( bag )
    dbCloseBag( bag )

    
    logf(LOG_INFO "Library creation successfully completed." )
   
    endstep()
  ) ;prog
) ;procedure pdkCompileTechLibrary

