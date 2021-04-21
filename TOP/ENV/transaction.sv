`ifndef TRANSACTIONS
`define TRANSACTIONS

`include "definitions.sv"

class transaction;
	static int count = 0;
	int id;
	
	rand operation  			cmd;
	rand bit [DATA_WIDTH-1:0]   data1, data2;
		 bit [TAG_WIDTH-1:0]	tag; 
	rand bit [NUM_PORTS-1:0]	ports;

	constraint port1Only { ports == 0; }	 // not sure if declare here + turn on/off in test or declare higher up
	constraint port2Only { ports == 1; }
	constraint port3Only { ports == 2; }
	constraint port4Only { ports == 3; }

	constraint concurrentPort {
		ports == count % 4;
	}

	constraint addOnly { cmd == ADD; }
	constraint subOnly { cmd == SUB; }
	constraint LSLOnly { cmd == LSL; }
	constraint LSROnly { cmd == LSR; }

	constraint validCmd { cmd == {ADD,SUB,LSL,LSR}; }

	constraint addSub { cmd == {ADD,SUB}; }
	constraint lslLsr { cmd == {LSL,LSR}; }

	constraint dataZero {
		data1 == 0;
		data2 == 0;
	}

	constraint dataMax {
		data1 == 32'hFFFFFFFF;
		data2 == 32'hFFFFFFFF;
	}

	constraint dataOverflow {
		data1 + data2 > 32'hFFFFFFFF;
	}
	
	constraint addDataOverflow {
		data1 + data2 > 32'hFFFFFFFF;
		cmd == ADD;
	}

	constraint subDataUnderflow {
		data1 - data2 < 0;
		cmd == SUB;
	}

	constraint noOverUnderFlow {
		data1 + data2 < 32'hFFFFFFFF;
		data1 - data2 > 0;
	}

	constraint invalidCmd {
		cmd != {NOOP,ADD,SUB,LSL,LSR};
	}

	function new();
		id = count++;
	endfunction

	// constraints?
	// functions for display, copy, compare?

/*
	function transaction copy();
		transaction to = new();
		to.cmd  	= this.cmd;
		to.data1	= this.data1;
		to.data2	= this.data2;
		to.tag  	= this.tag;
		copy = to;
	endfunction: copy
*/
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