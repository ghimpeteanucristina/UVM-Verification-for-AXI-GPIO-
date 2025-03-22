`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_gpio_write_data_Sequence extends axi_gpio_baseSequence;

    `uvm_object_utils(axi_gpio_write_data_Sequence)

    // Constructor
    function new(string name="axi_gpio_write_data_Sequence");
        super.new(name);
    endfunction : new

    // Main task to generate AXI and GPIO traffic
    virtual task body();
        axi_gpio_item = axi_gpio_transaction::type_id::create("axi_gpio_item");

        `uvm_info("axi_gpio_write_Sequence", $sformatf("Generating %d AXI and GPIO transactions", numberOfAccesses), UVM_NONE)

        
            start_item(axi_gpio_item);

            axi_gpio_item.randomize() with {
                // Constraints for transaction fields - write transaction ro GPIO_DATA reg
                //writeData == 32'hFFFFFFFF ; 
                writeEnable ==  1'b1;    
                addr == 9'h000 ;    
             };           

            finish_item(axi_gpio_item);
        

        `uvm_info("axi_gpio_write_data_Sequence", "Completed AXI and GPIO write data transaction generation", UVM_NONE)
    endtask : body

endclass : axi_gpio_write_data_Sequence

class axi_gpio_write_tri_Sequence extends axi_gpio_baseSequence;

    `uvm_object_utils(axi_gpio_write_tri_Sequence)

    // Constructor
    function new(string name="axi_gpio_write_tri_Sequence");
        super.new(name);
    endfunction : new

    // Main task to generate AXI and GPIO traffic
    virtual task body();
        axi_gpio_item = axi_gpio_transaction::type_id::create("axi_gpio_item");

        `uvm_info("axi_gpio_write_Sequence", $sformatf("Generating %d AXI and GPIO transactions", numberOfAccesses), UVM_NONE)

        
            start_item(axi_gpio_item);

            axi_gpio_item.randomize() with {
                // Constraints for transaction fields - write transaction ro GPIO_DATA reg
                //writeData == 32'hFFFFFFFF ; 
                writeEnable ==  1'b1;    
                addr == 9'h004 ;    
             };           

            finish_item(axi_gpio_item);
        

        `uvm_info("axi_gpio_write_tri_Sequence", "Completed AXI and GPIO write tri transaction generation", UVM_NONE)
    endtask : body

endclass : axi_gpio_write_tri_Sequence

class axi_gpio_write_tri_all_inputs_Sequence extends axi_gpio_baseSequence;

    `uvm_object_utils(axi_gpio_write_tri_all_inputs_Sequence)

    // Constructor
    function new(string name="axi_gpio_write_tri_all_inputs_Sequence");
        super.new(name);
    endfunction : new

    // Main task to generate AXI and GPIO traffic
    virtual task body();
        axi_gpio_item = axi_gpio_transaction::type_id::create("axi_gpio_item");

        `uvm_info("axi_gpio_write_Sequence", $sformatf("Generating %d AXI and GPIO transactions", numberOfAccesses), UVM_NONE)

        
            start_item(axi_gpio_item);

            axi_gpio_item.randomize() with {
                // Constraints for transaction fields - write transaction ro GPIO_DATA reg
                writeData == 32'hFFFFFFFF ; 
                writeEnable ==  1'b1;    
                addr == 9'h004 ;    
             };           

            finish_item(axi_gpio_item);
        

        `uvm_info("axi_gpio_write_tri_all_inputs_Sequence", "Completed AXI and GPIO write tri all_inputs_ transaction generation", UVM_NONE)
    endtask : body

endclass : axi_gpio_write_tri_all_inputs_Sequence 

class axi_gpio_write_tri_all_outputs_Sequence extends axi_gpio_baseSequence;

    `uvm_object_utils(axi_gpio_write_tri_all_outputs_Sequence)

    // Constructor
    function new(string name="axi_gpio_write_tri_all_outputs_Sequence");
        super.new(name);
    endfunction : new

    // Main task to generate AXI and GPIO traffic
    virtual task body();
        axi_gpio_item = axi_gpio_transaction::type_id::create("axi_gpio_item");

        
            start_item(axi_gpio_item);

            axi_gpio_item.randomize() with {
                // Constraints for transaction fields - write transaction ro GPIO_DATA reg
                writeData == 32'h0 ; 
                writeEnable ==  1'b1;    
                addr == 9'h004 ;    
             };           

            finish_item(axi_gpio_item);
        

        `uvm_info("axi_gpio_write_tri_all_outputs_Sequence", "Completed AXI and GPIO write tri all_outputs_ transaction generation", UVM_NONE)
    endtask : body

endclass : axi_gpio_write_tri_all_outputs_Sequence 


class axi_gpio_read_data_Sequence extends axi_gpio_baseSequence;

    `uvm_object_utils(axi_gpio_read_data_Sequence)

    // Constructor
    function new(string name="axi_gpio_read_data_Sequence");
        super.new(name);
    endfunction : new

    // Main task to generate AXI and GPIO traffic
    virtual task body();
        axi_gpio_item = axi_gpio_transaction::type_id::create("axi_gpio_item");

        
            start_item(axi_gpio_item);

            axi_gpio_item.randomize() with {
                // Constraints for transaction fields 
                writeEnable ==  1'b0;    
                addr == 9'h000 ;    
             };           

            finish_item(axi_gpio_item);
        

        `uvm_info("axi_gpio_write_data_Sequence", "Completed AXI and GPIO write data transaction generation", UVM_NONE)
    endtask : body

endclass : axi_gpio_read_data_Sequence

class axi_gpio_read_tri_Sequence extends axi_gpio_baseSequence;

    `uvm_object_utils(axi_gpio_read_tri_Sequence)

    // Constructor
    function new(string name="axi_gpio_read_tri_Sequence");
        super.new(name);
    endfunction : new

    // Main task to generate AXI and GPIO traffic
    virtual task body();
        axi_gpio_item = axi_gpio_transaction::type_id::create("axi_gpio_item");
        
            start_item(axi_gpio_item);

            axi_gpio_item.randomize() with {
                // Constraints for transaction fields 
                writeEnable ==  1'b0;    
                addr == 9'h004 ;    
             };           

            finish_item(axi_gpio_item);
        

        `uvm_info("axi_gpio_read_tri_Sequence", "Completed AXI and GPIO read tri transaction generation", UVM_NONE)
    endtask : body

endclass : axi_gpio_read_tri_Sequence