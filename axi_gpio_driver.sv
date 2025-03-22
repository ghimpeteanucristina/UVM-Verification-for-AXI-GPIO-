`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_gpio_driver extends uvm_driver #(axi_gpio_transaction);

    `uvm_component_utils(axi_gpio_driver)

    virtual axi4Lite_intf axi4Lite_interface;

    function new(string name="", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi4Lite_intf)::get(this, "", "axi4Lite_interface", axi4Lite_interface))
            `uvm_fatal("BUILD", "Failed to get axi4Lite_interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        axi_gpio_transaction axi_gpio_item;

        forever begin
            seq_item_port.get_next_item(axi_gpio_item);

            `uvm_info("axi_gpio_driver", $sformatf("Processing transaction: %s", axi_gpio_item.convert2string()), UVM_MEDIUM)

            // Ensure AXI clock synchronization
            @(posedge axi4Lite_interface.s_axi_aclk);

            if (axi_gpio_item.writeEnable) begin
                perform_write(axi_gpio_item.addr, axi_gpio_item.writeData);
                configure_gpio( axi_gpio_item.gpioValue); // input data on gpio_io_i
            end else begin
                perform_read(axi_gpio_item.addr, axi_gpio_item.readData);
            end
                
            seq_item_port.item_done();
        end
    endtask

    // Perform an AXI write operation
    virtual task perform_write(logic [8:0] addr, logic [31:0] data);
        `uvm_info("axi_gpio_driver", $sformatf("Writing 0x%h to address 0x%h", data, addr), UVM_LOW)

        // Set address and data
        axi4Lite_interface.s_axi_awaddr = addr;
        axi4Lite_interface.s_axi_wdata  = data;
        axi4Lite_interface.s_axi_awvalid = 1;
        axi4Lite_interface.s_axi_wvalid  = 1;
        axi4Lite_interface.s_axi_wstrb  = 'b1111;

        // Wait for handshake
        wait(axi4Lite_interface.s_axi_awready && axi4Lite_interface.s_axi_wready);
        @(posedge axi4Lite_interface.s_axi_aclk);
        axi4Lite_interface.s_axi_awvalid = 0;
        axi4Lite_interface.s_axi_wvalid  = 0;

        // Wait for write response
        wait(axi4Lite_interface.s_axi_bvalid);
        @(posedge axi4Lite_interface.s_axi_aclk);
        axi4Lite_interface.s_axi_bready = 1;
        @(posedge axi4Lite_interface.s_axi_aclk);
        axi4Lite_interface.s_axi_bready = 0;
    endtask

    // Perform an AXI read operation
    virtual task perform_read(logic [8:0] addr, ref logic [31:0] data);
        `uvm_info("axi_gpio_driver", $sformatf("Reading from address 0x%h", addr), UVM_LOW)

        // Set address
        axi4Lite_interface.s_axi_araddr = addr;
        axi4Lite_interface.s_axi_arvalid = 1;

        // Wait for handshake
        wait(axi4Lite_interface.s_axi_arready);
        @(posedge axi4Lite_interface.s_axi_aclk);
        axi4Lite_interface.s_axi_arvalid = 0;

        // Wait for data
        wait(axi4Lite_interface.s_axi_rvalid);
        @(posedge axi4Lite_interface.s_axi_aclk);
        data = axi4Lite_interface.s_axi_rdata;

        // Acknowledge data
        axi4Lite_interface.s_axi_rready = 1;
        @(posedge axi4Lite_interface.s_axi_aclk);
        axi4Lite_interface.s_axi_rready = 0;
    endtask

    // Configure GPIO direction and value
    virtual task configure_gpio( logic [31:0] value);
        `uvm_info("axi_gpio_driver", $sformatf("Configuring GPIO:  Value=0x%h", value), UVM_LOW)

        // Drive GPIO input value for pins configured as input
        axi4Lite_interface.gpio_io_i = value;

        // Read back GPIO output values for pins configured as output
        `uvm_info("axi_gpio_driver", $sformatf("GPIO Input Value: 0x%h , Direction 0x%h", axi4Lite_interface.gpio_io_o,axi4Lite_interface.gpio_io_t), UVM_LOW)
    endtask

endclass