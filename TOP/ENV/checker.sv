// checker compares between monitor (dut output) and scoreboard (expected result)

`include "transaction.sv"

class check;

	mailbox #(output_transaction) scb2chk, mon2chk;
  	output_transaction tr_ex, tr_ac, temp_ex, temp_ac;
	int ex_count, ac_count, count, cmp_count;

	// checker stores transactions in 2d arrays of queues
		// each port is associated with an array of queues, one for each possible tag
		// this way, we can use the tag of the actual output on a given port to find the corresponding expected values
		// also accounts for timing differences between outputs from scoreboard and monitor
	output_transaction expected[NUM_PORTS][NUM_TAGS][$];
	output_transaction actual[NUM_PORTS][NUM_TAGS][$];

	function new(mailbox #(output_transaction) scb2chk, mon2chk, int count);
		this.scb2chk = scb2chk;
		this.mon2chk = mon2chk;
		this.tr_ex = new;
		this.tr_ac = new;
		this.temp_ex = new;
		this.temp_ac = new;
		this.ex_count = 0;
		this.ac_count = 0;
		this.cmp_count = 0;
		this.count = count;
		
	endfunction


	task main;
		fork
			get_scb;
			get_mon;
		join
	endtask

	task get_mon;

		forever begin
			// get next output from monitor
			mon2chk.get(tr_ac);
			if(tr_ac.out_resp) begin
				// push to queue
				actual[tr_ac.port][tr_ac.out_tag].push_back(tr_ac);
				// if the corresponding expected result has been received from scb, pop and compare them
				if(expected[tr_ac.port][tr_ac.out_tag].size) begin
					temp_ac = actual[tr_ac.port][tr_ac.out_tag].pop_front;
					temp_ex = expected[tr_ac.port][tr_ac.out_tag].pop_front;

					if(temp_ex.out_resp!=temp_ac.out_resp) begin
						$display("Checker: Port %0d: %s %0h %0h, Expected response %0d, got %0d (%0d)", temp_ac.port, temp_ex.tr.cmd, temp_ex.tr.data1, temp_ex.tr.data2, temp_ex.out_resp, temp_ac.out_resp, ac_count);
						//missed_expected.push_back(temp);			// add if there's time
					end
					else if(temp_ex.out_data!=temp_ac.out_data) begin
						$display("Checker: Port %0d: %0s %0h %0h, Expected result %0h, got %0h (%0d)", temp_ac.port, temp_ex.tr.cmd, temp_ex.tr.data1, temp_ex.tr.data2, temp_ex.out_data, temp_ac.out_data, ac_count);
						//missed_expected.push_back(temp);
					end
					else $display("Checker: Correct response on port %0d", tr_ac.port);
				end
			ac_count++;
			//$display("%d", ac_count);
			end
			if(ac_count >= cmp_count) break;
		end
	endtask

	task get_scb;
		forever begin
			scb2chk.get(tr_ex);
			// separate by port
			if(tr_ex.out_resp) begin
				for(int i = 0; i<NUM_PORTS; i++) begin
					// push expected output to the right queue in expected[port][tag]
					if(tr_ex.ports[i]) begin
						expected[i][tr_ex.out_tag].push_back(tr_ex);
						cmp_count++;
					end
				end
			ex_count++;
			end
			if(ex_count == count) break;
		end
	endtask
	


endclass