/*
test code in program block     
	declare+create environment 
	configure # transactions   
	initiate stimulus (env.run)
*/

`include "environment.sv"

program automatic tests(calc_if intf);
	environment env;
  

	initial begin
	  
	  $display("Test#1 No Constraints");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		//env.gen.tr.validCmd.constraint_mode(1);
		env.gen.repeat_count = 30;
		env.run();
		//Testing #1,2,3,4

    	$display("Test#2 Only Port 1");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.port1Only.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//Testing #5,6,7
		$display("Test#3 All Port Combinations");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.allPortCombinations.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//add, #10
		$display("Test#4 Only Add");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.addOnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//sub, #11
		$display("Test#5 Only Subtract");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.subOnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//lsl, #12
		$display("Test#6 Only LSL");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.LSLOnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//lsr, #13
		$display("Test#7 Only LSR");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.LSROnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

    //Add/sub, #11
		$display("Test#8 Shift ALU");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.addSub.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//both shifts, #14
		$display("Test#9 Shift ALU");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.lslLsr.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//overflow , #16
		$display("Test#10 Data Overflow Conditions");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.dataOverflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//overflow for add , #16
		$display("Test#11 Add Overflow Conditions");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.addDataOverflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//underflow for sub , #15
		$display("Test#12 Subtract Underflow Conditions");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.subDataUnderflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();
/*
		//invalid commands
		$display("Test#12 Invalid Commands");
		env.gen.trs.constraint_mode(0);
		env.gen.trs.invalidCmd.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

*/

    $display("Test#13 Valid Data no under/overflow");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.noOverUnderFlow.constraint_mode(1);
		env.gen.repeat_count = 100;
		env.run();

    $display("Test#14 Data All Max");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.dataMax.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		$display("Test#15 Data All Zero");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		env.gen.trs.dataZero.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

	end

endprogram
