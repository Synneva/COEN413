/*
test code in program block     
	declare+create environment 
	configure # transactions   
	initiate stimulus (env.run)
*/

`include "environment.sv"

program automatic tests(calc_if intf);
	environment env;

	// transactions constraints? ports, commands
			// maybe separate files for directed, constrained, random if needed


	initial begin
	  
	  $display("Boop");
		env = new(intf);
		env.gen.trs.constraint_mode(0);
		//env.gen.tr.validCmd.constraint_mode(1);
		env.gen.repeat_count = 30;
		env.run();
		//Testing #1,2,3,4

		env.gen.trs.constraint_mode(0);
		env.gen.trs.port1Only.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//Testing #5,6,7
		env.gen.trs.constraint_mode(0);
		env.gen.trs.concurrentPort.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//add, #10
		env.gen.trs.constraint_mode(0);
		env.gen.trs.addOnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//sub, #11
		env.gen.trs.constraint_mode(0);
		env.gen.trs.subOnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//lsl, #12
		env.gen.trs.constraint_mode(0);
		env.gen.trs.LSLOnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//lsr, #13
		env.gen.trs.constraint_mode(0);
		env.gen.trs.LSROnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//both shifts, #14
		env.gen.trs.constraint_mode(0);
		env.gen.trs.lslLsr.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//overflow , #16
		env.gen.trs.constraint_mode(0);
		env.gen.trs.dataOverflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//overflow for add , #16
		env.gen.trs.constraint_mode(0);
		env.gen.trs.addDataOverflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//underflow for sub , #15
		env.gen.trs.constraint_mode(0);
		env.gen.trs.subDataUnderflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//invalid commands
		env.gen.trs.constraint_mode(0);
		env.gen.trs.invalidCmd.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		env.gen.trs.constraint_mode(0);
		env.gen.trs.noOverUnderFlow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

	end

endprogram
