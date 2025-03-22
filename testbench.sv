`timescale 1ns / 1ps

import uvm_pkg::*; // Import UVM package
//`include "axi4Lite_intf.sv"      // Interfa?a AXI4-Lite
//`include "environment.sv"        // Environment UVM
//`include "base_test.sv"          // Testul de bazã
module testbench();

// ------ Signals declaration ------ //
// Inputs
logic s_axi_aclk;
logic s_axi_aresetn;

logic [8:0] s_axi_awaddr;
logic s_axi_awvalid;
logic [31:0] s_axi_wdata;
logic [3:0] s_axi_wstrb;
logic s_axi_wvalid;
logic s_axi_bready;
logic [8:0] s_axi_araddr;
logic s_axi_arvalid;
logic s_axi_rready;


// GPIO inputs
logic [31:0] gpio_io_i;

// Outputs
logic s_axi_awready;
logic s_axi_wready;
logic [1:0] s_axi_bresp;
logic s_axi_bvalid;
logic s_axi_arready;
logic [31:0] s_axi_rdata;
logic [1:0] s_axi_rresp;
logic s_axi_rvalid;

// GPIO outputs
logic [31:0] gpio_io_o;
logic [31:0] gpio_io_t;

// ------- DUT instantiation ------- //
axi_gpio_wrapper dut_inst (
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .gpio_io_i(gpio_io_i),
    .gpio_io_o(gpio_io_o),
    .gpio_io_t(gpio_io_t)
);

// ------- Interface instantiation ------- //
axi4Lite_intf axi4Lite_if();

// ------- Clock generation ------- //
initial begin
    s_axi_aclk = 0;
    forever #5 s_axi_aclk = ~s_axi_aclk;
end

// ------- Signals assignments ------- //
assign axi4Lite_if.s_axi_aclk    = s_axi_aclk;
assign axi4Lite_if.s_axi_awready = s_axi_awready;
assign axi4Lite_if.s_axi_wready  = s_axi_wready;
assign axi4Lite_if.s_axi_bresp   = s_axi_bresp;
assign axi4Lite_if.s_axi_bvalid  = s_axi_bvalid;
assign axi4Lite_if.s_axi_arready = s_axi_arready;
assign axi4Lite_if.s_axi_rdata   = s_axi_rdata;
assign axi4Lite_if.s_axi_rresp   = s_axi_rresp;
assign axi4Lite_if.s_axi_rvalid  = s_axi_rvalid;

assign s_axi_aresetn = axi4Lite_if.s_axi_aresetn;
assign s_axi_awaddr  = axi4Lite_if.s_axi_awaddr;
assign s_axi_awvalid = axi4Lite_if.s_axi_awvalid;
assign s_axi_wdata   = axi4Lite_if.s_axi_wdata;
assign s_axi_wstrb   = axi4Lite_if.s_axi_wstrb;
assign s_axi_wvalid  = axi4Lite_if.s_axi_wvalid;
assign s_axi_bready  = axi4Lite_if.s_axi_bready;
assign s_axi_araddr  = axi4Lite_if.s_axi_araddr;
assign s_axi_arvalid = axi4Lite_if.s_axi_arvalid;
assign s_axi_rready  = axi4Lite_if.s_axi_rready;

// GPIO signal assignments
assign gpio_io_i = axi4Lite_if.gpio_io_i;
assign axi4Lite_if.gpio_io_o = gpio_io_o;
assign axi4Lite_if.gpio_io_t = gpio_io_t;

// ------- Run a test ------- //
initial begin
    uvm_config_db#(virtual axi4Lite_intf)::set(null, "", "axi4Lite_interface", axi4Lite_if);

    run_test("axi_gpio_test");
end

endmodule
