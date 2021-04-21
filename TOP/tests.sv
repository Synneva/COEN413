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
		env = new(intf);
		env.gen.tr.constraint_mode(0);
		env.gen.repeat_count = 20;
		env.run();
		
		env.gen.tr.port1Only.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		env.gen.tr.constraint_mode(0);
		env.gen.tr.port1Only.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		env.gen.tr.constraint_mode(0);
		env.gen.tr.dataOverflow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

		env.gen.tr.constraint_mode(0);
		env.gen.tr.noOverUnderFlow.constraint_mode(1);
		env.gen.repeat_count = 20;
		env.run();

	end

endprogram
