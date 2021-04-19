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



/*	i think dont need this, connects manually in top bc .v file
	clocking DUT_cb @(posedge clk);	// do we even need this?
		input	cmd_in;
		input	data_in;
		input	tag_in;
		output	out_resp;
		output  out_data;
		output  out_tag;
	endclocking
*/
	
	//modport DUT		(clocking DUT_cb, input clk, reset);

/*
	logic [CMD_WIDTH-1:0]   req1_cmd_in, 
							req2_cmd_in, 
							req3_cmd_in, 
							req4_cmd_in;
	logic [DATA_WIDTH-1:0]  req1_data_in, 
							req2_data_in, 
							req3_data_in, 
							req4_data_in;
	logic [TAG_WIDTH-1:0]   req1_tag_in,
							req2_tag_in,
							req3_tag_in,
							req4_tag_in;
	logic [RESP_WIDTH-1:0]  out_resp1,
							out_resp2,
							out_resp3,
							out_resp4;
	logic [DATA_WIDTH-1:0]  out_data1,
							out_data2,
							out_data3,
							out_data4;
	logic [TAG_WIDTH-1:0]   out_tag1,
							out_tag2,
							out_tag3,
							out_tag4;


	// clocking blocks

	clocking driver_cb @(posedge clk);	// check dut
		// default input #1 output #1;
		output 	req1_cmd_in, 
				req2_cmd_in, 
				req3_cmd_in, 
				req4_cmd_in;
		output	req1_data_in, 
				req2_data_in, 
				req3_data_in, 
				req4_data_in;
		output	req1_tag_in,
				req2_tag_in,
				req3_tag_in,
				req4_tag_in;
		//output	reset;
	endclocking;

	clocking monitor_cb @(posedge clk);
		input	out_resp1,
				out_resp2,
				out_resp3,
				out_resp4;
		input	out_data1,
				out_data2,
				out_data3,
				out_data4;
		input	out_tag1,
				out_tag2,
				out_tag3,
				out_tag4;
	endclocking

	clocking DUT_cb @(posedge clk);	// do we even need this?
		//input 	clk, reset;		// not sure?
		input	req1_cmd_in, 
				req2_cmd_in, 
				req3_cmd_in, 
				req4_cmd_in;
		input	req1_data_in, 
				req2_data_in, 
				req3_data_in, 
				req4_data_in;
		input	req1_tag_in,
				req2_tag_in,
				req3_tag_in,
				req4_tag_in;
		output	out_resp1,
				out_resp2,
				out_resp3,
				out_resp4;
		output  out_data1,
				out_data2,
				out_data3,
				out_data4;
		output  out_tag1,
				out_tag2,
				out_tag3,
				out_tag4;
	endclocking


	// modports
								
	modport DRIVER  (clocking driver_cb, input clk, reset);
	modport MONITOR (clocking monitor_cb, input clk, reset);
	modport DUT		(clocking DUT_cb, input clk, reset);

*/