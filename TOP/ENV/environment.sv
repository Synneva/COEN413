/*
	Environment class contains instances of testbench components
		- generator, agent, driver, scoreboard, checker, monitor
		- interface passed through constructor (in tests)
		- mailboxes for intercomponent thread communication
		- instantiate in new()
*/

/*
                                              
    Generator and Driver activity can be divided and controlled in three methods.
        pre_test() � Method to call Initialization. i.e, reset method.           
        test() � Method to call Stimulus Generation and Stimulus Driving.        
        post_test() � Method to wait the completion of generation and driving.   
    run task to call methods, $finish; to end simulation                         
*/

`include "generator.sv"
`include "transaction.sv"
`include "agent.sv"
`include "driver.sv"
`include "monitor.sv"
`include "checker.sv"
`include "scoreboard.sv"
`include "interface.sv"


class environment;
	int repeat_count = 30;

	// testbench components
	generator 	gen;
	agent		agt;
	scoreboard	scb;
	check		chk;
	driver		drv[NUM_PORTS];
	monitor		mon[NUM_PORTS];

	// interface ports
	virtual calc_if intf;
	
	// mailboxes for ipc
	mailbox #(transaction) gen2agt, agt2drv[NUM_PORTS], agt2scb;
	mailbox #(output_transaction) scb2chk, mon2chk[NUM_PORTS];

	event gen_ended;

	// constructor gets interfaces from tests object
	function new(virtual calc_if intf);
		this.intf = intf;
		
		gen2agt = new();
		agt2scb = new();
		scb2chk = new();
		agt2drv = new[NUM_PORTS];
		mon2chk = new[NUM_PORTS];

		gen = new(gen2agt, repeat_count, gen_ended);
		agt = new(gen2agt, agt2scb, agt2drv);
		scb = new(agt2scb, scb2chk);
		chk = new(scb2chk, mon2chk);

		//drv = new[NUM_PORTS];
		//mon = new[NUM_PORTS];

		for (int i = 0; i < NUM_PORTS; i++) begin
			agt2drv[i] = new();
			mon2chk[i] = new();
			drv[i] = new(intf, agt2drv[i], i);
			mon[i] = new(intf, mon2chk[i], i);
		end

	endfunction


	// tasks for pre_test, test, post_test, run?
	task pre_test();
		// initialization, reset n stuf
		//drv.reset;

	endtask

	task do_test();
		// fork main()s
		fork
			gen.main;
			agt.main;
			drv[0].main; // etc
			drv[1].main;
			drv[2].main;
			drv[3].main;
			scb.main;
			mon[0].main;
			mon[1].main;
			mon[2].main;
			mon[3].main;
			chk.main;
		join_any
	endtask

	task post_test();
		wait(gen.ended.triggered());
		//wait(gen.repeat_count == drv.trans_count);
		wait(gen.repeat_count == scb.trans_count);
	endtask

	task run;
		pre_test();
		do_test();
		post_test();
		$finish;
	endtask

endclass
