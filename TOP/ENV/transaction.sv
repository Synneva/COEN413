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

	function new;
		id = count++;
	endfunction

	function transaction copy();
		transaction to = new();
		to.cmd  	= this.cmd;
		to.data1	= this.data1;
		to.data2	= this.data2;
		to.tag  	= this.tag;
		to.ports 	= this.ports;
		copy = to;
	endfunction: copy


	constraint port1Only { ports == 4'b0001; }

	constraint allPortCombinations {
		ports == count % 16;
	}

	constraint addOnly { cmd == ADD; }
	constraint subOnly { cmd == SUB; }
	constraint LSLOnly { cmd == LSL; }
	constraint LSROnly { cmd == LSR; }

	constraint validCmd { cmd inside {ADD,SUB,LSL,LSR}; }

	constraint addSub { cmd inside {ADD,SUB}; }
	constraint lslLsr { cmd inside {LSL,LSR}; }

	constraint dataZero {
		data1 == 0;
		data2 == 0;
	}

	constraint dataMax {
		data1 == 32'hFFFFFFFF;
		data2 == 32'hFFFFFFFF;
	}

	constraint dataOverflow {
	   data1 > 32'h80000000;
	   data2 > 32'h80000000;
	}
	
	constraint addDataOverflow {
		data1 > 32'h80000000;
	  	data2 > 32'h80000000;
		cmd == ADD;
	}

	constraint subDataUnderflow {
		data2 > data1;
		cmd == SUB;
	}

	constraint noOverUnderFlow {
		data1 + data2 < 32'hFFFFFFFF;
		data1 - data2 > 0;
	}

	constraint invalidCmd {
		!(cmd inside {NOOP,ADD,SUB,LSL,LSR});
	}

endclass

class output_transaction;
	transaction tr;
	static int count = 0;
	int id;
	
	bit [RESP_WIDTH-1:0]	out_resp; 
	bit [DATA_WIDTH-1:0]	out_data;
	bit [TAG_WIDTH-1:0] 	out_tag;
	bit [NUM_PORTS-1:0]		ports;
	int port;

	function new;
		id = count++;
	endfunction


endclass
`endif