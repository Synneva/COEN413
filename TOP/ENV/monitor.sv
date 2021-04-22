// monitor gets dut outputs and translates to output transactions for checker

`include "transaction.sv"
`include "interface.sv"

class monitor;

	output_transaction otr[];
	virtual calc_if.MONITOR intf;
	mailbox #(output_transaction) mon2chk;
	int bad_count;

	function new(virtual calc_if intf, mailbox #(output_transaction) mon2chk);
		this.intf = intf;
		this.mon2chk = mon2chk;
		this.otr = new[NUM_PORTS];
		foreach(otr[i]) otr[i] = new;
		this.bad_count = 0;
	endfunction

	task main;
	forever begin
//		@(intf.cb.out_port[3].out_resp || intf.cb.out_port[2].out_resp || intf.cb.out_port[1].out_resp || intf.cb.out_port[0].out_resp);
		@(intf.cb.out_port[3].out_resp || intf.cb.out_port[2].out_resp || intf.cb.out_port[1].out_resp || intf.cb.out_port[0].out_resp ||
			intf.cb.out_port[3].out_data || intf.cb.out_port[2].out_data || intf.cb.out_port[1].out_data || intf.cb.out_port[0].out_data ||
			intf.cb.out_port[3].out_tag || intf.cb.out_port[2].out_tag || intf.cb.out_port[1].out_tag|| intf.cb.out_port[0].out_tag);
		fork
			monitor_port(0);
			monitor_port(1);
			monitor_port(2);
			monitor_port(3);
		join
	end
	endtask

	task monitor_port(int p);
	//forever begin
		if(intf.cb.out_port[p].out_resp) begin
			otr[p].out_resp = intf.cb.out_port[p].out_resp;
			otr[p].out_data = intf.cb.out_port[p].out_data;
			otr[p].out_tag = intf.cb.out_port[p].out_tag;
			otr[p].port = p;
			mon2chk.put(otr[p]);
			//$display("Response detected on port %0d", p);
		end
		else if(intf.cb.out_port[p].out_data || intf.cb.out_port[p].out_tag) begin
			 $display("Output with response %0d: tag %0d, data %0h on port %0d", intf.cb.out_port[p].out_resp, intf.cb.out_port[p].out_tag, intf.cb.out_port[p].out_data, p);
			 bad_count++;
		end
	endtask

endclass
