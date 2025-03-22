`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_gpio_agent extends uvm_agent;

	`uvm_component_utils(axi_gpio_agent)


	axi_gpio_monitor monitor;
	axi_gpio_driver driver;
	uvm_sequencer #(axi_gpio_transaction) sequencer;


	function new(string name="", uvm_component parent=null);
		super.new(name, parent);
	endfunction


	virtual function void build_phase(uvm_phase phase);
		sequencer = uvm_sequencer#(axi_gpio_transaction)::type_id::create("sequencer", this);
		driver 	  = axi_gpio_driver::type_id::create("driver", this);
		monitor   = axi_gpio_monitor::type_id::create("monitor", this);
	endfunction


	virtual function void connect_phase(uvm_phase phase);
		driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction


endclass

