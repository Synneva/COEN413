// converts high level to low level?

class agent;
    mailbox gen2agt, agt2scb, agt2drv;
    transaction tr;

	function new(mailbox #(transaction) gen2agt, agt2scb, agt2drv);
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
		agt2drv.put(tr);
	end	
	endtask

	// task wrapup?
endclass
