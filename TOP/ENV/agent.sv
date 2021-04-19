// converts high level to low level?

`include "transaction.sv"

class agent;
    mailbox #(transaction) gen2agt, agt2scb, agt2drv[NUM_PORTS];
    transaction tr;

	function new(mailbox #(transaction) gen2agt, agt2scb, agt2drv[]);
		this.gen2agt = gen2agt;
		this.agt2scb = agt2scb;
		this.agt2drv = agt2drv;
	endfunction

	// function build?

	task run;
	forever begin
		gen2agt.get(tr);
		// process?
		agt2scb.put(tr);
		//agt2drv.put(tr);	// array, put in right port's mailbox
	end	
	endtask

	// task wrapup?
endclass
