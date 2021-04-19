// checker compares between monitor (dut output) and scoreboard (expected result)
// output to fc?


class check;
	mailbox #(output_transaction) scb2chk, mon2chk;
	output_transaction expected, actual;

	
	function new(mailbox #(output_transaction) scb2chk, mon2chk);
		this.scb2chk = scb2chk;
		this.mon2chk = mon2chk;
	endfunction

	task main;
		forever begin
			scb2chk.get(expected);
			mon2chk.get(actual);

			// compare + print i guess

			

		end
	endtask

endclass
