
/****************************************************/
 LIBRARY = "NCSU_Devices_FreePDK45"
 CELL    = "NMOS_VTH"
/****************************************************/

let( ( libId cellId cdfId )
    unless( cellId = ddGetObj( LIBRARY CELL )
        error( "Could not get cell %s." CELL )
    )
    when( cdfId = cdfGetBaseCellCDF( cellId )
        cdfDeleteCDF( cdfId )
    )
    cdfId  = cdfCreateBaseCellCDF( cellId )

    ;;; Parameters
    cdfCreateParam( cdfId
        ?name           "model"
        ?prompt         "Model name"
        ?defValue       "NMOS_VTH"
        ?type           "string"
        ?display        "artParameterInToolDisplay('model)"
        ?storeDefault   "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "w"
        ?prompt         "Width"
        ?units          "lengthMetric"
        ?defValue       ncsuGlobalData->MinW
        ?type           "string"
        ?display        "artParameterInToolDisplay('w)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
        ?callback       "ncsuWidthCallBack()"
    )
    cdfCreateParam( cdfId
        ?name           "l"
        ?prompt         "Length"
        ?units          "lengthMetric"
        ?defValue       ncsuGlobalData->MinL
        ?type           "string"
        ?display        "artParameterInToolDisplay('l)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
        ?callback       "ncsuLengthCallBack()"
    )
    cdfCreateParam( cdfId
        ?name           "as"
        ?prompt         "Source diffusion area"
        ?defValue       ncsuGlobalData->BaseSourceArea
        ?type           "string"
        ?display        "artParameterInToolDisplay('as)"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ad"
        ?prompt         "Drain diffusion area"
        ?defValue       ncsuGlobalData->BaseDrainArea
        ?type           "string"
        ?display        "artParameterInToolDisplay('ad)"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ps"
        ?prompt         "Source diffusion periphery"
        ?units          "lengthMetric"
        ?defValue       ncsuGlobalData->BaseSourcePeriph
        ?type           "string"
        ?display        "artParameterInToolDisplay('ps)"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "pd"
        ?prompt         "Drain diffusion periphery"
        ?units          "lengthMetric"
        ?defValue       ncsuGlobalData->BaseDrainPeriph
        ?type           "string"
        ?display        "artParameterInToolDisplay('pd)"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "nrd"
        ?prompt         "Drain diffusion res squares"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('nrd)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "nrs"
        ?prompt         "Source diffusion res squares"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('nrs)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ld"
        ?prompt         "Drain diffusion length"
        ?units          "lengthMetric"
        ?defValue       ncsuGlobalData->MinDrainLength
        ?type           "string"
        ?display        "artParameterInToolDisplay('ld)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
        ?callback       "ncsuDrainDiffLengthCallBack()"       
    )
    cdfCreateParam( cdfId
        ?name           "ls"
        ?prompt         "Source diffusion length"
        ?units          "lengthMetric"
        ?defValue       ncsuGlobalData->MinSourceLength
        ?type           "string"
        ?display        "artParameterInToolDisplay('ls)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
        ?callback       "ncsuSourceDiffLengthCallBack()" 
    )
    cdfCreateParam( cdfId
        ?name           "m"
        ?prompt         "Multiplier"
        ?defValue       "1"
        ?type           "string"
        ?display        "artParameterInToolDisplay('m)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
        ?callback       "ncsuMultiplierCallBack()"
    )
    cdfCreateParam( cdfId
        ?name           "trise"
        ?prompt         "Temp rise from ambient"
        ?defValue       ""
        ?type           "string"
        ?use            "!cdfgData->triseSpec ||                        cdfgData->triseSpec->value == \"trise\""
        ?display        "artParameterInToolDisplay('trise)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "region"
        ?prompt         "Estimated operating region"
        ?defValue       " "
        ?choices        '(" " "off" "triode" "sat" "subth")
        ?type           "cyclic"
        ?display        "artParameterInToolDisplay('region)"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "degradation"
        ?prompt         "Hot-electron degradation"
        ?defValue       ""
        ?choices        '("" "no" "yes")
        ?type           "cyclic"
        ?display        "artParameterInToolDisplay('degradation)"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "geo"
        ?prompt         "Source/drain selector"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('geo)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "rdc"
        ?prompt         "Additional drain resistance"
        ?units          "resistance"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('rdc)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "rsc"
        ?prompt         "Additional source resistance"
        ?units          "resistance"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('rsc)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "sa"
        ?prompt         "Dist. OD & poly(one side)"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('sa)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "sb"
        ?prompt         "Dist. OD & poly(other side)"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('sb)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "sd"
        ?prompt         "Dist. betn neighbour fingers"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('sd)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "off"
        ?prompt         "Device initially off"
        ?type           "boolean"
        ?display        "artParameterInToolDisplay('off)"
    )
    cdfCreateParam( cdfId
        ?name           "Vds"
        ?prompt         "Drain source initial voltage"
        ?units          "voltage"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('Vds)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "Vgs"
        ?prompt         "Gate source initial voltage"
        ?units          "voltage"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('Vgs)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "Vbs"
        ?prompt         "Bulk source initial voltage"
        ?units          "voltage"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('Vbs)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "dtemp"
        ?prompt         "Temperature difference"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('dtemp)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )

    ;;; Simulator Information
    cdfId->simInfo = list( nil )
    cdfId->simInfo->UltraSim = '( nil )
    cdfId->simInfo->ams = '( nil
        propMapping       nil
        namePrefix        ""
        isPrimitive       (t)
        enumParameters    (region)
        termOrder         (D G S B)
        termMapping       (nil D \:d G \:g S \:s B \:b)
        instParameters    (w l as ad ps pd nrd nrs ld ls m trise model)
        otherParameters   (model)
    )
    cdfId->simInfo->auCdl = '( nil
        dollarEqualParams nil
        dollarParams      nil
        otherParameters   nil
        netlistProcedure  ansCdlCompPrim
        instParameters    (m L W)
        componentName     nmos
        termOrder         (D G S B)
        propMapping       (nil L l W w)
        namePrefix        "M"
        modelName         "NMOS_VTH"
    )
    cdfId->simInfo->auLvs = '( nil
        propMapping       nil
        netlistProcedure  ansLvsCompPrim
        instParameters    (m l w)
        componentName     nmos
        termOrder         (D G S B)
        permuteRule       "(p D S)"
        namePrefix        "M"
    )
    cdfId->simInfo->hspiceD = '( nil
        termMapping       (nil D \,D G \,G S \,S B \,B)
        netlistProcedure  hspiceDCompPrim
        instParameters    (m w l ad as pd ps nrd nrs rdc rsc off Vds Vgs Vbs dtemp geo)
        otherParameters   (model)
        componentName     nmos
        termOrder         (D G S B)
        dataAccessMap     ((IDC (D "id")))
        propMapping       (nil vds Vds vgs Vgs vbs Vbs)
        namePrefix        "M"
    )
    cdfId->simInfo->spectre = '( nil
        propMapping       nil
        namePrefix        ""
        otherParameters   (model)
        instParameters    (w l as ad ps pd nrd nrs ld ls m trise region degradation geo rdc rsc sa sb sd)
        termOrder         (D G S B)
        termMapping       (nil D \:d G \:g S \:s B \:b)
    )

    ;;; Properties
    cdfId->formInitProc            = ""
    cdfId->doneProc                = ""
    cdfId->buttonFieldWidth        = 340
    cdfId->fieldHeight             = 35
    cdfId->fieldWidth              = 350
    cdfId->promptWidth             = 175
    cdfId->paramLabelSet           = "-model l w"
    cdfId->opPointLabelSet         = "id vgs vds"
    cdfId->modelLabelSet           = "vto kp gamma"
    cdfSaveCDF( cdfId )
)
