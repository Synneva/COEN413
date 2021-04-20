// checker compares between monitor (dut output) and scoreboard (expected result)
// output to fc?

`include "transaction.sv"

class check;
	mailbox #(output_transaction) scb2chk, mon2chk[NUM_PORTS];
	output_transaction tr_ex, tr_ac;
	output_transaction[$] expected[NUM_PORTS][NUM_TAGS];
	//output_transaction[$] actual[NUM_PORTS][NUM_TAGS];

	function new(mailbox #(output_transaction) scb2chk, mon2chk[]);
		this.scb2chk = scb2chk;
		this.mon2chk = mon2chk;
		this.tr_ex = new();
		this.tr_ac = new();
		this.expected = new[NUM_PORTS][NUM_TAGS];
	endfunction



/*
main idea: 2 threads, one gets from scb, other from monitors
	scb thread splits transactions by port then by TAG and stores
	monitor thread splits by tag (already split by port) and stores or checks?
*/

	task main;
		fork
			
		join_none


	endtask


	task get_scb;
		forever begin
			scb2chk.get(tr_ex);
			
			// separate by port
			for(int i = 0; i<NUM_PORTS; i++)
		end
	endtask

/*	task main;
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
	endtask	*/

endclass
