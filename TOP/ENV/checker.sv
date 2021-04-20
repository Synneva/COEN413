// checker compares between monitor (dut output) and scoreboard (expected result)
// output to fc?

`include "transaction.sv"

class check;
	mailbox #(output_transaction) scb2chk, mon2chk[NUM_PORTS];
	output_transaction expected, actual;

	
	function new(mailbox #(output_transaction) scb2chk, mon2chk[]);
		this.scb2chk = scb2chk;
		this.mon2chk = mon2chk;
	endfunction

	task main;
		forever begin
			scb2chk.get(expected);
			mon2chk.get(actual);		// this is an array of 4 now
				// need logic to combine responses, or separate otr from scb

			// compare + print i guess
			
			if (expected.tag == actual.tag) begin
				logic[15:0]
				if (expected.resp!=actual.resp) begin
					$display("error",$time);
				end
				if (expected.data!=actual.data) begin
					$display("error",$time);
				end
			end else begin
				$display("Error: Tag Mismatch",$time);
			end 

			

		end
	endtask

endclass
