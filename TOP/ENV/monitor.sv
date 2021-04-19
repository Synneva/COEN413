/*
monitor translates signal level (objects/events) info to high level (signal level to transaction level)
	passes to coverage collector and checker via mailbox
	module or class? check lab4 files
	declare interface and mailbox, get through constructor
	send trans to checker*/

// gets dut outputs and translates to results for checker+fc


`include "transaction.sv"
`include "interface.sv"

`define MON_CB intf.MONITOR.monitor_cb


class monitor

	virtual calc_if intf;
	mailbox #(output_transaction) mon2chk;

	output_transaction otr;


	function new(virtual calc_if intf, mailbox mon2chk);
		this.intf = intf;
		this.mon2chk = mon2chk;
	endfunction

	task main;
		// turn dut outputs into output_transaction object

		// wait for something? out_resp?


	endtask

endclass
