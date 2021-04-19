/*
test code in program block     
	declare+create environment 
	configure # transactions   
	initiate stimulus (env.run)
*/

`include "environment.sv"

program automatic tests(calc_if [] intf);
	environment env;

	// transactions constraints? ports, commands
			// maybe separate files for directed, constrained, random if needed


	// coverpoints here or in env? here i think
		// coverpoints for ports, commands, data ranges/specific values, 
		// cross for different functionaily tests


	initial begin
		env = new(intf);
		env.gen.repeat_count = 20;
		env.run();
	end

endprogram
