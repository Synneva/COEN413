// checker compares between monitor (dut output) and scoreboard (expected result)
// output to fc?

`include "transaction.sv"

class check;

	mailbox #(output_transaction) scb2chk, mon2chk;
  	output_transaction tr_ex, tr_ac, temp;

	// checker stores scoreboard outputs in 2d array of queues
		// each port is associated with an array of queues, one for each possible tag
		// this way, we can use the tag of the actual output on a given port to find the corresponding expected values
	output_transaction expected[NUM_PORTS][NUM_TAGS][$];

	//output_transaction[$] actual[NUM_PORTS][NUM_TAGS];

	function new(mailbox #(output_transaction) scb2chk, mon2chk);
		this.scb2chk = scb2chk;
		this.mon2chk = mon2chk;
		this.tr_ex = new;
		this.tr_ac = new;
		//this.expected = new[NUM_PORTS][NUM_TAGS];
	endfunction

/*
main forks a thread to get from scoreboard
	scb thread splits transactions by port then by TAG and stores
	monitor thread splits by tag (already split by port) and stores or checks?
		currently just gets and checks
*/

	task main;
	
		fork
			get_scb;
		join_none

		forever begin
			
			mon2chk.get(tr_ac);
			wait(expected[tr_ac.port][tr_ac.out_tag].size);
			temp = expected[tr_ac.port][tr_ac.out_tag].pop_front;

					if(temp.out_resp!=tr_ac.out_resp) begin
						$display("Checker: Port %0d: Expected response %0d, got %0d", tr_ac.port, temp.out_resp, tr_ac.out_resp);
						//missed_expected.push_back(temp);
					end
					else if(temp.out_data!=tr_ac.out_data) begin
						$display("Checker: Port %0d: Expected result %0d, got %0d", tr_ac.port, temp.out_data, tr_ac.out_data);
						//missed_expected.push_back(temp);
					end
					else $display("Checker: Correct response on port %0d", tr_ac.port);
			end
	endtask


	task get_scb;
		forever begin
			scb2chk.get(tr_ex);
			// separate by port
			if(tr_ex.out_resp) begin
			for(int i = 0; i<NUM_PORTS; i++) begin
				// push expected output to the right queue in expected[port][tag]
				if(tr_ex.ports[i]) expected[i][tr_ex.out_tag].push_back(tr_ex);
			end
			end
			
		end

	endtask
	


endclass

/*forever begin

	  scb2chk.get(tr_ex);
	  $display("got the goods from scoreboard");
	  mon2chk.get(tr_ac);
	  if (tr_ex.out_tag == tr_ac.out_tag) begin
				if (tr_ex.out_resp!=tr_ac.out_resp) begin
					$display("error",$time);
				end
				if (tr_ex.out_data!=tr_ac.out_data) begin
					$display("error",$time);
				end
			end else begin
				$display("Error: Tag Mismatch",$time);
			end
		$display("No Errors lol");

	end		*/