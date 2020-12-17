LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
LIBRARY IEEE;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

package prim is

CONSTANT DefCombSpikeMsgOn : BOOLEAN := true;
CONSTANT DefCombSpikeXOn   : BOOLEAN := true;
CONSTANT DefSeqMsgOn       : BOOLEAN := true;
CONSTANT DefSeqXOn         : BOOLEAN := true;

CONSTANT DefDummyDelay    : VitalDelayType := 1.00 ns;
CONSTANT DefDummySetup    : VitalDelayType := 1.00 ns;
CONSTANT DefDummyHold     : VitalDelayType := 1.00 ns;
CONSTANT DefDummyWidth    : VitalDelayType := 1.00 ns;
CONSTANT DefDummyRecovery : VitalDelayType := 1.00 ns;
CONSTANT DefDummyRemoval  : VitalDelayType := 1.00 ns;
CONSTANT DefDummyIpd      : VitalDelayType := 0.00 ns;
CONSTANT DefDummyIsd      : VitalDelayType := 0.00 ns;
CONSTANT DefDummyIcd      : VitalDelayType := 0.00 ns;

CONSTANT udp_dff : VitalStateTableType (1 TO 21, 1 TO 7) := (
--    NOTIFIER   D      CLK     RN       S      Q(t)   Q(t+1)
     (  'X',    '-',    '-',    '-',    '-',    '-',    'X'  ),
     (  '-',    '-',    '-',    '-',    '1',    '-',    '1'  ),
     (  '-',    '-',    '-',    '1',    '0',    '-',    '0'  ),
     (  '-',    '0',    '/',    '-',    '0',    '-',    '0'  ),
     (  '-',    '1',    '/',    '0',    '-',    '-',    '1'  ),
     (  '-',    '1',    '*',    '0',    '-',    '1',    '1'  ),
     (  '-',    '0',    '*',    '-',    '0',    '0',    '0'  ),
     (  '-',    '-',    '\',   '-',    '-',    '-',    'S'  ),
     (  '-',    '*',    'B',    '-',    '-',    '-',    'S'  ),
     (  '-',    '-',    'B',    '0',    '*',    '1',    '1'  ),
     (  '-',    '1',    'X',    '0',    '*',    '1',    '1'  ),
     (  '-',    '-',    'B',    '*',    '0',    '0',    '0'  ),
     (  '-',    '0',    'X',    '*',    '0',    '0',    '0'  ),
     (  '-',    'B',    'r',    '-',    '-',    '-',    'X'  ),
     (  '-',    '/',    'X',    '-',    '-',    '-',    'X'  ),
     (  '-',    '-',    '-',    '-',    '*',    '-',    'X'  ),
     (  '-',    '-',    '-',    '*',    '-',    '-',    'X'  ),
     (  '-',    '-',    'f',    '-',    '-',    '-',    'X'  ),
     (  '-',    '\',   'X',    '0',    '-',    '-',    'X'  ),
     (  '-',    'B',    'X',    '-',    '-',    '-',    'S'  ),
     (  '-',    '-',    'S',    '-',    '-',    '-',    'S'  ));

CONSTANT udp_tlat : VitalStateTableType (1 TO 20, 1 TO 7) := (
--      NOT      D       G       R       S      Q(t)  Q(t+1)
     (  'X',    '-',    '-',    '-',    '-',    '-',    'X'  ),
     (  '-',    '-',    '-',    '-',    '1',    '-',    '1'  ),
     (  '-',    '-',    '-',    '1',    '0',    '-',    '0'  ),
     (  '-',    '1',    '1',    '0',    '-',    '-',    '1'  ),
     (  '-',    '0',    '1',    '-',    '0',    '-',    '0'  ),
     (  '-',    '1',    '*',    '0',    '-',    '1',    '1'  ),
     (  '-',    '0',    '*',    '-',    '0',    '0',    '0'  ),
     (  '-',    '*',    '0',    '-',    '-',    '-',    'S'  ),
     (  '-',    '-',    '0',    '0',    '*',    '1',    '1'  ),
     (  '-',    '1',    '-',    '0',    '*',    '1',    '1'  ),
     (  '-',    '-',    '0',    '*',    '0',    '0',    '0'  ),
     (  '-',    '0',    '-',    '*',    '0',    '0',    '0'  ),
     (  '-',    '0',    '-',    '-',    '0',    '0',    '0'  ),
     (  '-',    '1',    '-',    '0',    '-',    '1',    '1'  ),
     (  '-',    '*',    '-',    '-',    '-',    '-',    'X'  ),
     (  '-',    '-',    '-',    '*',    '-',    '-',    'X'  ),
     (  '-',    '-',    '-',    '-',    '*',    '-',    'X'  ),
     (  '-',    'B',    'r',    '0',    '0',    '-',    'X'  ),
     (  '-',    'B',    'X',    '0',    '0',    '-',    'S'  ),
     (  '-',    '-',    'S',    '-',    '-',    '-',    'S'  ) );

CONSTANT udp_rslat : VitalStateTableType (1 TO 12, 1 TO 5) := (
--      NOT      R       S      Q(t)  Q(t+1)
     (  'X',    '-',    '-',    '-',    'X'  ),
     (  '-',    '-',    '1',    '-',    '1'  ),
     (  '-',    '1',    '0',    '-',    '0'  ),
     (  '-',    '0',    '-',    '1',    '1'  ),
     (  '-',    '-',    '0',    '0',    '0'  ),
     (  '-',    '-',    '-',    '-',    'S'  ),
     (  '-',    '0',    '*',    '1',    '1'  ),
     (  '-',    '*',    '0',    '0',    '0'  ),
     (  '-',    '-',    '0',    '0',    '0'  ),
     (  '-',    '0',    '-',    '1',    '1'  ),
     (  '-',    '*',    '-',    '-',    'X'  ),
     (  '-',    '-',    '*',    '-',    'X'  ) );


end prim;

package body prim is

end prim;
LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity AND2X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.335241 ns, 0.243067 ns);
             tpd_B_Y : VitalDelayType01 := (0.341203 ns, 0.249226 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of AND2X1 : entity is TRUE;
end AND2X1;

architecture behavioral of AND2X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalAND2(A_ipd, B_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity AND2X2 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.061801 ns, 0.064675 ns);
             tpd_B_Y : VitalDelayType01 := (0.0615099 ns, 0.0700575 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of AND2X2 : entity is TRUE;
end AND2X2;

architecture behavioral of AND2X2 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalAND2(A_ipd, B_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity AOI21X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_C : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.366123 ns, 0.202405 ns);
             tpd_B_Y : VitalDelayType01 := (0.360918 ns, 0.204079 ns);
             tpd_C_Y : VitalDelayType01 := (0.307952 ns, 0.227488 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         C : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of AOI21X1 : entity is TRUE;
end AOI21X1;

architecture behavioral of AOI21X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';
   SIGNAL C_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
   VitalWireDelay( C_ipd, C, tipd_C );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd, C_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE n1_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalAND2(A_ipd, B_ipd);
          n1_var := VitalOR2(n0_var, C_ipd);
          Y_zd := VitalINV(n1_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE),
                      2 => ( C_ipd'LAST_EVENT,
                             tpd_C_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity AOI22X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_C : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_D : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.341706 ns, 0.211527 ns);
             tpd_B_Y : VitalDelayType01 := (0.337339 ns, 0.210324 ns);
             tpd_C_Y : VitalDelayType01 := (0.32125 ns, 0.19844 ns);
             tpd_D_Y : VitalDelayType01 := (0.316696 ns, 0.199983 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         C : in std_ulogic := 'U' ;
         D : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of AOI22X1 : entity is TRUE;
end AOI22X1;

architecture behavioral of AOI22X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';
   SIGNAL C_ipd : std_ulogic := 'X';
   SIGNAL D_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
   VitalWireDelay( C_ipd, C, tipd_C );
   VitalWireDelay( D_ipd, D, tipd_D );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd, C_ipd, D_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE n1_var : std_ulogic;
      VARIABLE n2_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalAND2(C_ipd, D_ipd);
          n1_var := VitalAND2(A_ipd, B_ipd);
          n2_var := VitalOR2(n0_var, n1_var);
          Y_zd := VitalINV(n2_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE),
                      2 => ( C_ipd'LAST_EVENT,
                             tpd_C_Y,
                             TRUE),
                      3 => ( D_ipd'LAST_EVENT,
                             tpd_D_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity BUFX2 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.0639432 ns, 0.0618965 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of BUFX2 : entity is TRUE;
end BUFX2;

architecture behavioral of BUFX2 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
END BLOCK;

VITALBehavior : PROCESS (A_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalBUF(A_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity BUFX4 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.0476551 ns, 0.0696413 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of BUFX4 : entity is TRUE;
end BUFX4;

architecture behavioral of BUFX4 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
END BLOCK;

VITALBehavior : PROCESS (A_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalBUF(A_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity CLKBUF1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.121822 ns, 0.104436 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of CLKBUF1 : entity is TRUE;
end CLKBUF1;

architecture behavioral of CLKBUF1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
END BLOCK;

VITALBehavior : PROCESS (A_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalBUF(A_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity CLKBUF2 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.143843 ns, 0.127188 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of CLKBUF2 : entity is TRUE;
end CLKBUF2;

architecture behavioral of CLKBUF2 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
END BLOCK;

VITALBehavior : PROCESS (A_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalBUF(A_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity CLKBUF3 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.16682 ns, 0.150093 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of CLKBUF3 : entity is TRUE;
end CLKBUF3;

architecture behavioral of CLKBUF3 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
END BLOCK;

VITALBehavior : PROCESS (A_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalBUF(A_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity DFFNEGX1 is
   generic (
             tipd_CLK : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             ticd_CLK : VitalDelayType := DefDummyIcd;
             tipd_D : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tisd_D_CLK : VitalDelayType := DefDummyIsd;
             tsetup_D_CLK_posedge_negedge : VitalDelayType := 0.0937499 ns;
             tsetup_D_CLK_negedge_negedge : VitalDelayType := 0.0937499 ns;
             thold_D_CLK_posedge_negedge : VitalDelayType := -0.00000000216744 ns;
             thold_D_CLK_negedge_negedge : VitalDelayType := 0 ns;
             tpw_CLK_posedge : VitalDelayType := 0.0404763 ns;
             tpw_CLK_negedge : VitalDelayType := 0.127802 ns;
             tpd_CLK_Q_negedge : VitalDelayType01 := (0.215846 ns, 0.188439 ns);

             TimingChecksOn : BOOLEAN := false;
             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         CLK : in std_ulogic := 'U' ;
         D : in std_ulogic := 'U' ;
         Q : out std_ulogic);

   attribute VITAL_LEVEL0 of DFFNEGX1 : entity is TRUE;
end DFFNEGX1;

architecture behavioral of DFFNEGX1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL CLK_dly : std_ulogic := 'X';
   SIGNAL CLK_ipd : std_ulogic := 'X';
   SIGNAL D_dly : std_ulogic := 'X';
   SIGNAL D_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( CLK_ipd, CLK, tipd_CLK );
   VitalWireDelay( D_ipd, D, tipd_D );
END BLOCK;

SIGNALDELAY : BLOCK
BEGIN
   VitalSignalDelay( CLK_dly, CLK_ipd, ticd_CLK );
   VitalSignalDelay( D_dly, D_ipd, tisd_D_CLK );
END BLOCK;

VITALBehavior : PROCESS (CLK_dly, D_dly)

      --timing checks section variables
      VARIABLE Tviol_D_CLK : std_ulogic := '0';
      VARIABLE TimeMarker_D_CLK : VitalTimingDataType := VitalTimingDataInit;
      VARIABLE PWviol_CLK : std_ulogic := '0';
      VARIABLE PeriodCheckInfo_CLK : VitalPeriodDataType;

      -- functionality section variables
      VARIABLE intclk : std_ulogic;
      VARIABLE n0_RN_dly : std_ulogic := '0';
      VARIABLE n0_SN_dly : std_ulogic := '0';
      VARIABLE DS0000 : std_ulogic;
      VARIABLE P0000 : std_ulogic;
      VARIABLE n0_vec : std_logic_vector( 1 TO 1 );
      VARIABLE PrevData_udp_dff_n0 : std_logic_vector( 0 TO 4 );
      VARIABLE Q_zd : std_ulogic;
      VARIABLE NOTIFIER : std_ulogic := '0';

      -- path delay section variables
      VARIABLE Q_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Timing checks section
          IF (TimingChecksOn) THEN

                VitalSetupHoldCheck (
                    TestSignal     => D_dly,
                    TestSignalName => "D",
                    RefSignal      => CLK_dly,
                    RefSignalName  => "CLK",
                    SetupHigh      => tsetup_D_CLK_posedge_negedge,
                    SetupLow       => tsetup_D_CLK_negedge_negedge,
                    HoldHigh       => thold_D_CLK_posedge_negedge,
                    HoldLow        => thold_D_CLK_negedge_negedge,
                    CheckEnabled   => TRUE,
                    RefTransition  => 'F',
                    HeaderMsg      => InstancePath & "/DFFNEGX1",
                    TimingData     => TimeMarker_D_CLK,
                    Violation      => Tviol_D_CLK,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalPeriodPulseCheck (
                    TestSignal     => CLK_dly,
                    TestSignalName => "CLK",
                    Period         => 0 ps,
                    PulseWidthHigh => tpw_CLK_posedge,
                    PulseWidthLow  => tpw_CLK_negedge,
                    PeriodData     => PeriodCheckInfo_CLK,
                    Violation      => PWviol_CLK,
                    HeaderMsg      => InstancePath & "/DFFNEGX1",
                    CheckEnabled   => TRUE,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

          END IF;


          -- Functionality section
          NOTIFIER := (
                        Tviol_D_CLK OR
                        PWviol_CLK );

          intclk := VitalINV(CLK_dly);

          n0_RN_dly := '0';

          n0_SN_dly := '0';

          VitalStateTable ( StateTable => udp_dff,
                                DataIn => (NOTIFIER, D_dly, intclk, n0_RN_dly, n0_SN_dly),
                             NumStates => 1,
                                Result => n0_vec,
                        PreviousDataIn => PrevData_udp_dff_n0 );

          DS0000 := n0_vec(1);

          P0000 := VitalINV(DS0000);

          Q_zd := VitalBUF(DS0000);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Q,
               OutSignalName => "Q",
               OutTemp => Q_zd,
               Paths => (
                      0 => ( CLK_dly'LAST_EVENT,
                             tpd_CLK_Q_negedge,
                             To_X01(CLK_dly) /= '1')),
               GlitchData => Q_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity DFFPOSX1 is
   generic (
             tipd_CLK : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             ticd_CLK : VitalDelayType := DefDummyIcd;
             tipd_D : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tisd_D_CLK : VitalDelayType := DefDummyIsd;
             tsetup_D_CLK_posedge_posedge : VitalDelayType := 0.0937499 ns;
             tsetup_D_CLK_negedge_posedge : VitalDelayType := 0.0937499 ns;
             thold_D_CLK_posedge_posedge : VitalDelayType := 0 ns;
             thold_D_CLK_negedge_posedge : VitalDelayType := 0.00000000216744 ns;
             tpw_CLK_posedge : VitalDelayType := 0.129905 ns;
             tpw_CLK_negedge : VitalDelayType := 0.0554379 ns;
             tpd_CLK_Q_posedge : VitalDelayType01 := (0.218831 ns, 0.200897 ns);

             TimingChecksOn : BOOLEAN := false;
             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         CLK : in std_ulogic := 'U' ;
         D : in std_ulogic := 'U' ;
         Q : out std_ulogic);

   attribute VITAL_LEVEL0 of DFFPOSX1 : entity is TRUE;
end DFFPOSX1;

architecture behavioral of DFFPOSX1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL CLK_dly : std_ulogic := 'X';
   SIGNAL CLK_ipd : std_ulogic := 'X';
   SIGNAL D_dly : std_ulogic := 'X';
   SIGNAL D_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( CLK_ipd, CLK, tipd_CLK );
   VitalWireDelay( D_ipd, D, tipd_D );
END BLOCK;

SIGNALDELAY : BLOCK
BEGIN
   VitalSignalDelay( CLK_dly, CLK_ipd, ticd_CLK );
   VitalSignalDelay( D_dly, D_ipd, tisd_D_CLK );
END BLOCK;

VITALBehavior : PROCESS (CLK_dly, D_dly)

      --timing checks section variables
      VARIABLE Tviol_D_CLK : std_ulogic := '0';
      VARIABLE TimeMarker_D_CLK : VitalTimingDataType := VitalTimingDataInit;
      VARIABLE PWviol_CLK : std_ulogic := '0';
      VARIABLE PeriodCheckInfo_CLK : VitalPeriodDataType;

      -- functionality section variables
      VARIABLE intclk : std_ulogic;
      VARIABLE n0_RN_dly : std_ulogic := '0';
      VARIABLE n0_SN_dly : std_ulogic := '0';
      VARIABLE DS0000 : std_ulogic;
      VARIABLE P0000 : std_ulogic;
      VARIABLE n0_vec : std_logic_vector( 1 TO 1 );
      VARIABLE PrevData_udp_dff_n0 : std_logic_vector( 0 TO 4 );
      VARIABLE Q_zd : std_ulogic;
      VARIABLE NOTIFIER : std_ulogic := '0';

      -- path delay section variables
      VARIABLE Q_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Timing checks section
          IF (TimingChecksOn) THEN

                VitalSetupHoldCheck (
                    TestSignal     => D_dly,
                    TestSignalName => "D",
                    RefSignal      => CLK_dly,
                    RefSignalName  => "CLK",
                    SetupHigh      => tsetup_D_CLK_posedge_posedge,
                    SetupLow       => tsetup_D_CLK_negedge_posedge,
                    HoldHigh       => thold_D_CLK_posedge_posedge,
                    HoldLow        => thold_D_CLK_negedge_posedge,
                    CheckEnabled   => TRUE,
                    RefTransition  => 'R',
                    HeaderMsg      => InstancePath & "/DFFPOSX1",
                    TimingData     => TimeMarker_D_CLK,
                    Violation      => Tviol_D_CLK,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalPeriodPulseCheck (
                    TestSignal     => CLK_dly,
                    TestSignalName => "CLK",
                    Period         => 0 ps,
                    PulseWidthHigh => tpw_CLK_posedge,
                    PulseWidthLow  => tpw_CLK_negedge,
                    PeriodData     => PeriodCheckInfo_CLK,
                    Violation      => PWviol_CLK,
                    HeaderMsg      => InstancePath & "/DFFPOSX1",
                    CheckEnabled   => TRUE,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

          END IF;


          -- Functionality section
          NOTIFIER := (
                        Tviol_D_CLK OR
                        PWviol_CLK );

          intclk := VitalBUF(CLK_dly);

          n0_RN_dly := '0';

          n0_SN_dly := '0';

          VitalStateTable ( StateTable => udp_dff,
                                DataIn => (NOTIFIER, D_dly, intclk, n0_RN_dly, n0_SN_dly),
                             NumStates => 1,
                                Result => n0_vec,
                        PreviousDataIn => PrevData_udp_dff_n0 );

          DS0000 := n0_vec(1);

          P0000 := VitalINV(DS0000);

          Q_zd := VitalBUF(DS0000);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Q,
               OutSignalName => "Q",
               OutTemp => Q_zd,
               Paths => (
                      0 => ( CLK_dly'LAST_EVENT,
                             tpd_CLK_Q_posedge,
                             To_X01(CLK_dly) /= '0')),
               GlitchData => Q_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity DFFSR is
   generic (
             tipd_CLK : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             ticd_CLK : VitalDelayType := DefDummyIcd;
             tipd_D : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tisd_D_CLK : VitalDelayType := DefDummyIsd;
             tipd_R : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tisd_R_CLK : VitalDelayType := DefDummyIsd;
             tipd_S : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tisd_S_CLK : VitalDelayType := DefDummyIsd;
             trecovery_R_S_posedge_posedge : VitalDelayType := 0 ns;
             trecovery_R_CLK_posedge_posedge : VitalDelayType := 0 ns;
             tremoval_R_CLK_posedge_posedge : VitalDelayType := 0.1875 ns;
             trecovery_S_R_posedge_posedge : VitalDelayType := 0.0937499 ns;
             trecovery_S_CLK_posedge_posedge : VitalDelayType := 0 ns;
             tremoval_S_CLK_posedge_posedge : VitalDelayType := 0.0937499 ns;
             tsetup_D_CLK_posedge_posedge : VitalDelayType := 0.0937499 ns;
             tsetup_D_CLK_negedge_posedge : VitalDelayType := 0.0937499 ns;
             thold_D_CLK_posedge_posedge : VitalDelayType := 0 ns;
             thold_D_CLK_negedge_posedge : VitalDelayType := 0.00000000216744 ns;
             tpw_CLK_posedge : VitalDelayType := 0.262012 ns;
             tpw_CLK_negedge : VitalDelayType := 0.125679 ns;
             tpw_S_negedge : VitalDelayType := 0.214412 ns;
             tpw_R_negedge : VitalDelayType := 0.14159 ns;
             tremoval_S_R_posedge_posedge : VitalDelayType := VitalZeroDelay;
             tremoval_R_S_posedge_posedge : VitalDelayType := VitalZeroDelay;
             tpd_CLK_Q_posedge : VitalDelayType01 := (0.425419 ns, 0.320966 ns);
             tpd_R_Q_negedge : VitalDelayType01 := (0 ns, 0.260231 ns);
             tpd_R_Q_posedge : VitalDelayType01 := (0.348445 ns, 0 ns);
             tpd_S_Q_negedge : VitalDelayType01 := (0.397458 ns, 0 ns);

             TimingChecksOn : BOOLEAN := false;
             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         CLK : in std_ulogic := 'U' ;
         D : in std_ulogic := 'U' ;
         R : in std_ulogic := 'U' ;
         S : in std_ulogic := 'U' ;
         Q : out std_ulogic);

   attribute VITAL_LEVEL0 of DFFSR : entity is TRUE;
end DFFSR;

architecture behavioral of DFFSR is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL CLK_dly : std_ulogic := 'X';
   SIGNAL CLK_ipd : std_ulogic := 'X';
   SIGNAL D_dly : std_ulogic := 'X';
   SIGNAL D_ipd : std_ulogic := 'X';
   SIGNAL R_dly : std_ulogic := 'X';
   SIGNAL R_ipd : std_ulogic := 'X';
   SIGNAL S_dly : std_ulogic := 'X';
   SIGNAL S_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( CLK_ipd, CLK, tipd_CLK );
   VitalWireDelay( D_ipd, D, tipd_D );
   VitalWireDelay( R_ipd, R, tipd_R );
   VitalWireDelay( S_ipd, S, tipd_S );
END BLOCK;

SIGNALDELAY : BLOCK
BEGIN
   VitalSignalDelay( CLK_dly, CLK_ipd, ticd_CLK );
   VitalSignalDelay( D_dly, D_ipd, tisd_D_CLK );
   VitalSignalDelay( R_dly, R_ipd, tisd_R_CLK );
   VitalSignalDelay( S_dly, S_ipd, tisd_S_CLK );
END BLOCK;

VITALBehavior : PROCESS (CLK_dly, D_dly, R_dly, S_dly)

      --timing checks section variables
      VARIABLE Tviol_rec_R_S_posedge : std_ulogic := '0';
      VARIABLE TimeMarker_rec_R_S_posedge : VitalTimingDataType := VitalTimingDataInit;
      VARIABLE Tviol_rec_CLK_S_posedge : std_ulogic := '0';
      VARIABLE TimeMarker_rec_CLK_S_posedge : VitalTimingDataType := VitalTimingDataInit;
      VARIABLE Tviol_rec_S_R_posedge : std_ulogic := '0';
      VARIABLE TimeMarker_rec_S_R_posedge : VitalTimingDataType := VitalTimingDataInit;
      VARIABLE Tviol_rec_CLK_R_posedge : std_ulogic := '0';
      VARIABLE TimeMarker_rec_CLK_R_posedge : VitalTimingDataType := VitalTimingDataInit;
      VARIABLE Tviol_D_CLK : std_ulogic := '0';
      VARIABLE TimeMarker_D_CLK : VitalTimingDataType := VitalTimingDataInit;
      VARIABLE PWviol_S_negedge : std_ulogic := '0';
      VARIABLE PeriodCheckInfo_S_negedge : VitalPeriodDataType;
      VARIABLE PWviol_R_negedge : std_ulogic := '0';
      VARIABLE PeriodCheckInfo_R_negedge : VitalPeriodDataType;
      VARIABLE PWviol_CLK : std_ulogic := '0';
      VARIABLE PeriodCheckInfo_CLK : VitalPeriodDataType;

      -- functionality section variables
      VARIABLE intclk : std_ulogic;
      VARIABLE n0_CLEAR : std_ulogic;
      VARIABLE n0_SET : std_ulogic;
      VARIABLE P0002 : std_ulogic;
      VARIABLE P0003 : std_ulogic;
      VARIABLE D_dly_t : std_ulogic;
      VARIABLE n0_vec : std_logic_vector( 1 TO 1 );
      VARIABLE PrevData_udp_dff_n0 : std_logic_vector( 0 TO 4 );
      VARIABLE Q_zd : std_ulogic;
      VARIABLE D_EQ_1_AN_S_EQ_1 : std_ulogic;
      VARIABLE n1_var : std_ulogic;
      VARIABLE D_EQ_0_AN_R_EQ_1 : std_ulogic;
      VARIABLE S_EQ_1_AN_R_EQ_1 : std_ulogic;
      VARIABLE NOTIFIER : std_ulogic := '0';

      -- path delay section variables
      VARIABLE Q_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Timing checks section
          IF (TimingChecksOn) THEN

                VitalRecoveryRemovalCheck (
                    TestSignal     => S_dly,
                    TestSignalName => "S",
                    RefSignal      => R_dly,
                    RefSignalName  => "R",
                    Recovery       => trecovery_S_R_posedge_posedge,
                    Removal        => tremoval_S_R_posedge_posedge,
                    CheckEnabled   => TRUE,
                    ActiveLow      => TRUE,
                    RefTransition  => 'R',
                    HeaderMsg      => InstancePath & "/DFFSR",
                    TimingData     => TimeMarker_rec_R_S_posedge,
                    Violation      => Tviol_rec_R_S_posedge,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalRecoveryRemovalCheck (
                    TestSignal     => S_dly,
                    TestSignalName => "S",
                    RefSignal      => CLK_dly,
                    RefSignalName  => "CLK",
                    Recovery       => trecovery_S_CLK_posedge_posedge,
                    Removal        => tremoval_S_CLK_posedge_posedge,
                    CheckEnabled   => To_X01(D_EQ_0_AN_R_EQ_1) /= '0',
                    ActiveLow      => TRUE,
                    RefTransition  => 'R',
                    HeaderMsg      => InstancePath & "/DFFSR",
                    TimingData     => TimeMarker_rec_CLK_S_posedge,
                    Violation      => Tviol_rec_CLK_S_posedge,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalRecoveryRemovalCheck (
                    TestSignal     => R_dly,
                    TestSignalName => "R",
                    RefSignal      => S_dly,
                    RefSignalName  => "S",
                    Recovery       => trecovery_R_S_posedge_posedge,
                    Removal        => tremoval_R_S_posedge_posedge,
                    CheckEnabled   => TRUE,
                    ActiveLow      => TRUE,
                    RefTransition  => 'R',
                    HeaderMsg      => InstancePath & "/DFFSR",
                    TimingData     => TimeMarker_rec_S_R_posedge,
                    Violation      => Tviol_rec_S_R_posedge,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalRecoveryRemovalCheck (
                    TestSignal     => R_dly,
                    TestSignalName => "R",
                    RefSignal      => CLK_dly,
                    RefSignalName  => "CLK",
                    Recovery       => trecovery_R_CLK_posedge_posedge,
                    Removal        => tremoval_R_CLK_posedge_posedge,
                    CheckEnabled   => To_X01(D_EQ_1_AN_S_EQ_1) /= '0',
                    ActiveLow      => TRUE,
                    RefTransition  => 'R',
                    HeaderMsg      => InstancePath & "/DFFSR",
                    TimingData     => TimeMarker_rec_CLK_R_posedge,
                    Violation      => Tviol_rec_CLK_R_posedge,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalSetupHoldCheck (
                    TestSignal     => D_dly,
                    TestSignalName => "D",
                    RefSignal      => CLK_dly,
                    RefSignalName  => "CLK",
                    SetupHigh      => tsetup_D_CLK_posedge_posedge,
                    SetupLow       => tsetup_D_CLK_negedge_posedge,
                    HoldHigh       => thold_D_CLK_posedge_posedge,
                    HoldLow        => thold_D_CLK_negedge_posedge,
                    CheckEnabled   => To_X01(S_EQ_1_AN_R_EQ_1) /= '0',
                    RefTransition  => 'R',
                    HeaderMsg      => InstancePath & "/DFFSR",
                    TimingData     => TimeMarker_D_CLK,
                    Violation      => Tviol_D_CLK,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalPeriodPulseCheck (
                    TestSignal     => S_dly,
                    TestSignalName => "S",
                    Period         => 0 ps,
                    PulseWidthHigh => 0 ns,
                    PulseWidthLow  => tpw_S_negedge,
                    PeriodData     => PeriodCheckInfo_S_negedge,
                    Violation      => PWviol_S_negedge,
                    HeaderMsg      => InstancePath & "/DFFSR",
                    CheckEnabled   => TRUE,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalPeriodPulseCheck (
                    TestSignal     => R_dly,
                    TestSignalName => "R",
                    Period         => 0 ps,
                    PulseWidthHigh => 0 ns,
                    PulseWidthLow  => tpw_R_negedge,
                    PeriodData     => PeriodCheckInfo_R_negedge,
                    Violation      => PWviol_R_negedge,
                    HeaderMsg      => InstancePath & "/DFFSR",
                    CheckEnabled   => TRUE,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalPeriodPulseCheck (
                    TestSignal     => CLK_dly,
                    TestSignalName => "CLK",
                    Period         => 0 ps,
                    PulseWidthHigh => tpw_CLK_posedge,
                    PulseWidthLow  => tpw_CLK_negedge,
                    PeriodData     => PeriodCheckInfo_CLK,
                    Violation      => PWviol_CLK,
                    HeaderMsg      => InstancePath & "/DFFSR",
                    CheckEnabled   => TRUE,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

          END IF;


          -- Functionality section
          NOTIFIER := (
                        Tviol_rec_R_S_posedge OR
                        Tviol_rec_CLK_S_posedge OR
                        Tviol_rec_S_R_posedge OR
                        Tviol_rec_CLK_R_posedge OR
                        Tviol_D_CLK OR
                        PWviol_S_negedge OR
                        PWviol_R_negedge OR
                        PWviol_CLK );

          intclk := VitalBUF(CLK_dly);

          n0_CLEAR := VitalINV(R_dly);

          n0_SET := VitalINV(S_dly);

          D_dly_t := VitalINV(D_dly);

          VitalStateTable ( StateTable => udp_dff,
                                DataIn => (NOTIFIER, D_dly_t, intclk, n0_SET, n0_CLEAR),
                             NumStates => 1,
                                Result => n0_vec,
                        PreviousDataIn => PrevData_udp_dff_n0 );

          P0003 := n0_vec(1);

          P0002 := VitalINV(P0003);

          Q_zd := VitalBUF(P0002);

          D_EQ_1_AN_S_EQ_1 := VitalAND2(D_dly, S_dly);

          n1_var := VitalINV(D_dly);
          D_EQ_0_AN_R_EQ_1 := VitalAND2(n1_var, R_dly);

          S_EQ_1_AN_R_EQ_1 := VitalAND2(S_dly, R_dly);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Q,
               OutSignalName => "Q",
               OutTemp => Q_zd,
               Paths => (
                      0 => ( CLK_dly'LAST_EVENT,
                             tpd_CLK_Q_posedge,
                             To_X01(CLK_dly) /= '0'),
                      1 => ( R_dly'LAST_EVENT,
                             tpd_R_Q_negedge,
                             To_X01(R_dly) /= '1'),
                      2 => ( R_dly'LAST_EVENT,
                             tpd_R_Q_posedge,
                             To_X01(R_dly) /= '0'),
                      3 => ( S_dly'LAST_EVENT,
                             tpd_S_Q_negedge,
                             To_X01(S_dly) /= '1')),
               GlitchData => Q_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity FAX1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_C : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_YC : VitalDelayType01 := (0.360088 ns, 0.284056 ns);
             tpd_A_YS : VitalDelayType01 := (0.385604 ns, 0.289139 ns);
             tpd_B_YC : VitalDelayType01 := (0.360796 ns, 0.282487 ns);
             tpd_B_YS : VitalDelayType01 := (0.381334 ns, 0.288096 ns);
             tpd_C_YC : VitalDelayType01 := (0.357997 ns, 0.275687 ns);
             tpd_C_YS : VitalDelayType01 := (0.374129 ns, 0.282399 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         C : in std_ulogic := 'U' ;
         YC : out std_ulogic ;
         YS : out std_ulogic);

   attribute VITAL_LEVEL0 of FAX1 : entity is TRUE;
end FAX1;

architecture behavioral of FAX1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';
   SIGNAL C_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
   VitalWireDelay( C_ipd, C, tipd_C );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd, C_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE n1_var : std_ulogic;
      VARIABLE n2_var : std_ulogic;
      VARIABLE n3_var : std_ulogic;
      VARIABLE YC_zd : std_ulogic;
      VARIABLE n4_var : std_ulogic;
      VARIABLE YS_zd : std_ulogic;

      -- path delay section variables
      VARIABLE YC_GlitchData : VitalGlitchDataType;
      VARIABLE YS_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalAND2(A_ipd, B_ipd);
          n1_var := VitalAND2(B_ipd, C_ipd);
          n2_var := VitalOR2(n0_var, n1_var);
          n3_var := VitalAND2(C_ipd, A_ipd);
          YC_zd := VitalOR2(n2_var, n3_var);

          n4_var := VitalXOR2(A_ipd, B_ipd);
          YS_zd := VitalXOR2(n4_var, C_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => YC,
               OutSignalName => "YC",
               OutTemp => YC_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_YC,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_YC,
                             TRUE),
                      2 => ( C_ipd'LAST_EVENT,
                             tpd_C_YC,
                             TRUE)),
               GlitchData => YC_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );

          VitalPathDelay01(
               OutSignal     => YS,
               OutSignalName => "YS",
               OutTemp => YS_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_YS,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_YS,
                             TRUE),
                      2 => ( C_ipd'LAST_EVENT,
                             tpd_C_YS,
                             TRUE)),
               GlitchData => YS_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity HAX1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_YC : VitalDelayType01 := (0.344948 ns, 0.261591 ns);
             tpd_A_YS : VitalDelayType01 := (0.362799 ns, 0.264331 ns);
             tpd_B_YC : VitalDelayType01 := (0.345539 ns, 0.256117 ns);
             tpd_B_YS : VitalDelayType01 := (0.3572 ns, 0.258583 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         YC : out std_ulogic ;
         YS : out std_ulogic);

   attribute VITAL_LEVEL0 of HAX1 : entity is TRUE;
end HAX1;

architecture behavioral of HAX1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd)


      -- functionality section variables
      VARIABLE YS_zd : std_ulogic;
      VARIABLE YC_zd : std_ulogic;

      -- path delay section variables
      VARIABLE YC_GlitchData : VitalGlitchDataType;
      VARIABLE YS_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          YS_zd := VitalXOR2(A_ipd, B_ipd);

          YC_zd := VitalAND2(A_ipd, B_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => YC,
               OutSignalName => "YC",
               OutTemp => YC_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_YC,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_YC,
                             TRUE)),
               GlitchData => YC_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );

          VitalPathDelay01(
               OutSignal     => YS,
               OutSignalName => "YS",
               OutTemp => YS_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_YS,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_YS,
                             TRUE)),
               GlitchData => YS_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity INVX1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.334383 ns, 0.22935 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of INVX1 : entity is TRUE;
end INVX1;

architecture behavioral of INVX1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
END BLOCK;

VITALBehavior : PROCESS (A_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalINV(A_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity INVX2 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.0535923 ns, 0.0390769 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of INVX2 : entity is TRUE;
end INVX2;

architecture behavioral of INVX2 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
END BLOCK;

VITALBehavior : PROCESS (A_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalINV(A_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity INVX4 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.0542471 ns, 0.0399682 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of INVX4 : entity is TRUE;
end INVX4;

architecture behavioral of INVX4 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
END BLOCK;

VITALBehavior : PROCESS (A_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalINV(A_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity INVX8 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.0542926 ns, 0.0399237 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of INVX8 : entity is TRUE;
end INVX8;

architecture behavioral of INVX8 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
END BLOCK;

VITALBehavior : PROCESS (A_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalINV(A_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity LATCH is
   generic (
             tipd_CLK : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             ticd_CLK : VitalDelayType := DefDummyIcd;
             tipd_D : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tisd_D_CLK : VitalDelayType := DefDummyIsd;
             tsetup_D_CLK_posedge_negedge : VitalDelayType := 0.1875 ns;
             tsetup_D_CLK_negedge_negedge : VitalDelayType := 0.1875 ns;
             thold_D_CLK_posedge_negedge : VitalDelayType := -0.00000000216744 ns;
             thold_D_CLK_negedge_negedge : VitalDelayType := 0 ns;
             tpw_CLK_posedge : VitalDelayType := 0.110989 ns;
             tpd_CLK_Q_posedge : VitalDelayType01 := (0.197405 ns, 0.168677 ns);
             tpd_D_Q : VitalDelayType01 := (0.204494 ns, 0.178792 ns);

             TimingChecksOn : BOOLEAN := false;
             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         CLK : in std_ulogic := 'U' ;
         D : in std_ulogic := 'U' ;
         Q : out std_ulogic);

   attribute VITAL_LEVEL0 of LATCH : entity is TRUE;
end LATCH;

architecture behavioral of LATCH is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL CLK_dly : std_ulogic := 'X';
   SIGNAL CLK_ipd : std_ulogic := 'X';
   SIGNAL D_dly : std_ulogic := 'X';
   SIGNAL D_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( CLK_ipd, CLK, tipd_CLK );
   VitalWireDelay( D_ipd, D, tipd_D );
END BLOCK;

SIGNALDELAY : BLOCK
BEGIN
   VitalSignalDelay( CLK_dly, CLK_ipd, ticd_CLK );
   VitalSignalDelay( D_dly, D_ipd, tisd_D_CLK );
END BLOCK;

VITALBehavior : PROCESS (CLK_dly, D_dly)

      --timing checks section variables
      VARIABLE Tviol_D_CLK : std_ulogic := '0';
      VARIABLE TimeMarker_D_CLK : VitalTimingDataType := VitalTimingDataInit;
      VARIABLE PWviol_CLK_posedge : std_ulogic := '0';
      VARIABLE PeriodCheckInfo_CLK_posedge : VitalPeriodDataType;

      -- functionality section variables
      VARIABLE n0_RN_dly : std_ulogic := '0';
      VARIABLE n0_SN_dly : std_ulogic := '0';
      VARIABLE DS0000 : std_ulogic;
      VARIABLE P0000 : std_ulogic;
      VARIABLE n0_vec : std_logic_vector( 1 TO 1 );
      VARIABLE PrevData_udp_tlat_n0 : std_logic_vector( 0 TO 4 );
      VARIABLE Q_zd : std_ulogic;
      VARIABLE NOTIFIER : std_ulogic := '0';

      -- path delay section variables
      VARIABLE Q_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Timing checks section
          IF (TimingChecksOn) THEN

                VitalSetupHoldCheck (
                    TestSignal     => D_dly,
                    TestSignalName => "D",
                    RefSignal      => CLK_dly,
                    RefSignalName  => "CLK",
                    SetupHigh      => tsetup_D_CLK_posedge_negedge,
                    SetupLow       => tsetup_D_CLK_negedge_negedge,
                    HoldHigh       => thold_D_CLK_posedge_negedge,
                    HoldLow        => thold_D_CLK_negedge_negedge,
                    CheckEnabled   => TRUE,
                    RefTransition  => 'F',
                    HeaderMsg      => InstancePath & "/LATCH",
                    TimingData     => TimeMarker_D_CLK,
                    Violation      => Tviol_D_CLK,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

                VitalPeriodPulseCheck (
                    TestSignal     => CLK_dly,
                    TestSignalName => "CLK",
                    Period         => 0 ps,
                    PulseWidthHigh => tpw_CLK_posedge,
                    PulseWidthLow  => 0 ns,
                    PeriodData     => PeriodCheckInfo_CLK_posedge,
                    Violation      => PWviol_CLK_posedge,
                    HeaderMsg      => InstancePath & "/LATCH",
                    CheckEnabled   => TRUE,
                    XOn            => DefSeqXOn,
                    MsgOn          => DefSeqMsgOn,
                    MsgSeverity    => WARNING );

          END IF;


          -- Functionality section
          NOTIFIER := (
                        Tviol_D_CLK OR
                        PWviol_CLK_posedge );

          n0_RN_dly := '0';

          n0_SN_dly := '0';

          VitalStateTable ( StateTable => udp_tlat,
                                DataIn => (NOTIFIER, D_dly, CLK_dly, n0_RN_dly, n0_SN_dly),
                             NumStates => 1,
                                Result => n0_vec,
                        PreviousDataIn => PrevData_udp_tlat_n0 );

          DS0000 := n0_vec(1);

          P0000 := VitalINV(DS0000);

          Q_zd := VitalBUF(DS0000);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Q,
               OutSignalName => "Q",
               OutTemp => Q_zd,
               Paths => (
                      0 => ( CLK_dly'LAST_EVENT,
                             tpd_CLK_Q_posedge,
                             To_X01(CLK_dly) /= '0'),
                      1 => ( D_dly'LAST_EVENT,
                             tpd_D_Q,
                             TRUE)),
               GlitchData => Q_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity MUX2X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_S : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.371168 ns, 0.205438 ns);
             tpd_B_Y : VitalDelayType01 := (0.372994 ns, 0.204202 ns);
             tpd_S_Y : VitalDelayType01 := (0.365381 ns, 0.2111 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         S : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of MUX2X1 : entity is TRUE;
end MUX2X1;

architecture behavioral of MUX2X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';
   SIGNAL S_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
   VitalWireDelay( S_ipd, S, tipd_S );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd, S_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalMUX2(A_ipd, B_ipd, S_ipd);
          Y_zd := VitalINV(n0_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE),
                      2 => ( S_ipd'LAST_EVENT,
                             tpd_S_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity NAND2X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.345107 ns, 0.196856 ns);
             tpd_B_Y : VitalDelayType01 := (0.336319 ns, 0.19685 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of NAND2X1 : entity is TRUE;
end NAND2X1;

architecture behavioral of NAND2X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalAND2(A_ipd, B_ipd);
          Y_zd := VitalINV(n0_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity NAND3X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_C : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.354578 ns, 0.187007 ns);
             tpd_B_Y : VitalDelayType01 := (0.350956 ns, 0.186309 ns);
             tpd_C_Y : VitalDelayType01 := (0.345234 ns, 0.185511 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         C : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of NAND3X1 : entity is TRUE;
end NAND3X1;

architecture behavioral of NAND3X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';
   SIGNAL C_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
   VitalWireDelay( C_ipd, C, tipd_C );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd, C_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE n1_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalAND2(A_ipd, B_ipd);
          n1_var := VitalAND2(n0_var, C_ipd);
          Y_zd := VitalINV(n1_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE),
                      2 => ( C_ipd'LAST_EVENT,
                             tpd_C_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity NOR2X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.359749 ns, 0.232749 ns);
             tpd_B_Y : VitalDelayType01 := (0.355257 ns, 0.227842 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of NOR2X1 : entity is TRUE;
end NOR2X1;

architecture behavioral of NOR2X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalOR2(A_ipd, B_ipd);
          Y_zd := VitalINV(n0_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity NOR3X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_C : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.387203 ns, 0.249178 ns);
             tpd_B_Y : VitalDelayType01 := (0.378956 ns, 0.24302 ns);
             tpd_C_Y : VitalDelayType01 := (0.36077 ns, 0.234046 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         C : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of NOR3X1 : entity is TRUE;
end NOR3X1;

architecture behavioral of NOR3X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';
   SIGNAL C_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
   VitalWireDelay( C_ipd, C, tipd_C );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd, C_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE n1_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalOR2(A_ipd, B_ipd);
          n1_var := VitalOR2(n0_var, C_ipd);
          Y_zd := VitalINV(n1_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE),
                      2 => ( C_ipd'LAST_EVENT,
                             tpd_C_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity OAI21X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_C : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.369203 ns, 0.201265 ns);
             tpd_B_Y : VitalDelayType01 := (0.365136 ns, 0.198267 ns);
             tpd_C_Y : VitalDelayType01 := (0.340702 ns, 0.177778 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         C : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of OAI21X1 : entity is TRUE;
end OAI21X1;

architecture behavioral of OAI21X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';
   SIGNAL C_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
   VitalWireDelay( C_ipd, C, tipd_C );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd, C_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE n1_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalOR2(A_ipd, B_ipd);
          n1_var := VitalAND2(n0_var, C_ipd);
          Y_zd := VitalINV(n1_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE),
                      2 => ( C_ipd'LAST_EVENT,
                             tpd_C_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity OAI22X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_C : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_D : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.377949 ns, 0.188768 ns);
             tpd_B_Y : VitalDelayType01 := (0.374067 ns, 0.183907 ns);
             tpd_C_Y : VitalDelayType01 := (0.368706 ns, 0.185444 ns);
             tpd_D_Y : VitalDelayType01 := (0.36175 ns, 0.181201 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         C : in std_ulogic := 'U' ;
         D : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of OAI22X1 : entity is TRUE;
end OAI22X1;

architecture behavioral of OAI22X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';
   SIGNAL C_ipd : std_ulogic := 'X';
   SIGNAL D_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
   VitalWireDelay( C_ipd, C, tipd_C );
   VitalWireDelay( D_ipd, D, tipd_D );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd, C_ipd, D_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE n1_var : std_ulogic;
      VARIABLE n2_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalOR2(C_ipd, D_ipd);
          n1_var := VitalOR2(A_ipd, B_ipd);
          n2_var := VitalAND2(n0_var, n1_var);
          Y_zd := VitalINV(n2_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE),
                      2 => ( C_ipd'LAST_EVENT,
                             tpd_C_Y,
                             TRUE),
                      3 => ( D_ipd'LAST_EVENT,
                             tpd_D_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity OR2X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.342477 ns, 0.243741 ns);
             tpd_B_Y : VitalDelayType01 := (0.352883 ns, 0.252976 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of OR2X1 : entity is TRUE;
end OR2X1;

architecture behavioral of OR2X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalOR2(A_ipd, B_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity OR2X2 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.0693921 ns, 0.0656425 ns);
             tpd_B_Y : VitalDelayType01 := (0.0764625 ns, 0.0744664 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of OR2X2 : entity is TRUE;
end OR2X2;

architecture behavioral of OR2X2 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalOR2(A_ipd, B_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity TBUFX1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_EN : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.365569 ns, 0.203276 ns);
             tpd_EN_Y : VitalDelayType01Z := (VitalZeroDelay, VitalZeroDelay, 0.0107727 ns, 0.356689 ns, 0.0272097 ns, 0.195231 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         EN : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of TBUFX1 : entity is TRUE;
end TBUFX1;

architecture behavioral of TBUFX1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL EN_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( EN_ipd, EN, tipd_EN );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, EN_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalINV(A_ipd);
          Y_zd := VitalBUFIF1(n0_var, EN_ipd);


          -- Path delay section
          VitalPathDelay01Z(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             VitalExtendToFillDelay(tpd_A_Y),
                             TRUE),
                      1 => ( EN_ipd'LAST_EVENT,
                             VitalExtendToFillDelay(tpd_EN_Y),
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity TBUFX2 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_EN : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.0690322 ns, 0.0420601 ns);
             tpd_EN_Y : VitalDelayType01Z := (VitalZeroDelay, VitalZeroDelay, 0.0107727 ns, 0.0573587 ns, 0.0252425 ns, 0.0362576 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         EN : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of TBUFX2 : entity is TRUE;
end TBUFX2;

architecture behavioral of TBUFX2 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL EN_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( EN_ipd, EN, tipd_EN );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, EN_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalINV(A_ipd);
          Y_zd := VitalBUFIF1(n0_var, EN_ipd);


          -- Path delay section
          VitalPathDelay01Z(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             VitalExtendToFillDelay(tpd_A_Y),
                             TRUE),
                      1 => ( EN_ipd'LAST_EVENT,
                             VitalExtendToFillDelay(tpd_EN_Y),
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity XNOR2X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.360659 ns, 0.206292 ns);
             tpd_B_Y : VitalDelayType01 := (0.371926 ns, 0.210513 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of XNOR2X1 : entity is TRUE;
end XNOR2X1;

architecture behavioral of XNOR2X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd)


      -- functionality section variables
      VARIABLE n0_var : std_ulogic;
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          n0_var := VitalXOR2(A_ipd, B_ipd);
          Y_zd := VitalINV(n0_var);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.prim.all;

entity XOR2X1 is
   generic (
             tipd_A : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tipd_B : VitalDelayType01 := (DefDummyIpd, DefDummyIpd);
             tpd_A_Y : VitalDelayType01 := (0.358317 ns, 0.20642 ns);
             tpd_B_Y : VitalDelayType01 := (0.372178 ns, 0.210108 ns);

             XOn            : BOOLEAN := DefCombSpikeXOn;
             MsgOn          : BOOLEAN := DefCombSpikeMsgOn;
             instancePath   : STRING  := "*" );

   port (
         A : in std_ulogic := 'U' ;
         B : in std_ulogic := 'U' ;
         Y : out std_ulogic);

   attribute VITAL_LEVEL0 of XOR2X1 : entity is TRUE;
end XOR2X1;

architecture behavioral of XOR2X1 is
   attribute VITAL_LEVEL1 of behavioral : architecture is TRUE;

   SIGNAL A_ipd : std_ulogic := 'X';
   SIGNAL B_ipd : std_ulogic := 'X';

begin

--Input Path Delays
WIREDELAY : BLOCK
BEGIN
   VitalWireDelay( A_ipd, A, tipd_A );
   VitalWireDelay( B_ipd, B, tipd_B );
END BLOCK;

VITALBehavior : PROCESS (A_ipd, B_ipd)


      -- functionality section variables
      VARIABLE Y_zd : std_ulogic;

      -- path delay section variables
      VARIABLE Y_GlitchData : VitalGlitchDataType;

      BEGIN
          -- Functionality section
          Y_zd := VitalXOR2(A_ipd, B_ipd);


          -- Path delay section
          VitalPathDelay01(
               OutSignal     => Y,
               OutSignalName => "Y",
               OutTemp => Y_zd,
               Paths => (
                      0 => ( A_ipd'LAST_EVENT,
                             tpd_A_Y,
                             TRUE),
                      1 => ( B_ipd'LAST_EVENT,
                             tpd_B_Y,
                             TRUE)),
               GlitchData => Y_GlitchData,
               Mode  => OnEvent,
               XOn            => XOn,
               MsgOn          => MsgOn,
               MsgSeverity    => WARNING );


END PROCESS;

end behavioral;


