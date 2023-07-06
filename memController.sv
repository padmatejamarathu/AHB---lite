//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : memController.sv : Module used for controlling the data transfer based on AHBLite Control Signals//
// Subject   : Introduction to SystemVerilog [ECE 571]                                                          //
// Term      : Winter 2018                                                                                      //
// Project   : AHBLite RTL Design and Verification using Emulator                                               //
// Authors   : Aarti R. | Ashwini K. | Kushal S. | Suprita K.                                                   //
// Guide     : Roy Kravitz                                                                                      //
// Date      : 02/20/2018                                                                                       //
// Revision  :                                                                                                  //
// Reference :                                                                                                  //
// Portland State University                                                                                    //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import Definitions::*;

module  memController(

input  logic                            HCLK, HRESETn,
input  logic                            HSEL,
input  logic 	[ADDRWIDTH-1:0]         HADDR,
input  logic    [DATAWIDTH-1:0]         HWDATA,
input  logic 			        HWRITE, HMASTLOCK, HREADY,
input  Trans_t 			        HTRANS,
input  logic 	[DATATRANFER_SIZE-1:0]  HSIZE, 
input  BType_t                          HBURST,
input  logic    [3:0]                   HPROT,

output Response_t                            HRESP, 
output logic                       HREADYOUT,
output logic    [DATAWIDTH-1:0]         HRDATA
);

enum logic      [TRANS_WIDTH-1:0] 
{idle,busy,nonseq,seq} state_now, state_next;

BType_t			        FHBURST;
logic                                   wrEn, rdEn;
logic           [SLAVE_ADDRWIDTH-1:0]   Addr, Address;
logic           [SLAVE_DATAWIDTH-1:0]   Datai, Datao;

logic           [3:0]                   clk_cnt;
logic					hw;

mem 	#(.SLAVE_ADDRWIDTH(SLAVE_ADDRWIDTH),
	  .SLAVE_DATAWIDTH(SLAVE_DATAWIDTH))

	m1 (.clk(HCLK),
	    .HRESETn(HRESETn), 
	    .rdEn(rdEn), 
            .wrEn(wrEn), 
            .Addr(Addr), 
            .Datai(Datai), 
            .Datao(Datao)); //memory instantiation


assign HRDATA = (HREADY) ? {{24{1'b0}},Datao} : 'bz ;

//next state computing logic
always_comb begin
	unique case (state_now)
	
		idle	: begin
				  if(HTRANS==BUSY) state_next = busy;
				  else if ((HTRANS==NONSEQ)&&HSEL) state_next = nonseq;
				  else state_next = idle;
				  end
				  
		busy	: begin
		          if((HTRANS==SEQ)&& HSEL)state_next = seq;
				  else if ((HTRANS==NONSEQ)&&HSEL) state_next = nonseq;
				  else if (((HBURST==INCR)&&(HTRANS==IDLE))|| (!HSEL)) state_next = idle;
				  else  state_next = busy;
				  end
				  
		nonseq	: begin
		          if ((HTRANS==IDLE)||(!HSEL)) state_next = idle;
				  else if (HTRANS==BUSY) state_next = busy;
				  else if ((HTRANS==SEQ)&& HSEL) state_next = seq;
				  else state_next = nonseq ;
				  end
				  
	    seq		: begin
		          if ((HTRANS==BUSY)) state_next = busy;
				  else if ((HTRANS==IDLE)||(!HSEL)) state_next = idle;
				  else if ((HTRANS==NONSEQ)&&HSEL) state_next = nonseq;
				  else state_next = seq;
				  end

	   //    default	:  state_next = idle;
	endcase
end


always_comb begin
	unique case (state_now)
		idle	: begin
				{rdEn,wrEn}= 2'b00;   //idle state - no action
		        HREADYOUT=1'b1;
				HRESP=OKAY;
			    end
		busy	: begin
				{rdEn,wrEn}= 2'b00;
				HREADYOUT=1'b1;
				HRESP=OKAY;
			    end
		nonseq  : begin
					if (HREADY) begin
						Addr = Address ;
						HREADYOUT=1'b1;
				        HRESP=OKAY;
						if (hw) begin
							{rdEn,wrEn}= 2'b01;
							Datai = HWDATA[7:0] ;
						end
						else begin
							{rdEn,wrEn}= 2'b10;
							//HRDATA[7:0] = Datao ;
						end
					end
					else begin
						{rdEn,wrEn}= 2'b00;
						//HRDATA = 'z ;
					end
					
				end
		seq		:  begin
					if (HREADY) begin
						if (FHBURST == WRAP4) Addr = {Address[7:2],2'(Address[1:0]+clk_cnt[1:0]+1'b1)} ;
						else if (FHBURST == WRAP8) Addr = {Address[7:3],3'(Address[2:0]+clk_cnt[2:0]+1'b1)} ;
						else if (FHBURST == WRAP16) Addr = {Address[7:4],4'(Address[3:0]+clk_cnt[3:0]+1'b1)} ;
						else if ((FHBURST == INCR4)||(FHBURST == INCR8)||(FHBURST == INCR16)||(FHBURST == INCR)) Addr = Address + clk_cnt + 1'b1;
						else if (FHBURST == SINGLE) Addr = Address + clk_cnt + 1'b1;
						HREADYOUT=1'b1;
				        HRESP=OKAY;
						if (hw) begin
							{rdEn,wrEn}= 2'b01;
							Datai = HWDATA[7:0] ;
						end
						else begin
							{rdEn,wrEn}= 2'b10;
							//HRDATA[7:0] = Datao ;
						end
					end
					else begin
						{rdEn,wrEn}= 2'b00;
						//HRDATA = 'z ;
					end
					
				end
	//	default i:begin
	//			{rdEn,wrEn}= 2'b00;   //idle state - no action
	//	        Addr = 0;
	//			{HREADYOUT,HRESP}=2'b10;
	//		    end
	endcase
end


//state transitin flop	
always_ff @(posedge HCLK) begin
	if (!HRESETn)
		state_now <= idle;          // idle when reset
	else
		state_now <= state_next; 	//state transition


 	if (!HRESETn)
                 clk_cnt <= 0;
        else if (state_now == nonseq)
                 clk_cnt <= 0 ;
        else if ((state_now == seq)&&(HREADY!=1'b0))
                 clk_cnt <= clk_cnt + 1'b1 ;
	else 
		 clk_cnt <= clk_cnt;

	if (!HRESETn)
		Address <= 'b0;
	else if ((HTRANS == NONSEQ)&&(HREADY!=1'b0)) begin
		Address <= HADDR[7:0];
		hw <= HWRITE;
		
		end
	else begin
		Address <= Address;
		hw <= hw;
		
		end
	
	if (HTRANS == SEQ)		FHBURST <= HBURST;
	else		FHBURST <= SINGLE;
		

end

/*
always_ff @(posedge HCLK) begin
	if (!HRESETn)
		clk_cnt <= 0;
	else if (state_now == nonseq)
		clk_cnt <= 0 ; 
	else if (state_now == seq)
		clk_cnt <= clk_cnt + 1'b1 ;
end

always_ff @(posedge HCLK) begin
	if (HRESETn==0)
		Address <= 0;
	else if (HTRANS==NONSEQ)
		Address <= HADDR[7:0];
end


*/
endmodule
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
				
				
