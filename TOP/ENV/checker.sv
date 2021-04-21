// checker compares between monitor (dut output) and scoreboard (expected result)
// output to fc?

`include "transaction.sv"

class check;

	mailbox #(output_transaction) scb2chk, mon2chk[NUM_PORTS];
	output_transaction tr_ex, tr_ac, temp;
	output_transaction[$] missed_expected;


	// checker stores scoreboard outputs in 2d array of queues
		// each port is associated with an array of queues, one for each possible tag
		// this way, we can use the tag of the actual output on a given port to find the corresponding expected values
	output_transaction[$] expected[NUM_PORTS][NUM_TAGS];	// hope it works lol
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
			get_scb;

		join_none

		forever begin

			foreach(mon2chk[i]) begin
				if(mon2chk[i].try_get(tr_ac)) begin
				temp = expected[i][tr_ac.tag].pop_front;

					if(temp.out_resp!=tr_ac.out_resp) begin
						$display("Checker: Port %0d: Expected response %0d, got %0d", i+1, temp.out_resp, tr_ac.out_resp);
						missed_expected.push_back(temp);
					end
					else if(temp.out_data!=tr_ac.out_data) begin
						$display("Checker: Port %0d: Expected result %0d, got %0d", i+1, temp.out_data, tr_ac.out_data);
						missed_expected.push_back(temp);
					end
				end
			end
		end

	endtask


	task get_scb;
		forever begin
			scb2chk.get(tr_ex);
			// separate by port
			for(int i = 0; i<NUM_PORTS; i++) begin
				// push expected output to the right queue in expected[port][tag]
				if(tr.ports[i]) expected[i][tr.tag].push_back(tr_ex);
			end
		end
	endtask

endclass
