import Definitions::*;
class transaction;

	//input data to DUT
	static int unsigned transaction_count;
	rand logic [ADDRWIDTH-1:0] HADDR;
	rand bit [7:0] HWDATA;
	rand bit HWRITE, HMASTLOCK, HREADY;
	rand BType_t HBURST;
	rand Trans_t HTRANS;
	logic [3:0] HPROT;
	rand bit [2:0] HSIZE;
	
	//Output data to DUT
	logic [DATAWIDTH-1:0] HRDATA;
	Response_t HRESP;
	function new();
	HPROT = 4'bxxx0;
	endfunction
	constraint  hsize {HSIZE == '0;} //constraint for hsize should be 8 bits
	constraint  hready {HREADY == '1;}
	constraint  hmastlock {HMASTLOCK == '0;}
	constraint non_seq { HTRANS inside { NONSEQ};}
	constraint hburst { HBURST == SINGLE;}
	constraint hwrite { HWRITE dist {[0:1] := 5};}
	constraint bytealligned { HADDR[1:0] == '0;}
	constraint haddr { HADDR inside {8, 12};}
	constraint hsel {HADDR[7] dist {[0:1] := 5};}
	
	
    function void print(string tag = "");
$display("This is from %s at time %t HADDR == %d, HWDATA == %d, HWRITE = %d, HMASTLOCK = %d, HREADY = %d, HBURST = %d, HTRANS = %d, HPROT = %d, HSIZE = %d, HRDATA= %d, HRESP =%d", tag, $time, this.HADDR, this.HWDATA, this.HWRITE, this.HMASTLOCK, this.HREADY, this.HBURST, this.HTRANS, this.HPROT, this.HSIZE, this.HRDATA, this.HRESP);
endfunction
    
endclass : transaction