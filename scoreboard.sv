`include "uvm_macros.svh"
import uvm_pkg::*;


// decalares a new analysis import type
`uvm_analysis_imp_decl(_axi_gpio_monitor)


class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)


	uvm_analysis_imp_axi_gpio_monitor #(axi_gpio_transaction, scoreboard) axi_gpio_imp_monitor;

    virtual axi4Lite_intf axi4Lite;
	int registerBank[7];


	function new(string name="", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new


	virtual function void build_phase(uvm_phase phase);
		axi_gpio_imp_monitor = new("axi_gpio_imp_monitor", this);
	endfunction


	virtual function void connect_phase(uvm_phase phase);
        uvm_config_db#(virtual axi4Lite_intf)::get(null, "", "axi4Lite_interface", axi4Lite);
	endfunction


	// this function must be implemented when using an analysis import
	//	it is automatically called by the imp with the associated name
	virtual function void write_axi_gpio_monitor(axi_gpio_transaction monitorItem);
		if (monitorItem.writeEnable == 1) begin
			registerBank[monitorItem.addr/4] = monitorItem.writeData;
		end
		else begin
			if(monitorItem.readData != registerBank[monitorItem.addr/4])
				`uvm_error("DUT_ERROR", $psprintf("Read mismatch on address %0h, expected %0h, received %0h", monitorItem.addr, registerBank[monitorItem.addr/4], monitorItem.readData))
		end
	endfunction


	task modelCounterRegister();
		forever begin
			@(posedge axi4Lite.s_axi_aclk);
			if(registerBank[0][5] == 1) begin 				// counter update from load module
				registerBank[2] = registerBank[1];
			end
			else begin
				if(registerBank[0][7] == 1) begin 			// normal operation
					registerBank[2] = #0 registerBank[2]+1;

					if(registerBank[2] == 0) begin // roll-over detected
						// check generateout0 output, if it is enabled; this is a naive checking since we only verify it when it should be set
						//	cases such as setting when it shouldn't will not be caught by this checking method
						if(registerBank[0][2] == 1 && timerIntf.generateout0 != 0) 
							`uvm_error("DUT_ERROR", $psprintf("Mismatch detected on generateout0, expected 0, received %0b", timerIntf.generateout0))
						
						if(registerBank[0][4] == 0) registerBank[0][7] = 0; // auto-reload disabled
						else registerBank[2] = registerBank[1]; // auto-reload enabled
					end
				end
			end
		end
	endtask


	virtual task run_phase(uvm_phase phase);
		fork
			modelCounterRegister();
		join
	endtask


endclass
