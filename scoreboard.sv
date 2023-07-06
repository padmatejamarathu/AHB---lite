`include "monitor.sv"
class scoreboard;
		virtual ahb3lite_bus vif;

		transaction tr;

		//temporary memory
		byte unsigned mem [int];

		//mailbox
		mailbox #(transaction) mbx;

		//events
		event scb_mon_done;

		//test passed
		static int unsigned no_of_test_passed;
		static int unsigned no_of_test_failed;

		// reference data
		Response_t ref_HRESP;
		logic [31:0] ref_HRDATA;

		//constructor
		function new(virtual ahb3lite_bus vif, mailbox #(transaction) mbx, event scb_mon_done);
				this.vif = vif;
				this.mbx = mbx;
				this.scb_mon_done = scb_mon_done;
  		endfunction
		
		//reference model
		function void refrence_model( transaction tx);
			if(vif.HRESETn == '0)
			begin
				ref_HRESP = OKAY;
				ref_HRDATA = '0;
			end
			else
			begin
				if(tx.HADDR[8] === '1)
				begin
					if(tx.HTRANS inside {NONSEQ, SEQ})
					begin
						if(tx.HREADY == '1)
						begin
							if(tx.HRESP == OKAY)
							begin
								mem[tx.HADDR] = tx.HWDATA;
								ref_HRESP = OKAY;
							end
							else
							begin
								//$display("RESPONSE FROM SLAVE IS ERROR SO NO NEED TO STORE DATA");
								ref_HRESP = ERROR;
							end
						end
						else
						begin
							if(tx.HRESP == OKAY)
							begin
								ref_HRDATA = mem[tx.HADDR];
								ref_HRESP = OKAY;
							end
							else
							begin
								//$display("RESPONSE FROM SLAVE IS ERROR SO NO NEED TO LOAD DATA");
								ref_HRESP = ERROR;
							end
						end
					end
					else
					begin
						//$display("%t IGNORE THE DATA SENT BY MONITOR BECAUSE MASTER IS BUSY", $time);
					end
				end
				else
				begin
					if(tx.HTRANS inside {NONSEQ, SEQ})
					begin
						if(tx.HREADY == '1)
						begin
							if(tx.HRESP == OKAY)
							begin
								mem[tx.HADDR] = tx.HWDATA;
								ref_HRESP = OKAY;
							end
							else
							begin
								//$display("RESPONSE FROM SLAVE IS ERROR SO NO NEED TO STORE DATA");
								ref_HRESP = ERROR;
							end
						end
						else
						begin
							if(tx.HRESP == OKAY)
							begin
								ref_HRDATA = mem[tx.HADDR];
								ref_HRESP = OKAY;
							end
							else
							begin
								//$display("RESPONSE FROM SLAVE IS ERROR SO NO NEED TO LOAD DATA");
								ref_HRESP = ERROR;
							end
						end
					end
					else
					begin
						//$display("%t IGNORE THE DATA SENT BY MONITOR BECAUSE MASTER IS BUSY", $time);
					end
				end
			end
		endfunction
		
		function void check_output( transaction tx);
			if(vif.HRESETn == '0)
			begin
				//$display("DO NOTHING from scoreboard");
			end
			else
			begin
				if(tx.HWRITE == '1)
				begin
					if(ref_HRESP === tx.HRESP)
					begin
						//$display("%t write transaction is completed successfully", $time);
						no_of_test_passed ++;
					end
					else
					begin
						//$display("%t write transaction is not completed, Please debug the issue", $time);
						no_of_test_failed ++;
					end
				end
				else
				begin
					if(ref_HRESP === tx.HRESP)
					begin
						if(ref_HRDATA === tx.HRDATA)
						begin
							no_of_test_passed ++;
							//$display("%t read transaction is completed successfully", $time);
						end
						else
						begin
							no_of_test_failed ++;
							//$display("%t Mismatch occured please debug the issue the transaction data is tx.HADDR = %d, tx.HRDATA = %d, ref_HRDATA = %d", $time, tx.HADDR, tx.HRDATA, ref_HRDATA);
						end
					end
					else
					begin
						//$display("read transaction is completed successfully");
						no_of_test_failed ++;
					end
				end
			end
		endfunction
		
		task run;
		forever
		begin
			mbx.get(tr);
			refrence_model(tr);
			check_output(tr);
			-> scb_mon_done;
		end
		endtask
endclass
