/*
Generator class is responsible for generating the stimulus by randomizing the transaction class + sending to agent
*/


`include "transaction.sv"


class generator;
	rand transaction tr;			// Declare the transaction class handle as random
	mailbox #(transaction) gen2agt; // Mailbox used to send the randomized transaction to agent
	int repeat_count;   			// control the number of packets to be created	
	event ended;					// event when all transactions generated
	int gen_count;					// number transactions created so far

	function new(mailbox #(transaction) gen2agt, int repeat_count, event ended);
		this.gen2agt		= gen2agt;
		this.repeat_count   = repeat_count;
		this.ended  		= ended;
		this.gen_count = 0;
		tr = new;
	endfunction

	task main();
		$display($time, ": Starting generator for %0d transactions", repeat_count);
		repeat (repeat_count) begin  	// how many transactions to generate, specified in test
			if(!this.tr.randomize()) 
				$fatal("Gen: trans randomization failed");  // Randomize transaction
			tr.tag = gen_count % TAG_WIDTH;					// cycle through tag values
			gen2agt.put(tr);								// put in mailbox
			gen_count++;
		end
		$display($time, ": End of transaction generation");
		-> ended;   	// trigger end event
	endtask

endclass
