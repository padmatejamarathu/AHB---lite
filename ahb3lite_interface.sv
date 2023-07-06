import Definitions::*;
interface ahb3lite_bus (input HCLK, HRESETn);
	//address
	logic [ADDRWIDTH-1:0] HADDR;
	
	//data
	logic [DATAWIDTH-1:0] HWDATA, HRDATA;
	
	//control signals
	logic HWRITE, HMASTLOCK, HREADY;
	
	//type of transfer
	BType_t HBURST;
	Trans_t HTRANS;
	Response_t HRESP;
	logic [3:0] HPROT;
	logic [2:0] HSIZE;
	
	//for driver
	modport master_driver ( input HRDATA, HRESP, output HADDR, HWDATA, HSIZE, HBURST, HTRANS, HWRITE, HMASTLOCK, HREADY, HPROT);
	
	//for monitor
	modport slave_monitor ( input HRDATA, HRESP, HADDR, HWDATA, HSIZE, HBURST, HTRANS, HWRITE, HMASTLOCK, HREADY, HPROT);
	
	modport master ( input HRDATA, HRESP, output HADDR, HWDATA, HSIZE, HBURST, HTRANS, HWRITE, HMASTLOCK, HREADY, HPROT);
	
	clocking cb @(posedge HCLK);
		input #1ns HRDATA;
	endclocking
	
	task pre;
	@(posedge HCLK)
	if(HRESETn == 0);
	begin
		HADDR <= '0;
		HSIZE <= '0;
		HWDATA <= '0;
		HBURST <= SINGLE;
		HTRANS <= IDLE;
		HWRITE <= '0;
		HMASTLOCK <= '0;
		HREADY <= '0;
		HPROT <= '0;
	end
	endtask
endinterface