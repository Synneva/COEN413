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

	covergroup CovGroup;
    cmd : coverpoint tr.cmd 
	{
    	bins add    = {1};
    	bins sub    = {2};
	    bins shiftleft   = {5};
	 	bins shiftright   = {6};
		bins NOOP = {0};
    }	
    data1 : coverpoint tr.data1 
	{
      	bins zero    = {0};
     	bins low    = {1,32'h7FFFFFFF};
		bins high    = {32'h80000000,32'hFFFFFFFE};
		bins max	 = {32'hFFFFFFFF};

    } 
	data2 : coverpoint tr.data2 
	{
      	bins zero    = {0};
     	bins low    = {1,32'h7FFFFFFF};
		bins high    = {32'h80000000,32'hFFFFFFFE};
		bins max	 = {32'hFFFFFFFF};
    } 
	ports : coverpoint tr.ports 
	{
      	bins portOne    = {0};
		bins portTwo    = {1};
		bins portThree    = {2};
		bins portFour    = {3};
    } 
	cross cmd, data1, data2, ports;	
  endgroup

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
			CovGroup.sample();
			gen2agt.put(tr);								// put in mailbox
			gen_count++;
		end
		$display($time, ": End of transaction generation");
		-> ended;   	// trigger end event
	endtask

endclass
