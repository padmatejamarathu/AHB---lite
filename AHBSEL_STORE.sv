//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : AHBSEL_STORE.sv : Used to store HADDR select pin for one clock cycle for mux input               //
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


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// The default data transfer takes two cycles in AHBLite. Data is tranferred in second cycle .So to store the HSEL 
// this module is used which have input from decode and output to Mux
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AHBSEL_STORE
(

input  logic HCLK, HRESETn,
input  logic DECODE2MUX,       // Output from Decoder
output logic MUXin);

always_ff @ (posedge HCLK)
begin

	if (!HRESETn)
	begin
		MUXin <= 'z;
	end
	
	else
	begin
		MUXin <= DECODE2MUX;
	end

end
endmodule	
      
