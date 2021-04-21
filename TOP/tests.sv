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
		env.gen.tr.constraint_mode(0);
		env.gen.repeat_count = 20;
		env.run();
		//Testing #1,2,3,4

		env.gen.tr.constraint_mode(0);
		env.gen.tr.port1Only.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//Testing #5,6,7
		env.gen.tr.constraint_mode(0);
		env.gen.tr.concurrentPort.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//add, #10
		env.gen.tr.constraint_mode(0);
		env.gen.tr.addOnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//sub, #11
		env.gen.tr.constraint_mode(0);
		env.gen.tr.subOnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//lsl, #12
		env.gen.tr.constraint_mode(0);
		env.gen.tr.LSLOnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//lsr, #13
		env.gen.tr.constraint_mode(0);
		env.gen.tr.LSROnly.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//both shifts, #14
		env.gen.tr.constraint_mode(0);
		env.gen.tr.lslLsr.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//overflow , #16
		env.gen.tr.constraint_mode(0);
		env.gen.tr.dataOverflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//overflow for add , #16
		env.gen.tr.constraint_mode(0);
		env.gen.tr.addDataOverflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//underflow for sub , #15
		env.gen.tr.constraint_mode(0);
		env.gen.tr.subDataUnderflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		//invalid commands
		env.gen.tr.constraint_mode(0);
		env.gen.tr.invalidCmd.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		env.gen.tr.constraint_mode(0);
		env.gen.tr.noOverUnderFlow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

	end

endprogram
