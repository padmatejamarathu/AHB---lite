`include "driver.sv"
`define mon_vif vif.slave_monitor
class monitor;
		//interface
		virtual ahb3lite_bus vif;

		//mailbox
		mailbox #(transaction) mbx;
		
		//transaction
		transaction trans;

		//monitor count
		static int unsigned mon_count;

		//event;
		event scb_mon_done;

		//custom constructor
		function new(virtual ahb3lite_bus vif,  mailbox #(transaction) mbx, event scb_mon_done);
				this.vif = vif;
				this.mbx = mbx;
				this.scb_mon_done = scb_mon_done;
		endfunction

		//run method
		task run;
			static logic [31:0] prev_HADDR, prev_HRDATA;
			static logic prev_HWRITE, prev_HMASTLOCK, prev_HREADY;
			static BType_t prev_HBURST;
			static Trans_t prev_HTRANS;
			static logic [3:0] prev_HPROT;
			static logic [2:0] prev_HSIZE;
			forever
			begin
				trans = new();
					fork
						@(posedge vif.HCLK)
						//$display("%t monitoring", $time);
						prev_HADDR <=vif.HADDR;
						prev_HSIZE <= vif.HSIZE;
						prev_HBURST <= vif.HBURST;
						prev_HTRANS <= vif.HTRANS;
						prev_HWRITE <= vif.HWRITE;
						prev_HMASTLOCK <= vif.HMASTLOCK;
						prev_HREADY <= vif.HREADY;
						prev_HPROT <= vif.HPROT;
						@(posedge vif.HCLK)
						begin
							//$display("%t monitoring", $time);
							if(prev_HWRITE == '0)
							begin
								 trans.HRDATA = vif.cb.HRDATA;
							end
							else
							begin
								trans.HWDATA =vif.HWDATA;
							end
							trans.HADDR = prev_HADDR;
							
							trans.HSIZE = prev_HSIZE;
							trans.HBURST = prev_HBURST;
							trans.HTRANS = prev_HTRANS;
							trans.HWRITE = prev_HWRITE;
							trans.HMASTLOCK = prev_HMASTLOCK;
							trans.HREADY = prev_HREADY;
							trans.HPROT = prev_HPROT;
							mon_count ++;
							trans.print("monitor");
							$display("\n\n");
						end
					join
						//trans.print("monitor");
				mbx.put(trans);
				@(scb_mon_done);
			end
		endtask
endclass
