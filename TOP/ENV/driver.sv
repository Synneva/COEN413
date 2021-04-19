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
	mailbox agt2drv;

	function new(drv_if intf, mailbox agt2drv);
		this.intf = intf;
		this agt2drv = agt2drv;
	endfunction


	task reset;
		wait(intf.reset);	// ?
		$display("DRIVER Reset started");
		// reset needs to be held high for 3 cycles + drive input ports low
		intf.DRIVER.reset <= 1;			// idk if right
		`DRV_CB.req1_cmd_in		<= 0;
		`DRV_CB.req1_data_in	<= 0;
		`DRV_CB.req1_tag_in		<= 0;
		repeat(3) @(posedge intf.DRIVER.clk);
		intf.DRIVER.reset <= 0;
		$display("DRIVER Reset ended");
	endtask


	task main;
		forever begin
			// drive all inputs low, will block on get if nothing there
			agt2drv.get(tr);
			// turn into signals for dut
			// something like this
			//  should probably make interface for one port	and have array of 4
				// port[] controlled by tr.ports ?
			`DRV_CB.cmd_in		<= tr.cmd;
			`DRV_CB.data_in		<= tr.data1;
			`DRV_CB.tag_in		<= tr.tag;
			@(posedge intf.DRIVER.clk);
			`DRV_CB.cmd_in		<= 0;
			`DRV_CB.data_in		<= tr.data2;
			`DRV_CB.tag_in		<= 0;
			@(posedge intf.DRIVER.clk);
			`DRV_CB.data_in		<= 0;

			// display stuff

			trans_count++;

		end
	endtask

endclass
