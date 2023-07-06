//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : AHB_MUX.sv : Multiplexer module for selceting which slave ouput data should be read              //
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

module AMBA_MUX
(
input  logic                 MUX_SEL,
input  logic [DATAWIDTH-1:0] HRDATA_1, HRDATA_2,
input  Response_t            HRESP_1, HRESP_2,
input  logic                 HREADYOUT_1, HREADYOUT_2,

output logic [DATAWIDTH-1:0] HRDATA_out,
output Response_t            HRESP_out,
output logic                 HREADY_out);


always_comb
begin

	if (!MUX_SEL)
	begin
		{HRDATA_out, HRESP_out, HREADY_out} = {HRDATA_1, HRESP_1, HREADYOUT_1};
	end
	
	else
	begin
		{HRDATA_out, HRESP_out, HREADY_out} = {HRDATA_2, HRESP_2, HREADYOUT_2};
	end
end

endmodule

