`ifndef TRANSACTIONS
`define TRANSACTIONS

`include "definitions.sv"

class transaction;
	static int count = 0;
	int id;
	
	rand operation  			cmd;
	rand bit [DATA_WIDTH-1:0]   data1, data2;
	rand bit [TAG_WIDTH-1:0]	tag;
	rand bit [NUM_PORTS-1:0]	ports;

	constraint port1 { ports == 1; }	 // not sure if declare here + turn on/off in test or declare higher up

	function new();
		id = count++;
	endfunction

	// constraints?
	// functions for display, copy, compare?

	function transaction copy();
		transaction to = new();
		to.cmd  	= this.cmd;
		to.data1	= this.data1;
		to.data2	= this.data2;
		to.tag  	= this.tag;
		copy = to;
	endfunction: copy

endclass

class output_transaction;
	static int count = 0;
	int id;
	
	bit [RESP_WIDTH-1:0]	out_resp; 
	bit [DATA_WIDTH-1:0]	out_data;
	bit [TAG_WIDTH-1:0] 	out_tag;
	bit [NUM_PORTS-1:0]		ports;

	function new();
		id = count++;
	endfunction


endclass
`endif