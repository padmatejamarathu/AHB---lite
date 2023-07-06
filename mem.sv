//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : mem.sv : memory module used as slave1 for AHBLite RTL Design                                     //
// Subject   : Introduction to SystemVerilog [ECE 571]                                                          //
// Term      : Winter 2018                                                                                      //
// Project   : AHBLite RTL Design and Verification using Emulator                                               //
// Authors   : Aarti R. | Ashwini K. | Kushal S. | Suprita K.                                                   //
// Guide     : Roy Kravitz                                                                                      //
// Date      : 02/21/2018                                                                                       //
// Revision  :                                                                                                  //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////




module mem
#(
	parameter SLAVE_ADDRWIDTH = 8,
	parameter SLAVE_DATAWIDTH = 8
)
(
	input	logic						clk,	 // clock (this is a synchronous memory)
	input   logic                                           HRESETn,
	input	logic						rdEn,	 // Asserted high to read the memory
	input	logic						wrEn,	 // Asserted high to write the memory
	input	logic	[SLAVE_ADDRWIDTH-1:0]		        Addr,    // Address to read or write
	input	logic   [SLAVE_DATAWIDTH-1:0]		        Datai,   // 
	output	logic   [SLAVE_DATAWIDTH-1:0]		        Datao	 // 
);

localparam MEMDEPTH = 2 ** SLAVE_ADDRWIDTH;

// declare internal variables
logic	[SLAVE_DATAWIDTH-1:0]		M[MEMDEPTH];		// memory array
//logic   [SLAVE_DATAWIDTH-1:0]           out;   

// continously read Data[Addr]
// this is OK because we drive the actual Data bus with a tristate buffer
//always_comb begin	
//	Datao = M[Addr];
//end

//initial
//begin
 //for (int i=0;i<MEMDEPTH;i++)
  //              begin
   //                     M[i]= '0;
   //             end
//end



always_comb
begin
if ((wrEn == 1'b0) && (rdEn == 1'b1))
	begin
	Datao  = M[Addr];
	//$display("READ.....................\n");
	end

else
	Datao = 'bz;

end


// write a location in memory
always @(posedge clk) 
begin
	
	
	if ((wrEn == 1'b1) && (rdEn == 1'b0))
	begin
		M[Addr] <= Datai;
	//	Datao   <= 'bz;
	//	$display("MEMORY WRITE\n");
		
	end

	else
	begin
		
		M[Addr] <= M[Addr];
		//$display("NOTHING");
	
	end


	

end // write a location in memory

endmodule
