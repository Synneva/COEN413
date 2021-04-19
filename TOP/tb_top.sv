/*testbench top connects dut+tb
	declare+generate clock+reset
	create interface
	create design instance, connect if signals
	create test instance, pass if handle
	Add logic to generate the dump?
	*/

`include "tests.sv"
`include "TOP\DUT\calc2_top.v"
`include "TOP\ENV\interface.sv"

module tb_top;

	// declare clock, reset
	logic clk, reset;

	// generate clock
	initial begin
		reset = 0;
		clk = 0;

		// generate reset, might keep here might move depends if it works
		#5ns reset = 1;
		#5ns clk = 1

		#5ns reset = 0
		clk = 0;
		
		forever
			#5ns clk = ~clk;
	end


	// interface instances???? can i do this idk
	calc_if intf [NUM_PORTS] (clk,reset);

	// test instance
	tests t1(intf);

	// dut instance, connect if signals
	calc2_top DUT(	.c_clk(clk),
					.reset(reset),

					.req1_data_in(intf[0].data_in),
					.req2_data_in(intf[1].data_in),
					.req3_data_in(intf[2].data_in),
					.req4_data_in(intf[3].data_in),
					.req1_cmd_in(intf[0].cmd_in),
					.req2_cmd_in(intf[1].cmd_in),
					.req3_cmd_in(intf[2].cmd_in),
					.req4_cmd_in(intf[3].cmd_in),
					.req1_tag_in(intf[0].tag_in),
					.req2_tag_in(intf[1].tag_in),
					.req3_tag_in(intf[2].tag_in),
					.req4_tag_in(intf[3].tag_in),

					.out_data1(intf[0].out_data),
					.out_data2(intf[1].out_data),
					.out_data3(intf[2].out_data),
					.out_data4(intf[3].out_data),
					.out_resp1(intf[0].out_resp),
					.out_resp2(intf[1].out_resp),
					.out_resp3(intf[2].out_resp),
					.out_resp4(intf[3].out_resp),
					.out_tag1(intf[0].out_tag),
					.out_tag2(intf[1].out_tag),
					.out_tag3(intf[2].out_tag),
					.out_tag4(intf[3].out_tag)
				);

	// enable dump?


endmodule: tb_top
