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
		static int unsigned scb_count;

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
								if(tx.HWRITE == '1)
								begin
									mem[tx.HADDR] = tx.HWDATA;
									ref_HRESP = OKAY;
								end
								else
								begin
									ref_HRDATA = mem[tx.HADDR];
									ref_HRESP = OKAY;
								end
							end
							else
							begin
								$display("%t RESPONSE FROM SLAVE 0 (write) IS ERROR SO NO NEED TO STORE DATA", $time);
								ref_HRESP = ERROR;
							end
						end
						else
						begin
							$display("%t SLAVE 0 IS STILL NOT READY TO TRANSFER or RECEIVE DATA", $time);
						end
					end
					else
					begin
						$display("%t IGNORE THE DATA SENT BY MONITOR BECAUSE MASTER IS BUSY 0", $time);
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
								if(tx.HWRITE == '1)
								begin
									mem[tx.HADDR] = tx.HWDATA;
									ref_HRESP = OKAY;
								end
								else
								begin
									ref_HRDATA = mem[tx.HADDR];
									ref_HRESP = OKAY;
								end
							end
							else
							begin
								$display("%t RESPONSE FROM SLAVE 1 (write) IS ERROR SO NO NEED TO STORE DATA", $time);
								ref_HRESP = ERROR;
							end
						end
						else
						begin
							$display("%t SLAVE 1 IS STILL NOT READY TO TRANSFER or RECEIVE DATA", $time);
						end
					end
					else
					begin
						$display("%t IGNORE THE DATA SENT BY MONITOR BECAUSE MASTER IS BUSY 1", $time);
					end
				end
			end
		endfunction
		
		function void check_output( transaction tx);
			if(vif.HRESETn == '0)
			begin
				$display("%t DO NOTHING from scoreboard", $time);
			end
			else
			begin
				if($isunknown(tx.HADDR) == 1)
				begin
					$display("%t DON't DO CHECKING", $time);
				end
				else
				begin
					if(tx.HWRITE == '1)
					begin
						if(ref_HRESP === tx.HRESP)
						begin
							$display("%t write transaction is completed successfully", $time);
							no_of_test_passed ++;
						end
						else
						begin
							$display("%t write transaction is not completed, Please debug the issue", $time);
							no_of_test_failed ++;
						end
					end
					else
					begin
						if(ref_HRESP === tx.HRESP)
						begin
							if(mem.exists(tx.HADDR) == '0)
							begin
								$display("%t The Data is not present in this %d location please load the DATA(this particular transaction is passed because generator send read to the location", $time, tx.HADDR);
								no_of_test_passed ++;
							end
							else
							begin
								if(ref_HRDATA === tx.HRDATA)
								begin
									no_of_test_passed ++;
									$display("%t read transaction is completed successfully the DUT data is %d and the reference data is %d in HADDRESS %d", $time, tx.HRDATA, ref_HRDATA, tx.HADDR);
								end
								else
								begin
									no_of_test_failed ++;
									$display("%t Mismatch occured please debug the issue the transaction data is tx.HADDR = %d, tx.HRDATA = %d, ref_HRDATA = %d", $time, tx.HADDR, tx.HRDATA, ref_HRDATA);
								end
							end
						end
						else
						begin
							$display("%t read transaction is not completed successfully because of mismatch in HRESPONSE", $time);
							no_of_test_failed ++;
						end
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
			$display("\n\n\n\n\n");
			scb_count ++;
			-> scb_mon_done;
		end
		endtask
endclass
