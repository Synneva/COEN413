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
	virtual calc_if intf;
	mailbox #(transaction) agt2drv;
	int port;

	function new(virtual calc_if intf, mailbox agt2drv, int i);
		this.intf = intf;
		this.agt2drv = agt2drv;
		this.port = i;
	endfunction

	// drive all inputs low
	task reset;
		$display("DRIVER Reset started");
		intf.DRIVER.cb.in_port[port].cmd_in = 0;
		intf.DRIVER.cb.in_port[port].data_in = 0;
		intf.DRIVER.cb.in_port[port].tag_in = 0;
		$display("DRIVER Reset complete");
	endtask


	task main;
		reset;	// drive all inputs low, will block on get if nothing there
		forever begin
			agt2drv.get(tr);
			// turn into signals for dut
			intf.DRIVER.cb.in_port[port].cmd_in		= tr.cmd;
			intf.DRIVER.cb.in_port[port].data_in	= tr.data1;
			intf.DRIVER.cb.in_port[port].tag_in		= tr.tag;
			@(intf.DRIVER.cb);
			intf.DRIVER.cb.in_port[port].cmd_in		= 0;
			intf.DRIVER.cb.in_port[port].data_in	= tr.data2;
			intf.DRIVER.cb.in_port[port].tag_in		= 0;
			@(intf.DRIVER.cb);
			intf.DRIVER.cb.in_port[port].data_in	= 0;

			trans_count++;
			$display("Drove transaction %0s on port %0d (%0d)", tr.cmd, port, trans_count);
		end
	endtask

endclass
