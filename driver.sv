`include "generator.sv"
`include "ahb3lite_interface.sv"
`define drv_vif vif.master_driver

/*class driver;
	//interface
	virtual ahb3lite_bus vif;

		
	//mailbox
	mailbox #(transaction) drv_mbx;

	//events
	event drv_done;
	event task_over;
	
	//driver count
	static int unsigned drv_count;

	//custom constructor
	function new(virtual ahb3lite_bus vif, mailbox #(transaction) drv_mbx, event drv_done, task_over);
		this.vif = vif;
		this.drv_mbx = drv_mbx;
		this.drv_done = drv_done;
		this.task_over = task_over;
	endfunction

	task run();
		logic [31:0] prev_HWDATA;
		@(posedge vif.HCLK);
			forever
			fork
				transaction trans;
				drv_mbx.get(trans);
				prev_HWDATA = trans.HWDATA;
				@(posedge vif.HCLK)
				`drv_vif.HADDR = trans.HADDR;
				`drv_vif.HWDATA = prev_HWDATA;
				`drv_vif.HSIZE = trans.HSIZE;
				`drv_vif.HBURST = trans.HBURST;
				`drv_vif.HTRANS = trans.HTRANS;
				`drv_vif.HWRITE = trans.HWRITE;
				`drv_vif.HMASTLOCK = trans.HMASTLOCK;
				`drv_vif.HREADY = trans.HREADY;
				`drv_vif.HPROT = trans.HPROT;
				trans.print("Driver");
				drv_count ++;
				->drv_done;
			join
		endtask
endclass : driver */


/*class driver;
	//interface
	virtual ahb3lite_bus vif;

		
	//mailbox
	mailbox #(transaction) drv_mbx;

	//events
	event drv_done;
	event task_over;
	
	//driver count
	static int unsigned drv_count;

	//custom constructor
	function new(virtual ahb3lite_bus vif, mailbox #(transaction) drv_mbx, event drv_done, task_over);
		this.vif = vif;
		this.drv_mbx = drv_mbx;
		this.drv_done = drv_done;
		this.task_over = task_over;
	endfunction

	task run();
		static logic [31:0] prev_HADDR;
		static logic prev_HWRITE, prev_HMASTLOCK, prev_HREADY;
		static BType_t prev_HBURST;
		static Trans_t prev_HTRANS;
		static logic [3:0] prev_HPROT;
		static logic [2:0] prev_HSIZE;
		@(posedge vif.HCLK);
			forever
			begin
				fork
					transaction trans;
					drv_mbx.get(trans);
					prev_HADDR <= trans.HADDR;
					prev_HWRITE <= trans.HWRITE;
					prev_HMASTLOCK <= trans.HMASTLOCK;
					prev_HREADY <= trans.HREADY;
					prev_HPROT <= trans.HPROT;
					prev_HSIZE <= trans.HSIZE;
					prev_HBURST <= trans.HBURST;
					prev_HTRANS <= trans.HTRANS;
					@(posedge vif.HCLK)
					`drv_vif.HADDR <= prev_HADDR;
					`drv_vif.HWDATA <= trans.HWDATA;
					`drv_vif.HSIZE <= prev_HSIZE;
					`drv_vif.HBURST <= prev_HBURST;
					`drv_vif.HTRANS <= prev_HTRANS;
					`drv_vif.HWRITE <= prev_HWRITE;
					`drv_vif.HMASTLOCK <= prev_HMASTLOCK;
					`drv_vif.HREADY <= prev_HREADY;
					`drv_vif.HPROT <= prev_HPROT;
					trans.print("Driver");
					drv_count ++;
					->drv_done;
				join
			end
		endtask
endclass : driver*/

class driver;
	//interface
	virtual ahb3lite_bus vif;

		
	//mailbox
	mailbox #(transaction) drv_mbx;

	//events
	event drv_done;
	event task_over;
	
	//driver count
	static int unsigned drv_count;

	//custom constructor
	function new(virtual ahb3lite_bus vif, mailbox #(transaction) drv_mbx, event drv_done);
		this.vif = vif;
		this.drv_mbx = drv_mbx;
		this.drv_done = drv_done;
	endfunction

	task run();
		static logic [31:0] prev_HWDATA;
			forever
			begin
					transaction trans;
					drv_mbx.get(trans);
					@(posedge vif.HCLK)
					prev_HWDATA <= trans.HWDATA;
					`drv_vif.HADDR <= trans.HADDR;
					`drv_vif.HWDATA <= prev_HWDATA;
					`drv_vif.HSIZE <= trans.HSIZE;
					`drv_vif.HBURST <= trans.HBURST;
					`drv_vif.HTRANS <= trans.HTRANS;
					`drv_vif.HWRITE <= trans.HWRITE;
					`drv_vif.HMASTLOCK <= trans.HMASTLOCK;
					`drv_vif.HREADY <= trans.HREADY;
					`drv_vif.HPROT <= trans.HPROT;
					//$display("start");
					//trans.print("Driver");
					drv_count ++;
					->drv_done;
			end
		endtask
endclass : driver