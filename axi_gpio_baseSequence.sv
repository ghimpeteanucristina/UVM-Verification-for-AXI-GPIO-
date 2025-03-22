`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_gpio_baseSequence extends uvm_sequence #(axi_gpio_transaction);
	
	`uvm_object_utils (axi_gpio_baseSequence)


	axi_gpio_transaction axi_gpio_item;
	int numberOfAccesses;


	function new(string name="axi_gpio_baseSequence");
		super.new(name);
	endfunction : new


	virtual task body();
		axi_gpio_item = axi_gpio_transaction::type_id::create("axi_gpio_item");

		`uvm_info("axi_gpio_baseSequence", $sformatf("Going to generate %d axi_gpio transactions", numberOfAccesses), UVM_NONE)
		
		repeat(numberOfAccesses) begin
			start_item(axi_gpio_item);
			axi_gpio_item.randomize() with {
                // Constraints for transaction fields
                //writeData == 'h5; // Full range of 32-bit values
                addr inside {[9'h000 : 9'h005]};                // 9-bit address range
        
                // GPIO-specific constraints
                gpioValue inside {[32'h00000000 : 32'hFFFFFFFF]};     // Full range of 32-bit values
        };
			finish_item(axi_gpio_item);
		end

		`uvm_info("axi_gpio_baseSequence", $sformatf("Finished generating axi_gpio transactions"), UVM_NONE)
	endtask : body


endclass : axi_gpio_baseSequence

