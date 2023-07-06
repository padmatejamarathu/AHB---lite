`include "transaction.sv"
class generator;

		transaction trans;

		//number of transaction
		int unsigned no_of_trans;
		static int unsigned gen_count;

		//mailbox
		mailbox #(transaction) gen2drv;

		//event
		event drv_done;
		event task_over;

		//custom sonstructor
		function new(mailbox #(transaction) gen2drv, event drv_done, int unsigned no_of_trans);
				this.gen2drv = gen2drv;
				this.drv_done = drv_done;
				this.no_of_trans = no_of_trans;
		endfunction

		//run task
		virtual task run();
				begin
						for( int i = 0; i < no_of_trans; i++)
						begin
								//$display("Number of transactions = %d", no_of_trans);
								trans = new();
								trans.transaction_count++;
								assert (trans.randomize());
								gen2drv.put(trans);
								gen_count ++;
								//trans.print("Generator");
								//$display("*********** %d ************", i);
								@(drv_done);
						end
						//$display("Generator Function Over");
				end
		endtask
endclass : generator
