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
	//int port; 
	

	function new(virtual calc_if.DRIVER intf, mailbox #(transaction) agt2drv);
		this.intf = intf;
		this.agt2drv = agt2drv;
	endfunction

	// drive all inputs low
	task reset;
		$display("DRIVER Reset started");
		for(int i = 0; i<NUM_PORTS; i++) begin
			intf.cb.in_port[i].cmd_in = 0;
			intf.cb.in_port[i].data_in = 0;
			intf.cb.in_port[i].tag_in = 0;
		end
		$display("DRIVER Reset complete");
	endtask


	task main;
		reset;	// drive all inputs low, will block on get if nothing there
		forever begin
			agt2drv.get(tr);
			// turn into signals for dut

				fork
					drive_port(0);
					drive_port(1);
					drive_port(2);
					drive_port(3);
				join
				

			//end

			trans_count++;
			//$display("Drove transaction %0s on port %0d (%0d)", tr.cmd, tr.ports, trans_count);
		end
	endtask

	task drive_port(int p);
		if(tr.ports[p] && (tr.cmd!=0)) begin
		intf.cb.in_port[p].cmd_in		= tr.cmd;
		intf.cb.in_port[p].data_in		= tr.data1;
		intf.cb.in_port[p].tag_in		= tr.tag;
		@(intf.cb);
		intf.cb.in_port[p].cmd_in		= 0;
		intf.cb.in_port[p].data_in		= tr.data2;
		intf.cb.in_port[p].tag_in		= 0;
		@(intf.cb);
		intf.cb.in_port[p].data_in		= 0;
		$display("Drove transaction %0s on port %0d (%0d)", tr.cmd, p, trans_count);
		end
	endtask

endclass
