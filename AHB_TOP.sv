//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : AHB_TOP.sv : Module used for instantiatiing Slave_controller, mux and decoder in one             //
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

module AHB_TOP
(
input  logic                          HCLK, HRESETn,
input  logic   [DATAWIDTH-1:0]        HWDATA,
input  logic   [ADDRWIDTH-1:0]        HADDR,
input  logic   [DATATRANFER_SIZE-1:0] HSIZE,
input  BType_t                        HBURST,
input  Trans_t                        HTRANS,
input  logic                          HWRITE, HMASTLOCK, HREADY,
input  logic   [3:0]                  HPROT,
    
output logic   [DATAWIDTH-1:0]        HRDATA,
//input  logic                          HREADY, 
output Response_t                     HRESP);

logic                                 HADDR2SEL;
logic                                 DECODE2MUX;
logic                                 MUXin;
logic                                 HSEL_S1, HSEL_S2;
Response_t                                 HRESP_1, HRESP_2;
logic  [DATAWIDTH-1:0]                HRDATA_1, HRDATA_2, HRDATA_out;                              
logic                                 HREADYOUT_1, HREADYOUT_2;


   
assign HADDR2SEL = HADDR[8];  
assign HRDATA = HRDATA_out;         


// Instantiation for different modules for AHB_Lite module

AHB_DECODER decode1    (.DECODERin    (HADDR2SEL),          // In  for decode1 coming from Master
                        .HSEL_S1      (HSEL_S1),            // Out for decode1 going  to   slave1
						.HSEL_S2      (HSEL_S2),            // Out for decode1 going  to   slave2
						.DECODE2MUX   (DECODE2MUX));        // Out for decode1 going  to   AHBSEL_STORE
						
AHBSEL_STORE selstore  (.HCLK         (HCLK),               // In  for selstore
                        .HRESETn      (HRESETn),            // In  for selstore
						.DECODE2MUX   (DECODE2MUX),         // In  for selstore coming from decode1
						.MUXin        (MUXin));             // Out for selstore going  to   mux1 

AMBA_MUX mux1           (.MUX_SEL      (MUXin),              // In  for mux1 coming from AHBSEL_STORE
						.HRDATA_1     (HRDATA_1),           // In  for mux1 coming form slave1      
						.HRDATA_2     (HRDATA_2),           // In  for mux1 coming from slave2
						.HRESP_1      (HRESP_1),            // In  for mux1 coming form slave1
						.HRESP_2      (HRESP_2),            // In  for mux1 coming form slave2
						.HREADYOUT_1  (HREADYOUT_1),        // In  for mux1 coming form slave1
						.HREADYOUT_2  (HREADYOUT_2),        // In  for mux1 coming form slave2
						.HRDATA_out   (HRDATA_out),         // Out for mux1 going  to   Master
						.HRESP_out    (HRESP),              // Out for mux1 going  to   Master
						.HREADY_out   ());                  // Signal coming form Master

memController slave1   (.HCLK         (HCLK),               // In  for slave1  
						.HRESETn      (HRESETn),            // In  for slave1
						.HSEL         (HSEL_S1),            // In  for slave1 coming form decode1 
						.HADDR        (HADDR),              // In  for slave1
						.HWDATA       (HWDATA),             // In  for slave1
						.HWRITE       (HWRITE),             // In  for slave1
						.HMASTLOCK    (HMASTLOCK),          // In  for slave1 
						.HREADY       (HREADY),             // In  for slave1
						.HTRANS       (HTRANS),             // In  for slave1
						.HSIZE        (HSIZE),              // In  for slave1
   						.HBURST		  (HBURST),             // In  for slave1
						.HPROT        (HPROT),              // In  for slave1
						.HRESP        (HRESP_1),            // Out for slave1 going to mux1 
						.HREADYOUT    (HREADYOUT_1),        // Out for slave1 goign to mux1
						.HRDATA       (HRDATA_1));          // Out for slave1 going to mux1 

memController slave2    (.HCLK        (HCLK),               // In  for slave2 
						.HRESETn      (HRESETn),            // In  for slave2
						.HSEL         (HSEL_S2),            // In  for slave2 coming from decode1
						.HADDR        (HADDR),              // In  for slave2
						.HWDATA       (HWDATA),             // In  for slave2
						.HWRITE       (HWRITE),             // In  for slave2
						.HMASTLOCK    (HMASTLOCK),          // In  for slave2
						.HREADY       (HREADY),             // In  for slave2
						.HTRANS       (HTRANS),             // In  for slave2
						.HSIZE        (HSIZE),              // In  for slave2
						.HBURST		  (HBURST),             // In  for slave2
						.HPROT        (HPROT),              // In  for slave2
						.HRESP        (HRESP_2),            // Out for slave2 going to mux1 
						.HREADYOUT    (HREADYOUT_2),        // Out for slave2 going to mux1 
						.HRDATA       (HRDATA_2));          // Out for slave2 going to mux1  

endmodule
