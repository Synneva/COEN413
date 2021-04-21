/*
monitor translates signal level (objects/events) info to high level (signal level to transaction level)
	passes to coverage collector and checker via mailbox
	module or class? check lab4 files
	declare interface and mailbox, get through constructor
	send trans to checker*/

// gets dut outputs and translates to results for checker+fc


`include "transaction.sv"
`include "interface.sv"

//`define MON_CB intf.monitor_cb

class monitor;

	output_transaction otr;
	virtual calc_if.MONITOR intf;
	mailbox #(output_transaction) mon2chk;
	int port;

	function new(virtual calc_if intf, mailbox #(output_transaction) mon2chk);
		this.intf = intf;
		this.mon2chk = mon2chk;
		this.otr = new();
	endfunction

	task main;
	forever begin
		// turn dut outputs into output_transaction object

		wait((intf.cb.out_port[3].out_resp || intf.cb.out_port[2].out_resp) || (intf.cb.out_port[1].out_resp || intf.cb.out_port[0].out_resp));
		if(intf.cb.out_port[3].out_resp);
		  port = 3;
		if(intf.cb.out_port[2].out_resp);
		  port = 2;
		if(intf.cb.out_port[1].out_resp);
		  port = 1;
		if(intf.cb.out_port[0].out_resp);
		  port = 0;
		
		otr.out_resp = intf.cb.out_port[port].out_resp;
		otr.out_data = intf.cb.out_port[port].out_data;
		otr.out_tag = intf.cb.out_port[port].out_tag;
		otr.ports = port;
		mon2chk.put(otr);

	end
	endtask

endclass
