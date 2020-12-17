Process typical{
	voltage = 1.1;
	temp = 27;
	Corner = "";
	Vtn = 0.471;
	Vtp = 0.423;
};

Signal std_cell {
	unit = REL;
	Vh=1.0 1.0;
	Vl=0.0 0.0;
	Vth=0.5 0.5;
	Vsh=0.8 0.8;
	Vsl=0.2 0.2;
	tsmax=2.0n;
};

Simulation std_cell{
	transient = 0.1n 80n 10p;
	dc = 0.1 4.5 0.1;
	bisec = 6.0n 6.0n 100p;
	resistance = 10MEG;
};

Index X1{
	Slew = 0.100n 0.30n 0.7n 1.0n 2.0n;
 	Load = 0.01p 0.02p 0.04p 0.1p;
};

Index X2{
	Slew = 0.100n 0.30n 0.7n 1.0n 2.0n;
 	Load = 0.02p 0.04p 0.08p 0.2p;
};

Index X4{
	Slew = 0.100n 0.30n 0.7n 1.0n 2.0n;
 	Load = 0.04p 0.08p 0.16p 0.4p;
};

Index X8{
	Slew = 0.100n 0.30n 0.7n 1.0n 2.0n;
 	Load = 0.08p 0.16p 0.32p 0.8p;
};

Index Clk_Slew{
	bslew = 0.100n 0.5n 1.0n;
};

Group X1{
	CELL = *x1 ;
};

Group X2{
	CELL = *X2 ;
};

Group X4{
	CELL = *X4 ;
};

Group X8{
	CELL = *X8 ;
};

Group Clk_Slew{
	PIN = *.CLK ;
};

Margin m0 {
	setup 	= 1.0 0.0 ;
	hold 	= 1.0 0.0 ;
	release = 1.0 0.0 ;
	removal = 1.0 0.0 ;
	recovery = 1.0 0.0 ;
	width	= 1.0 0.0 ;
	delay 	= 1.0 0.0 ;
	power 	= 1.0 0.0 ;
	cap 	= 1.0 0.0 ;
} ;

Nominal n0 {
	delay = 0.5 0.5 ;
	power = 0.5 0.5 ;
	cap   = 0.5 0.5 ;
} ;

set process(typical){
	simulation = std_cell;
	signal = std_cell;
	margin = m0;
	nominal = n0;
};

set index(typical){
	Group(X1) = X1;
	Group(X2) = X2;
	Group(X4) = X4;
	Group(X8) = X8;
	Group(Clk_Slew)  = Clk_Slew;
};
