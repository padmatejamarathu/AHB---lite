//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : AHB_DECODER.sv : Module used for Decoding the one bit from HADDR bus to decide HSEL for DECODER  //
// Subject   : Introduction to SystemVerilog [ECE 571]                                                          //
// Term      : Winter 2018                                                                                      //
// Project   : AHBLite RTL Design and Verification using Emulator                                               //
// Authors   : Aarti R. | Ashwini K. | Kushal S. | Suprita K.                                                   //
// Guide     : Roy Kravitz                                                                                      //
// Date      : 03/10/2018                                                                                       //
// Revision  :                                                                                                  //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import Definitions::*;

module AHB_DECODER
( 
input  logic DECODERin,    // HADDR[8] pin connected to the decoder to select one of the slaves active at one time

output logic HSEL_S1,      // input for slave_1   
output logic HSEL_S2,      // input for slave_2
output logic DECODE2MUX ); // input for MUX which will be same as HADDR[8] in this implementation

assign DECODE2MUX = DECODERin;

always_comb 
begin

	if (!DECODERin)
	begin
		{HSEL_S1, HSEL_S2} = 2'b10;
	end
	
	else
	begin	
		{HSEL_S1, HSEL_S2} = 2'b01;
	end

end
endmodule