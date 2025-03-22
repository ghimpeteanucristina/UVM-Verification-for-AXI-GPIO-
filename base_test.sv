`include "uvm_macros.svh"
import uvm_pkg::*;
`include "environment.sv"        // Environment UVM

class base_test extends uvm_test;
    // factory registration
    `uvm_component_utils(base_test)

    environment env;
    
    // constructor
    function new(string name="base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        env = environment::type_id::create("env", this);
    endfunction
    
    virtual function void connect_phase (uvm_phase phase);
        // connect all sub-components
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        virtual axi4Lite_intf axi4Lite;
        axi_gpio_baseSequence baseSeq;
        
        uvm_config_db#(virtual axi4Lite_intf)::get(null, "", "axi4Lite_interface", axi4Lite);
        baseSeq = axi_gpio_baseSequence::type_id::create("baseSeq");

        phase.raise_objection(this);        
        
        // 'main' function of this component
        // reset the module
        axi4Lite.s_axi_aresetn = 0;
        repeat(5) @(posedge axi4Lite.s_axi_aclk);
        axi4Lite.s_axi_aresetn = 1;

        // generate 5 random axi_gpio transactions
        baseSeq.numberOfAccesses=15;
        baseSeq.start(env.agent.sequencer);

        `uvm_info("base_test", "This is a message", UVM_NONE)
        `uvm_info("base_test", "This is another message", UVM_NONE)

        `uvm_info("base_test", "Waiting for 100 clk cycles...", UVM_NONE)
        repeat(100) @(posedge axi4Lite.s_axi_aclk);
        `uvm_info("base_test", "Waiting for 100 clk cycles... DONE", UVM_NONE)
        
        phase.drop_objection(this);
    endtask
endclass
