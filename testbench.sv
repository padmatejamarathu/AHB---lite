`include "test.sv"
module testbench();
logic HCLK = 1, HRESETn;

//CLOCK GENERATION
always #10 HCLK = ~HCLK;




//Interface
ahb3lite_bus vif (HCLK, HRESETn);


//testcase
test T (vif);


//DUT instantiation
AHB_TOP DUT ( .HCLK(vif.HCLK), .HRESETn(vif.HRESETn), .HWDATA(vif.HWDATA), .HADDR(vif.HADDR), .HSIZE(vif.HSIZE), .HBURST(vif.HBURST), .HTRANS(vif.HTRANS), .HWRITE(vif.HWRITE), .HMASTLOCK(vif.HMASTLOCK), .HREADY(vif.HREADY), .HPROT(vif.HPROT), .HRDATA(vif.HRDATA), .HRESP(vif.HRESP));


initial
begin
		@(posedge HCLK) HRESETn <= '0;
		@(posedge HCLK) HRESETn <= '1;
end
endmodule
