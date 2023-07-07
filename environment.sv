`include "scoreboard.sv"
class environment;
		//interface
		virtual ahb3lite_bus vif;

		//mailbox
		mailbox #(transaction) gen2drv = new();
		mailbox #(transaction) mon2scb = new();

		//componenets declaration
		generator gen;
		driver drv;
		monitor mon;
		scoreboard scb;

		//events
		event drv_done;// Generator and driver synchronization
		event scb_done;// Monitor and Scoreboard synchronization

		//number of transactions
		int unsigned no_of_transactions;

		//custom Constructor
		function new(virtual ahb3lite_bus vif, int unsigned no_of_transactions);
				this.vif = vif;
				this.no_of_transactions = no_of_transactions;
		endfunction

		task build;
				gen = new(gen2drv, drv_done, no_of_transactions);
				drv = new(vif, gen2drv, drv_done);
				mon = new(vif, mon2scb, scb_done);
				scb = new(vif, mon2scb, scb_done);
		endtask
		
		
		task run;
				fork
						gen.run;
						drv.run;
						mon.run;
						scb.run;
				join_any
		endtask

		task post;
		static int unsigned mon_buf_count;
		begin
				wait(transaction :: transaction_count == generator :: gen_count);
				wait(generator :: gen_count == driver :: drv_count);
				mon_buf_count = (generator :: gen_count + 32'd2);
				wait(mon_buf_count === monitor :: mon_count);
				wait(mon_buf_count === scoreboard :: scb_count);
				$display("no_of_test_passed = %d, no_of_test_failed = %d", scoreboard :: no_of_test_passed, scoreboard :: no_of_test_failed);
				$display("Transaction count = %d\nGenerator count = %d\n Driver count = %d\n mon_buf_count = %d\n Monitor count = %d\n Scoreboard count = %d", transaction :: transaction_count, generator :: gen_count, driver :: drv_count, mon_buf_count, monitor :: mon_count, scoreboard :: scb_count);
		end
		endtask

		task run_phase;
		begin
				build;
				vif.pre;
				run;
				post;
				//@(posedge vif.HCLK)
				$finish;
		end
		endtask
endclass
