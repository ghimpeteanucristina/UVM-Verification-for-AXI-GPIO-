`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_gpio_transaction extends uvm_sequence_item;

    `uvm_object_utils(axi_gpio_transaction)

    // Existing fields
    logic [31:0] readData;
    rand logic [31:0] writeData;
    rand logic        writeEnable;
    rand logic [8:0]  addr;

    // New fields for GPIO-specific functionalities
    logic [31:0] gpioDirection;  // GPIO direction (tri-state control)
    rand logic [31:0] gpioValue;      // GPIO input value

    constraint c_addr_gpio {
        (addr % 4) == 0;// alligned address
         addr >= 'h0 && addr <= 'h4; // GPIO_DATA, GPIO_TRI - only registers
    }


    function new(string name="axi_gpio_transaction");
        super.new(name);

        readData = 0;
        writeData = 0;
        writeEnable = 0;
        addr = 0;

        // Initialize new fields
        gpioValue = 32'h0;            // Default all inputs low
        
    endfunction : new

    function string convert2string();
        string outputString = "";

        outputString = $sformatf("%s\n\t * readData=%0h", outputString, readData);
        outputString = $sformatf("%s\n\t * writeData=%0h", outputString, writeData);
        outputString = $sformatf("%s\n\t * addr=%0h", outputString, addr);
        outputString = $sformatf("%s\n\t * writeEnable=%0b", outputString, writeEnable);
        outputString = $sformatf("%s\n\t * gpioDirection=%0h", outputString, gpioDirection);
        outputString = $sformatf("%s\n\t * gpioValue=%0h", outputString, gpioValue);


        return outputString;
    endfunction

endclass : axi_gpio_transaction
