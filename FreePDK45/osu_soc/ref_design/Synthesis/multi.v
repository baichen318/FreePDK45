//Ivan Castellanos

module multi (P, A, B);

   input [7:0] A;
   input [7:0] B;

   output [15:0] P;

//row b0
	wire	wa10,wa20,wa30,wa40,wa50,wa60,wn70;

//row b1
	wire	wmhc01,wmhc11,wmhc21,wmhc31,wmhc41,wmhc51,wmhc61;
	wire	wmhs11,wmhs21,wmhs31,wmhs41,wmhs51,wmhs61,wn71;

//row b2
	wire	wmfc02,wmfc12,wmfc22,wmfc32,wmfc42,wmfc52,wmfc62;
	wire	wmfs12,wmfs22,wmfs32,wmfs42,wmfs52,wmfs62,wn72;

//row b3
	wire	wmfc03,wmfc13,wmfc23,wmfc33,wmfc43,wmfc53,wmfc63;
	wire	wmfs13,wmfs23,wmfs33,wmfs43,wmfs53,wmfs63,wn73;

//row b4
	wire	wmfc04,wmfc14,wmfc24,wmfc34,wmfc44,wmfc54,wmfc64;
	wire	wmfs14,wmfs24,wmfs34,wmfs44,wmfs54,wmfs64,wn74;

//row b5
	wire	wmfc05,wmfc15,wmfc25,wmfc35,wmfc45,wmfc55,wmfc65;
	wire	wmfs15,wmfs25,wmfs35,wmfs45,wmfs55,wmfs65,wn75;

//row b6
	wire	wmfc06,wmfc16,wmfc26,wmfc36,wmfc46,wmfc56,wmfc66;
	wire	wmfs16,wmfs26,wmfs36,wmfs46,wmfs56,wmfs66,wn76;

//row b7
	wire	wnmfc07,wnmfc17,wnmfc27,wnmfc37,wnmfc47,wnmfc57,wnmfc67;
	wire	wnmfs17,wnmfs27,wnmfs37,wnmfs47,wnmfs57,wnmfs67,wa77;

//row b8
	wire	wfac08,wfac18,wfac28,wfac38,wfac48,wfac58,wfac68;

//Row bo Implementation

	and	a00(P[0] , A[0], B[0]);
	and	a10(wa10 ,A[1], B[0]);
	and	a20(wa20 ,A[2], B[0]);
	and	a30(wa30 ,A[3], B[0]);
	and	a40(wa40 ,A[4], B[0]);
	and	a50(wa50 ,A[5], B[0]);
	and	a60(wa60 ,A[6], B[0]);
	nand	n70(wn70 ,A[7], B[0]);

//Row b1

	MHA     mha01(.Sum(P[1]), .Cout(wmhc01), .A(A[0]), .B(B[1]), .Sin(wa10));
	MHA     mha11(.Sum(wmhs11), .Cout(wmhc11), .A(A[1]), .B(B[1]), .Sin(wa20));
	MHA     mha21(.Sum(wmhs21), .Cout(wmhc21), .A(A[2]), .B(B[1]), .Sin(wa30));
	MHA     mha31(.Sum(wmhs31), .Cout(wmhc31), .A(A[3]), .B(B[1]), .Sin(wa40));
	MHA     mha41(.Sum(wmhs41), .Cout(wmhc41), .A(A[4]), .B(B[1]), .Sin(wa50));
	MHA     mha51(.Sum(wmhs51), .Cout(wmhc51), .A(A[5]), .B(B[1]), .Sin(wa60));
	MHA     mha61(.Sum(wmhs61), .Cout(wmhc61), .A(A[6]), .B(B[1]), .Sin(wn70));
	nand	n71(wn71, A[7], B[1]);

//Row b2

	MFA 	mfa02(.Sum(P[2]), .Cout(wmfc02), .A(A[0]), .B(B[2]), .Sin(wmhs11), .Cin(wmhc01));
	MFA 	mfa12(.Sum(wmfs12), .Cout(wmfc12), .A(A[1]), .B(B[2]), .Sin(wmhs21), .Cin(wmhc11));
	MFA 	mfa22(.Sum(wmfs22), .Cout(wmfc22), .A(A[2]), .B(B[2]), .Sin(wmhs31), .Cin(wmhc21));
	MFA 	mfa32(.Sum(wmfs32), .Cout(wmfc32), .A(A[3]), .B(B[2]), .Sin(wmhs41), .Cin(wmhc31));
	MFA 	mfa42(.Sum(wmfs42), .Cout(wmfc42), .A(A[4]), .B(B[2]), .Sin(wmhs51), .Cin(wmhc41));
	MFA 	mfa52(.Sum(wmfs52), .Cout(wmfc52), .A(A[5]), .B(B[2]), .Sin(wmhs61), .Cin(wmhc51));
	MFA 	mfa62(.Sum(wmfs62), .Cout(wmfc62), .A(A[6]), .B(B[2]), .Sin(wn71), .Cin(wmhc61));
	nand	n72(wn72, A[7], B[2]);

//Row b3

	MFA 	mfa03(.Sum(P[3]), .Cout(wmfc03), .A(A[0]), .B(B[3]), .Sin(wmfs12), .Cin(wmfc02));
	MFA 	mfa13(.Sum(wmfs13), .Cout(wmfc13), .A(A[1]), .B(B[3]), .Sin(wmfs22), .Cin(wmfc12));
	MFA 	mfa23(.Sum(wmfs23), .Cout(wmfc23), .A(A[2]), .B(B[3]), .Sin(wmfs32), .Cin(wmfc22));
	MFA 	mfa33(.Sum(wmfs33), .Cout(wmfc33), .A(A[3]), .B(B[3]), .Sin(wmfs42), .Cin(wmfc32));
	MFA 	mfa43(.Sum(wmfs43), .Cout(wmfc43), .A(A[4]), .B(B[3]), .Sin(wmfs52), .Cin(wmfc42));
	MFA 	mfa53(.Sum(wmfs53), .Cout(wmfc53), .A(A[5]), .B(B[3]), .Sin(wmfs62), .Cin(wmfc52));
	MFA 	mfa63(.Sum(wmfs63), .Cout(wmfc63), .A(A[6]), .B(B[3]), .Sin(wn72), .Cin(wmfc62));
	nand	n73(wn73, A[7], B[3]);
	
//Row b4

	MFA 	mfa04(.Sum(P[4]), .Cout(wmfc04), .A(A[0]), .B(B[4]), .Sin(wmfs13), .Cin(wmfc03));
	MFA 	mfa14(.Sum(wmfs14), .Cout(wmfc14), .A(A[1]), .B(B[4]), .Sin(wmfs23), .Cin(wmfc13));
	MFA 	mfa24(.Sum(wmfs24), .Cout(wmfc24), .A(A[2]), .B(B[4]), .Sin(wmfs33), .Cin(wmfc23));
	MFA 	mfa34(.Sum(wmfs34), .Cout(wmfc34), .A(A[3]), .B(B[4]), .Sin(wmfs43), .Cin(wmfc33));
	MFA 	mfa44(.Sum(wmfs44), .Cout(wmfc44), .A(A[4]), .B(B[4]), .Sin(wmfs53), .Cin(wmfc43));
	MFA 	mfa54(.Sum(wmfs54), .Cout(wmfc54), .A(A[5]), .B(B[4]), .Sin(wmfs63), .Cin(wmfc53));
	MFA 	mfa64(.Sum(wmfs64), .Cout(wmfc64), .A(A[6]), .B(B[4]), .Sin(wn73), .Cin(wmfc63));
	nand	n74(wn74, A[7], B[4]);
	
//Row b5

	MFA 	mfa05(.Sum(P[5]), .Cout(wmfc05), .A(A[0]), .B(B[5]), .Sin(wmfs14), .Cin(wmfc04));
	MFA 	mfa15(.Sum(wmfs15), .Cout(wmfc15), .A(A[1]), .B(B[5]), .Sin(wmfs24), .Cin(wmfc14));
	MFA 	mfa25(.Sum(wmfs25), .Cout(wmfc25), .A(A[2]), .B(B[5]), .Sin(wmfs34), .Cin(wmfc24));
	MFA 	mfa35(.Sum(wmfs35), .Cout(wmfc35), .A(A[3]), .B(B[5]), .Sin(wmfs44), .Cin(wmfc34));
	MFA 	mfa45(.Sum(wmfs45), .Cout(wmfc45), .A(A[4]), .B(B[5]), .Sin(wmfs54), .Cin(wmfc44));
	MFA 	mfa55(.Sum(wmfs55), .Cout(wmfc55), .A(A[5]), .B(B[5]), .Sin(wmfs64), .Cin(wmfc54));
	MFA 	mfa65(.Sum(wmfs65), .Cout(wmfc65), .A(A[6]), .B(B[5]), .Sin(wn74), .Cin(wmfc64));
	nand	n75(wn75, A[7], B[5]);
	
//Row b6

	MFA 	mfa06(.Sum(P[6]), .Cout(wmfc06), .A(A[0]), .B(B[6]), .Sin(wmfs15), .Cin(wmfc05));
	MFA 	mfa16(.Sum(wmfs16), .Cout(wmfc16), .A(A[1]), .B(B[6]), .Sin(wmfs25), .Cin(wmfc15));
	MFA 	mfa26(.Sum(wmfs26), .Cout(wmfc26), .A(A[2]), .B(B[6]), .Sin(wmfs35), .Cin(wmfc25));
	MFA 	mfa36(.Sum(wmfs36), .Cout(wmfc36), .A(A[3]), .B(B[6]), .Sin(wmfs45), .Cin(wmfc35));
	MFA 	mfa46(.Sum(wmfs46), .Cout(wmfc46), .A(A[4]), .B(B[6]), .Sin(wmfs55), .Cin(wmfc45));
	MFA 	mfa56(.Sum(wmfs56), .Cout(wmfc56), .A(A[5]), .B(B[6]), .Sin(wmfs65), .Cin(wmfc55));
	MFA 	mfa66(.Sum(wmfs66), .Cout(wmfc66), .A(A[6]), .B(B[6]), .Sin(wn75), .Cin(wmfc65));
	nand	n76(wn76, A[7], B[6]);

//Row b7

	NMFA 	nmfa07(.Sum(P[7]), .Cout(wnmfc07), .A(A[0]), .B(B[7]), .Sin(wmfs16), .Cin(wmfc06));
	NMFA 	nmfa17(.Sum(wnmfs17), .Cout(wnmfc17), .A(A[1]), .B(B[7]), .Sin(wmfs26), .Cin(wmfc16));
	NMFA 	nmfa27(.Sum(wnmfs27), .Cout(wnmfc27), .A(A[2]), .B(B[7]), .Sin(wmfs36), .Cin(wmfc26));
	NMFA 	nmfa37(.Sum(wnmfs37), .Cout(wnmfc37), .A(A[3]), .B(B[7]), .Sin(wmfs46), .Cin(wmfc36));
	NMFA 	nmfa47(.Sum(wnmfs47), .Cout(wnmfc47), .A(A[4]), .B(B[7]), .Sin(wmfs56), .Cin(wmfc46));
	NMFA 	nmfa57(.Sum(wnmfs57), .Cout(wnmfc57), .A(A[5]), .B(B[7]), .Sin(wmfs66), .Cin(wmfc56));
	NMFA 	nmfa67(.Sum(wnmfs67), .Cout(wnmfc67), .A(A[6]), .B(B[7]), .Sin(wn76), .Cin(wmfc66));
	and	a77(wa77, A[7], B[7]);

//Row b8

	FA 	fa08(.Sum(P[8]), .Cout(wfac08), .A(wnmfc07), .B(wnmfs17), .Cin(1'b1));
	FA 	fa18(.Sum(P[9]), .Cout(wfac18), .A(wnmfc17), .B(wnmfs27), .Cin(wfac08));
	FA 	fa28(.Sum(P[10]), .Cout(wfac28), .A(wnmfc27), .B(wnmfs37), .Cin(wfac18));
	FA 	fa38(.Sum(P[11]), .Cout(wfac38), .A(wnmfc37), .B(wnmfs47), .Cin(wfac28));
	FA 	fa48(.Sum(P[12]), .Cout(wfac48), .A(wnmfc47), .B(wnmfs57), .Cin(wfac38));
	FA 	fa58(.Sum(P[13]), .Cout(wfac58), .A(wnmfc57), .B(wnmfs67), .Cin(wfac48));
	FA 	fa68(.Sum(P[14]), .Cout(wfac68), .A(wnmfc67), .B(wa77), .Cin(wfac58));

	not	inv1(P[15], wfac68);

endmodule // multi
