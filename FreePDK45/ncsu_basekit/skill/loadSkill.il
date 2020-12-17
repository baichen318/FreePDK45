; Load all SKILL code in the /skill directory by loading this file
; globalData.il must be the first loadded since the variable propagates to other SKILL code
loadi( strcat( getShellEnvVar("PDK_DIR") "/ncsu_basekit/skill/globalData.il"))
loadi( strcat( getShellEnvVar("PDK_DIR") "/ncsu_basekit/skill/callbacks.il"))
;loadi( strcat( getShellEnvVar("PDK_DIR") "/ncsu_basekit/skill/cdf/loadSkill.il"))
