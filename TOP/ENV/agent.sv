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

	task main;
	forever begin
		gen2agt.get(tr);

		agt2scb.put(tr);

		foreach(agt2drv[i]) begin
			// bitwise AND to choose input ports
			if(tr.ports & (i+1)) agt2drv[i].put(tr);
		end

	end	
	endtask

	// task wrapup?
endclass
