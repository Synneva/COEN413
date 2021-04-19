`ifndef	CALC_IF_DEFINE
`define	CALC_IF_DEFINE

`include "definitions.sv"

typedef virtual calc_if.DRIVER drv_if;
typedef virtual calc_if.MONITOR mon_if;

interface calc_if(input logic clk, reset);      // reset controlled in top or test, update driver

	// Port signals
	logic [CMD_WIDTH-1:0]   cmd_in;
	logic [DATA_WIDTH-1:0]  data_in, out_data;
	logic [TAG_WIDTH-1:0] 	tag_in, out_tag;
	logic [RESP_WIDTH-1:0]  out_resp;

	// clocking blocks

	clocking driver_cb @(posedge clk);	// check dut
		output 	cmd_in;
		output	data_in;
		output	tag_in;
	endclocking;

	clocking monitor_cb @(posedge clk);
		input	out_resp;
		input	out_data;
		input	out_tag;
	endclocking

	// modports				
	modport DRIVER  (clocking driver_cb, input clk, reset);
	modport MONITOR (clocking monitor_cb, input clk, reset);

endinterface

`endif