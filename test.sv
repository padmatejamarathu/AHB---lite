`include "environment.sv"
program test(ahb3lite_bus vif);
		//class declaration
		environment env;
		int unsigned no_of_transactions;



		initial
		begin
				no_of_transactions = 10;
				env = new(vif, no_of_transactions);
				env.run_phase;
		end
endprogram
