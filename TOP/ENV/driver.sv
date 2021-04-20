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

`define DRV_CB intf.driver_cb

class driver;

	int trans_count;
	transaction tr;
	drv_if intf;
	mailbox #(transaction) agt2drv;
	int port;

	function new(drv_if intf, mailbox agt2drv, int i);
		this.intf = intf;
		this.agt2drv = agt2drv;
		this.port = i;
	endfunction

	// drive all inputs low
	task reset;
		$display("DRIVER Reset started");
		`DRV_CB.cmd_in	<= 0;
		`DRV_CB.data_in	<= 0;
		`DRV_CB.tag_in	<= 0;
		//repeat(3) @(`DRV_CB);
		$display("DRIVER Reset complete");
	endtask


	task main;
		reset;	// drive all inputs low, will block on get if nothing there
		forever begin
			agt2drv.get(tr);
			// turn into signals for dut
			`DRV_CB.cmd_in		<= tr.cmd;
			`DRV_CB.data_in		<= tr.data1;
			`DRV_CB.tag_in		<= tr.tag;
			@(`DRV_CB);
			`DRV_CB.cmd_in		<= 0;
			`DRV_CB.data_in		<= tr.data2;
			`DRV_CB.tag_in		<= 0;
			@(`DRV_CB);
			`DRV_CB.data_in		<= 0;

			trans_count++;
			$display("Drove transaction %0s on port %0d (%0d)", tr.cmd, port, trans_count);
		end
	endtask

endclass
