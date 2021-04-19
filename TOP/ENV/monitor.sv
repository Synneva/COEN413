/*
monitor translates signal level (objects/events) info to high level (signal level to transaction level)
	passes to coverage collector and checker via mailbox
	module or class? check lab4 files
	declare interface and mailbox, get through constructor
	send trans to checker*/

// gets dut outputs and translates to results for checker+fc


`include "transaction.sv"
`include "interface.sv"

`define MON_CB intf.monitor_cb


class monitor;

	output_transaction otr;
	mon_if intf;
	mailbox #(output_transaction) mon2chk;
	int port;

	function new(mon_if intf, mailbox mon2chk, int i);
		this.intf = intf;
		this.mon2chk = mon2chk;
		this.port = i;
	endfunction

	task main;
		// turn dut outputs into output_transaction object

		// wait for something? out_resp?
		wait(MON_CB.out_resp);
		otr.out_resp = `MON_CB.out_resp;
		otr.out_data = `MON_CB.out_data;
		otr.out_tag = `MON_CB.out_tag;

		mon2chk.put(otr);


	endtask

endclass
