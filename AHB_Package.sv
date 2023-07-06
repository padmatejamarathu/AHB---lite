//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Name      : AHB_Package.sv : Common Package to store common definitions for AHBLite RTL Design               //
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


package Definitions;

parameter DATAWIDTH              = 32;
parameter ADDRWIDTH              = 32;
parameter TRANS_WIDTH            = 2;
parameter DATATRANFER_SIZE       = 3;
parameter BURST_TYPE             = 3;

//logic HSEL0, HSEL1, MUX_SEL;                       // Confusion for this line existance
//logic HRESETn, HCLK;                               // Confusion for this line existance


//------------------------------------- Parameters for memory module------------------------

parameter SLAVE_DATAWIDTH = 8;
parameter SLAVE_ADDRWIDTH = 8;


//---------------------------------------Tranfer types' enumeration------------------------------------------

typedef enum 
{
IDLE   = 'b00,
BUSY   = 'b01,
NONSEQ = 'b10,
SEQ    = 'b11 
} Trans_t;


//--------------------------------------- Burst operation types enumeration----------------------------------

typedef enum 
{
SINGLE = 'b000,
INCR   = 'b001,
WRAP4  = 'b010,
INCR4  = 'b011,
WRAP8  = 'b100,
INCR8  = 'b101,
WRAP16 = 'b110,
INCR16 = 'b111
} BType_t;

//--------------------------------------- Burst Size (Bits) Enumeration---------------------------------------------



//---------------------------------------STRUCTURE for Address and Data--------------------------------------



//---------------------------------------Signal for Slave----------------------------------------------------
typedef enum 
{
OKAY  = 'b0,
ERROR = 'b1
} Response_t;
 
 
endpackage
