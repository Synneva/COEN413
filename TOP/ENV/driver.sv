/*
DRIVER receives stimulus from agent 							   
	declare interface+mailbox, get with constructor 				
	reset task  												   
	(define interface to access it? `define)					   
	drive task  												   
	local variable to track packets driven, increment in drive/main task
*/

`include "transaction.sv"
`include "interface.sv"

//`define DRV_CB intf.driver_cb

class driver;

	int trans_count;
	transaction tr;
	virtual calc_if.DRIVER intf;
	mailbox #(transaction) agt2drv;
	int port; 
	

	function new(virtual calc_if intf, mailbox #(transaction) agt2drv);
		this.intf = intf;
		this.agt2drv = agt2drv;
	endfunction

	// drive all inputs low
	task reset;
		$display("DRIVER Reset started");
		intf.cb.in_port[0].cmd_in = 0;
		intf.cb.in_port[0].data_in = 0;
		intf.cb.in_port[0].tag_in = 0;
		$display("DRIVER Reset complete");
	endtask


	task main;
		reset;	// drive all inputs low, will block on get if nothing there
		forever begin
			agt2drv.get(tr);
			// turn into signals for dut
			intf.cb.in_port[tr.ports].cmd_in		= tr.cmd;
			intf.cb.in_port[tr.ports].data_in	= tr.data1;
			intf.cb.in_port[tr.ports].tag_in		= tr.tag;
			@(intf.cb);
			intf.cb.in_port[tr.ports].cmd_in		= 0;
			intf.cb.in_port[tr.ports].data_in	= tr.data2;
			intf.cb.in_port[tr.ports].tag_in		= 0;
			@(intf.cb);
			intf.cb.in_port[tr.ports].data_in	= 0;

			trans_count++;
			$display("Drove transaction %0s on port %0d (%0d)", tr.cmd, tr.ports, trans_count);
		end
	endtask

endclass
