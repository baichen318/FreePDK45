; FreePDK45 Schematic Callbacks
; Evan Erickson (NCSU) - 2/15/10

/**************************************************************/
/*  ncsuWidthCallBack()                                       */
/*  sets: [w areas peripheries]                               */
/**************************************************************/
procedure( ncsuWidthCallBack()
  let( (grid width max_width min_width)
  
    ; Set Grid, Min & Max W values from globalData.il
    grid = ncsuGlobalData->GridRes
    max_width = round(cdfParseFloatString(ncsuGlobalData->MaxW)/grid)*grid
    min_width = round(cdfParseFloatString(ncsuGlobalData->MinW)/grid)*grid
    
    ; Ensure width is on grid
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
    
    ; If width is less than minimum, set to Min
    if( (width < min_width)
    then
        width = min_width
        warn("WARNING: Minimum Width is %g M\n" min_width)
    ); if
    
    ; If width is greater than maximum, set to Max
    if( (width > max_width)
    then
        width = max_width
        warn("WARNING: Maximum Width is %g M\n" max_width)
    ); if
    
    ; Set Width
    cdfgData->w->value = sprintf(s "%g" width)
    
    ; Adjust Areas
    ncsuAreaSourceCalc()
    ncsuAreaDrainCalc()
    
    ; Adjust Peripheries
    ncsuPeriphSourceCalc()
    ncsuPeriphDrainCalc()
  ); let
)


/**************************************************************/
/*  ncsuLengthCallBack()                                      */
/*  sets: [l]                                                 */
/**************************************************************/
procedure( ncsuLengthCallBack()
  let( (grid length max_length min_length)
  
    ; Set Grid, Min & Max L values from globalData.il
    grid = ncsuGlobalData->GridRes
    max_length = round(cdfParseFloatString(ncsuGlobalData->MaxL)/grid)*grid
    min_length = round(cdfParseFloatString(ncsuGlobalData->MinL)/grid)*grid
    
    ; Ensure length is on grid
    length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid
    
    ; If length is less than minimum, set to Min
    if( (length < min_length)
    then
        length = min_length
        warn("WARNING: Minimum Length is %g M\n" min_length)
    ); if
    
    ; If length is greater than maximum, set to Max
    if( (length > max_length)
    then
        length = max_length
        warn("WARNING: Maximum Length is %g M\n" max_length)
    ); if
    
    ; Set Length
    cdfgData->l->value = sprintf(s "%g" length) 
  ); let
)


/**************************************************************/
/*  ncsuSourceDiffLengthCallBack()                            */
/*  sets: [areas peripheries]                                 */
/**************************************************************/
procedure( ncsuSourceDiffLengthCallBack()
  let( (grid source_length max_source_length min_source_length)
  
    ; Set Grid, Min & Max W values from globalData.il
    grid = ncsuGlobalData->GridRes
    max_source_length = round(cdfParseFloatString(ncsuGlobalData->MaxSourceLength)/grid)*grid
    min_source_length = round(cdfParseFloatString(ncsuGlobalData->MinSourceLength)/grid)*grid
    
    ; Ensure source diffusion length is on grid
    source_length = round(cdfParseFloatString(cdfgData->ls->value)/grid)*grid
    
    ; If source difussion length is less than minimum, set to Min
    if( (source_length < min_source_length)
    then
        source_length = min_source_length
        warn("WARNING: Minimum Source Diffusion Length is %g M\n" min_source_length)
    ); if
    
    ; If source diffusion length is greater than maximum, set to Max
    if( (source_length > max_source_length)
    then
        source_length = max_source_length
        warn("WARNING: Maximum Source Diffusion Length is %g M\n" max_source_length)
    ); if
    
    ; Set Source Length
    cdfgData->ls->value = sprintf(s "%g" source_length)
    
    ; Recalculate Area & Periphery
    ncsuAreaSourceCalc()
    ncsuPeriphSourceCalc()
  ); let
)


/**************************************************************/
/*  ncsuDrainDiffLengthCallBack()                             */
/*  sets: [areas peripheries]                                 */
/**************************************************************/
procedure( ncsuDrainDiffLengthCallBack()
  let( (grid drain_length max_drain_length min_drain_length)
  
    ; Set Grid, Min & Max W values from globalData.il
    grid = ncsuGlobalData->GridRes
    max_drain_length = round(cdfParseFloatString(ncsuGlobalData->MaxDrainLength)/grid)*grid
    min_drain_length = round(cdfParseFloatString(ncsuGlobalData->MinDrainLength)/grid)*grid
    
    ; Ensure drain diffusion length is on grid
    drain_length = round(cdfParseFloatString(cdfgData->ld->value)/grid)*grid
    
    ; If drain difussion length is less than minimum, set to Min
    if( (drain_length < min_drain_length)
    then
        drain_length = min_drain_length
        warn("WARNING: Minimum Drain Diffusion Length is %g M\n" min_drain_length)
    ); if
    
    ; If drain diffusion length is greater than maximum, set to Max
    if( (drain_length > max_drain_length)
    then
        drain_length = max_drain_length
        warn("WARNING: Maximum Drain Diffusion Length is %g M\n" max_drain_length)
    ); if
    
    ; Set Length
    cdfgData->ld->value = sprintf(s "%g" drain_length)
    
    ; Recalculate Area & Periphery
    ncsuAreaDrainCalc()
    ncsuPeriphDrainCalc()
  ); let
)


/**************************************************************/
/*  ncsuMultiplierCallBack()                                  */
/*  sets: [m areas peripheries]                               */
/**************************************************************/
procedure( ncsuMultiplierCallBack()
  let( (multiplier)
  
    multiplier = round(cdfParseFloatString(cdfgData->m->value)/1.0)*1.0
    
    ; If multiplier is less than 1, set to 1
    if( (multiplier < 1.0)
    then
        multiplier = 1.0
        warn("WARNING: Minimum Multiplier is 1\n")
    ); if
    
    ; If multiplier is greater than 500, set to 500
    if( (multiplier > 500.0)
    then
        multiplier = 500.0
        warn("WARNING: Minimum Multiplier is 500\n")
    ); if
    
    ; Set Multiplier
    cdfgData->m->value = sprintf(s "%g" multiplier)
    
    ; Recalculate Areas & Peripheries
    ncsuAreaSourceCalc()
    ncsuAreaDrainCalc()
    ncsuPeriphSourceCalc()
    ncsuPeriphDrainCalc()
  ); let
)


/**************************************************************/
/*                  SUBFUNCTIONS                              */
/**************************************************************/

; Calculates Source Area (As)
procedure( ncsuAreaSourceCalc()
  let( (grid width source_length poly_min_spacing multiplier)
  
    grid = ncsuGlobalData->GridRes
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
    source_length = round(cdfParseFloatString(cdfgData->ls->value)/grid)*grid
    poly_min_spacing = round(cdfParseFloatString(ncsuGlobalData->PolyMinSpacing)/grid)*grid
    multiplier = round(cdfParseFloatString(cdfgData->m->value))
    
    ; As = W * Source Length (nm^2)
    ; Varies based on the multiplier
    cond( ( (multiplier <= 1) 
                cdfgData->as->value = sprintf(s "%g" (width * source_length)) )
          ( (multiplier == 2) 
                cdfgData->as->value = sprintf(s "%g" (2*(width * source_length))) )
          ( ((multiplier >= 3) && evenp(multiplier)) 
                cdfgData->as->value = sprintf(s "%g" (2*(width * source_length) + ((((multiplier-4)/2)+1) * (width * poly_min_spacing))) ))
          ( ((multiplier >= 3) && oddp(multiplier)) 
                cdfgData->as->value = sprintf(s "%g" ((width * source_length) + ((((multiplier-3)/2)+1) * (width * poly_min_spacing)))) )
          ( (t)
                cdfgData->as->value = sprintf(s "%g" 0.0) )
                warn("WARNING: ncsuAreaSourceCalc() FAILED\n")
        ) ; cond
  ) ; let
)


; Calculates Drain Area (Ad)
procedure( ncsuAreaDrainCalc()
  let( (grid width drain_length poly_min_spacing multiplier)
  
    grid = ncsuGlobalData->GridRes
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
    drain_length = round(cdfParseFloatString(cdfgData->ld->value)/grid)*grid
    poly_min_spacing = round(cdfParseFloatString(ncsuGlobalData->PolyMinSpacing)/grid)*grid
    multiplier = round(cdfParseFloatString(cdfgData->m->value))
    
    ; As = W * Drain Length (nm^2)
    ; Varies based on the multiplier
    cond( ( (multiplier <= 1) 
                cdfgData->ad->value = sprintf(s "%g" (width * drain_length)) )
          ( (multiplier == 2) 
                cdfgData->ad->value = sprintf(s "%g" (width * poly_min_spacing)) )
          ( ((multiplier >= 3) && evenp(multiplier)) 
                cdfgData->ad->value = sprintf(s "%g" ((((multiplier-2)/2)+1) * (width * poly_min_spacing)) ))
          ( ((multiplier >= 3) && oddp(multiplier)) 
                cdfgData->ad->value = sprintf(s "%g" ((width * drain_length) + ((((multiplier-3)/2)+1) * (width * poly_min_spacing)))) )
          ( (t)
                cdfgData->ad->value = sprintf(s "%g" 0.0) )
                warn("WARNING: ncsuAreaDrainCalc() FAILED\n")
        ) ; cond
  ) ; let
)


; Calculates Source Periphery (Ad)
procedure( ncsuPeriphSourceCalc()
  let( (grid width source_length poly_min_spacing multiplier)
  
    grid = ncsuGlobalData->GridRes
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
    source_length = round(cdfParseFloatString(cdfgData->ls->value)/grid)*grid
    poly_min_spacing = round(cdfParseFloatString(ncsuGlobalData->PolyMinSpacing)/grid)*grid
    multiplier = round(cdfParseFloatString(cdfgData->m->value))
    
    ; Ps = 2 * Source Length + Width (nm)
    ; Varies based on the multiplier
    cond( ( (multiplier <= 1) 
                cdfgData->ps->value = sprintf(s "%g" (width + 2*source_length)) )
          ( (multiplier == 2) 
                cdfgData->ps->value = sprintf(s "%g" (2*(width + 2*source_length))) )
          ( ((multiplier >= 3) && evenp(multiplier)) 
                cdfgData->ps->value = sprintf(s "%g" ((2*(width + 2*source_length)) + ((((multiplier-4)/2)+1) * (2 * poly_min_spacing))) ))
          ( ((multiplier >= 3) && oddp(multiplier)) 
                cdfgData->ps->value = sprintf(s "%g" ((width + 2*source_length) + ((((multiplier-3)/2)+1) * (2 * poly_min_spacing))) ))
          ( (t)
                cdfgData->ad->value = sprintf(s "%g" 0.0) )
                warn("WARNING: ncsuPeriphSourceCalc() FAILED\n")
        ) ; cond
  ) ; let
)


; Calculates Drain Periphery (Ad)
procedure( ncsuPeriphDrainCalc()
  let( (grid width drain_length poly_min_spacing multiplier)
  
    grid = ncsuGlobalData->GridRes
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
    drain_length = round(cdfParseFloatString(cdfgData->ld->value)/grid)*grid
    poly_min_spacing = round(cdfParseFloatString(ncsuGlobalData->PolyMinSpacing)/grid)*grid
    multiplier = round(cdfParseFloatString(cdfgData->m->value))
    
    ; Pd = 2 * Drain Length + Width (nm)
    ; Varies based on the multiplier
    cond( ( (multiplier <= 1) 
                cdfgData->pd->value = sprintf(s "%g" (width + 2*drain_length)) )
          ( (multiplier == 2) 
                cdfgData->pd->value = sprintf(s "%g" (2 * poly_min_spacing)) )
          ( ((multiplier >= 3) && evenp(multiplier)) 
                cdfgData->pd->value = sprintf(s "%g" ((((multiplier-2)/2)+1) * (2 * poly_min_spacing)) ))
          ( ((multiplier >= 3) && oddp(multiplier)) 
                cdfgData->pd->value = sprintf(s "%g" ((width + 2*drain_length) + ((((multiplier-3)/2)+1) * (2 * poly_min_spacing))) ))
          ( (t)
                cdfgData->ad->value = sprintf(s "%g" 0.0) )
                warn("WARNING: ncsuPeriphDrainCalc() FAILED\n")
        ) ; cond
  ) ; let
)





