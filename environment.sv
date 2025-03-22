`include "uvm_macros.svh"
import uvm_pkg::*;

class environment extends uvm_env;
	`uvm_component_utils(environment)
	
	
	
     axi_gpio_agent agent;
     scoreboard sb;
     
     
	function new (string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		// Print a message just to demonstrate that the env is created and it works
		// We will add more functionality in the next lab
		`uvm_info("DEBUG", "The build_phase of the environment was called", UVM_NONE)
		
		agent = axi_gpio_agent::type_id::create("agent", this);
		sb = scoreboard::type_id::create("sb", this);

	endfunction
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		agent.monitor.analysisPort.connect(sb.axi_gpio_imp_monitor);
	endfunction

	
endclass : environment