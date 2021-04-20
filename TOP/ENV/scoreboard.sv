/*
scoreboard receives packet from agent, predicts results 	   
	declare mailbox + counting variable, connect in constructor
	logic to generate expected result   					   
	(example has checker code, move it there)   			   
*/

`include "transaction.sv"

class scoreboard;
	mailbox #(transaction) agt2scb;
	mailbox #(output_transaction) scb2chk;
	int trans_count;
	transaction tr;
	output_transaction otr;

	function new(mailbox agt2scb, scb2chk);
		this.agt2scb = agt2scb;
		this.scb2chk = scb2chk;
	endfunction


	// task or function? generate expected result, send to checker
	task main;
		forever begin
			agt2scb.get(tr);			// get transaction from agent
			expected_output(tr, otr);	// generate result
			scb2chk.put(otr);   		// send expected output to checker
		end
	endtask

	function void expected_output(transaction tr, output_transaction otr);
		otr.out_tag = tr.tag;
		logic [32:0] sum;
		case(tr.cmd)
			NOOP:	begin
						otr.out_resp = 0;
					  	otr.out_data = 0;
					end

			ADD:	begin		// add + overflow logic
                		sum = tr.data1 + tr.data2;
						if (sum[32])
							otr.out_data = sum[31:0];
							otr.out_resp = 2;
						else
							otr.out_data = sum[31:0];
							otr.out_resp = 1;
					end

			SUB:	begin		// sub + underflow logic
						if(tr.data1 >= tr.data2)
							otr.out_data = tr.data1 - tr.data2;
							otr.out_resp = 2;
						else
							otr.out_data = tr.data1 - tr.data2;
							otr.out_resp = 1;
					end

			LSL:	begin
						otr.out_resp = 1;
						otr.out_data = tr.data1 << tr.data2[27:31];	// gotta check if this works
					end

			LSR:	begin
						otr.out_resp = 1;
						otr.out_data = tr.data1 >> tr.data2[27:31];
					end

			default:begin
						otr.out_resp = 2;
						otr.out_data = 0;
					end
		endcase
		
	endfunction
	
endclass
