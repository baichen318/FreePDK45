; FreePDK 45 Global Variables Declarations
; Evan Erickson (NCSU) - 2/15/10

; Changes to the data structure below will affect all SKILL code AND ONLY SKILL code contained in the /skill directory.  
; Currently this only affects schematics for the library: NCSU_Devices_FreePDK45

defstruct( GlobalDefs Description TechLib MinW MinL MaxW MaxL MinSourceLength MinDrainLength 
           MaxSourceLength MaxDrainLength BaseSourceArea BaseDrainArea BaseSourcePeriph 
           BaseDrainPeriph PolyMinSpacing GridRes)
           
ncsuGlobalData =
      make_GlobalDefs(
                      ?Description        "FreePDK 45nm (11M, 3VT)"  ; Description
                      ?TechLib            "NCSU_TechLib_FreePDK45"   ; Tech File Name
                      ?MinW               "90n"                      ; Min Width
                      ?MinL               "50n"                      ; Min Length
                      ?MaxW               "100u"                     ; Max Width
                      ?MaxL               "100u"                     ; Max Length
                      ?MinSourceLength    "105n"                     ; Min Length of Source Region
                      ?MinDrainLength     "105n"                     ; Min Length of Drain Region
                      ?MaxSourceLength    "100u"                     ; Max Length of Source Region
                      ?MaxDrainLength     "100u"                     ; Max Length of Drain Region
                      ?BaseSourceArea     "9.45e-15"                 ; As = W * Source Length (nm^2)
                      ?BaseDrainArea      "9.45e-15"                 ; Ad = W * Drain Length (nm^2)
                      ?BaseSourcePeriph   "300n"                     ; Ps = 2 * Source Length + Width (nm)
                      ?BaseDrainPeriph    "300n"                     ; Pd = 2 * Drain Length + Width (nm)
                      ?PolyMinSpacing     "140n"                     ; Min spacing of poly AND active (POLY.2)
                      ?GridRes            2.5e-9
                     )
