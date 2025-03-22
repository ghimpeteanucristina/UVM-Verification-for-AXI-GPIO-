`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_gpio_monitor extends uvm_monitor;

    `uvm_component_utils(axi_gpio_monitor)

    uvm_analysis_port #(axi_gpio_transaction) analysisPort;

    virtual axi4Lite_intf axi4Lite_interface;

    function new(string name="", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysisPort = new("axi_gpioAnalysisPort", this);

        if (!uvm_config_db#(virtual axi4Lite_intf)::get(this, "", "axi4Lite_interface", axi4Lite_interface)) begin
            `uvm_fatal("BUILD", "Failed to get axi4Lite_interface")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork
            monitor_axi_writes();
            monitor_axi_reads();
        join
    endtask

    // Monitor AXI write transactions
    virtual task monitor_axi_writes();
        forever begin
            axi_gpio_transaction axi_gpio_item;
            axi_gpio_item = axi_gpio_transaction::type_id::create("axi_gpio_item_write");

            // Wait for a valid write address and data handshake
            wait(axi4Lite_interface.s_axi_awvalid && axi4Lite_interface.s_axi_awready &&
                 axi4Lite_interface.s_axi_wvalid && axi4Lite_interface.s_axi_wready);
            @(posedge axi4Lite_interface.s_axi_aclk);

            // Capture address and write data
            axi_gpio_item.writeEnable = 1;
            axi_gpio_item.addr = axi4Lite_interface.s_axi_awaddr;
            axi_gpio_item.writeData = axi4Lite_interface.s_axi_wdata;

            // Wait for write response (BVALID)
            wait(axi4Lite_interface.s_axi_bvalid);
            @(posedge axi4Lite_interface.s_axi_aclk);

            // Determine if it's a GPIO-specific transaction
            axi_gpio_item.gpioValue = axi4Lite_interface.gpio_io_i;

            `uvm_info("axi_gpio_monitor", $sformatf("Detected a new AXI write: %s", axi_gpio_item.convert2string()), UVM_LOW)
            analysisPort.write(axi_gpio_item);
        end
    endtask

    // Monitor AXI read transactions
    virtual task monitor_axi_reads();
        forever begin
            axi_gpio_transaction axi_gpio_item;
            axi_gpio_item = axi_gpio_transaction::type_id::create("axi_gpio_item_read");

            // Wait for a valid read address handshake
            wait(axi4Lite_interface.s_axi_arvalid && axi4Lite_interface.s_axi_arready);
            @(posedge axi4Lite_interface.s_axi_aclk);

            // Capture address
            axi_gpio_item.addr = axi4Lite_interface.s_axi_araddr;

            // Wait for read data (RVALID)
            wait(axi4Lite_interface.s_axi_rvalid);
            @(posedge axi4Lite_interface.s_axi_aclk);

            // Capture read data
            axi_gpio_item.readData = axi4Lite_interface.s_axi_rdata;

            // Determine if it's a GPIO-specific transaction
            //axi_gpio_item.gpioEnable = (axi_gpio_item.addr == 'h0 || axi_gpio_item.addr == 'h4);

            `uvm_info("axi_gpio_monitor", $sformatf("Detected a new AXI read: %s", axi_gpio_item.convert2string()), UVM_LOW)
            analysisPort.write(axi_gpio_item);
        end
    endtask

endclass
