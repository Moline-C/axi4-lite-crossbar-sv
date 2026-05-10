`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi4_lite_if.sv"
`include "axi4_lite_transaction.sv"
`include "axi4_lite_sequence.sv"
`include "axi4_lite_driver.sv"
`include "axi4_lite_monitor.sv"
`include "axi4_lite_scoreboard.sv"
`include "axi4_lite_coverage.sv"
`include "axi4_lite_env.sv"
`include "axi4_lite_test.sv"

module axi4_lite_uvm_tb;

    localparam int NUM_INITIATORS = 2;
    localparam int NUM_TARGETS = 2;
    localparam int DATA_WIDTH = 32;
    localparam int ADDR_WIDTH = 32;

    logic clk;
    logic rst;

    initial clk = 0;
    always #5 clk = ~clk;

    // interface instantiation
    axi4_lite_if #(
        .NUM_INITIATORS(NUM_INITIATORS),
        .NUM_TARGETS(NUM_TARGETS),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) axi_if (
        .clk(clk),
        .rst(rst)
    );

    // DUT instantiation
    axi4_lite_crossbar #(
        .NUM_INITIATORS(NUM_INITIATORS),
        .NUM_TARGETS(NUM_TARGETS),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .awvalid(axi_if.awvalid),
        .awready(axi_if.awready),
        .awaddr(axi_if.awaddr),
        .wvalid(axi_if.wvalid),
        .wready(axi_if.wready),
        .wdata(axi_if.wdata),
        .wstrb(axi_if.wstrb),
        .bvalid(axi_if.bvalid),
        .bready(axi_if.bready),
        .bresp(axi_if.bresp),
        .arvalid(axi_if.arvalid),
        .arready(axi_if.arready),
        .araddr(axi_if.araddr),
        .rvalid(axi_if.rvalid),
        .rready(axi_if.rready),
        .rdata(axi_if.rdata),
        .rresp(axi_if.rresp),
        .t_awvalid(axi_if.t_awvalid),
        .t_awready(axi_if.t_awready),
        .t_awaddr(axi_if.t_awaddr),
        .t_wvalid(axi_if.t_wvalid),
        .t_wready(axi_if.t_wready),
        .t_wdata(axi_if.t_wdata),
        .t_wstrb(axi_if.t_wstrb),
        .t_bvalid(axi_if.t_bvalid),
        .t_bready(axi_if.t_bready),
        .t_bresp(axi_if.t_bresp),
        .t_arvalid(axi_if.t_arvalid),
        .t_arready(axi_if.t_arready),
        .t_araddr(axi_if.t_araddr),
        .t_rvalid(axi_if.t_rvalid),
        .t_rready(axi_if.t_rready),
        .t_rdata(axi_if.t_rdata),
        .t_rresp(axi_if.t_rresp)
    );

    // target instantiation
    axi4_lite_target #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_REGS(4)
    ) target0 (
        .clk(clk),
        .rst(rst),
        .awvalid(axi_if.t_awvalid[0]),
        .awready(axi_if.t_awready[0]),
        .awaddr(axi_if.t_awaddr[0]),
        .wvalid(axi_if.t_wvalid[0]),
        .wready(axi_if.t_wready[0]),
        .wdata(axi_if.t_wdata[0]),
        .wstrb(axi_if.t_wstrb[0]),
        .bvalid(axi_if.t_bvalid[0]),
        .bready(axi_if.t_bready[0]),
        .bresp(axi_if.t_bresp[0]),
        .arvalid(axi_if.t_arvalid[0]),
        .arready(axi_if.t_arready[0]),
        .araddr(axi_if.t_araddr[0]),
        .rvalid(axi_if.t_rvalid[0]),
        .rready(axi_if.t_rready[0]),
        .rdata(axi_if.t_rdata[0]),
        .rresp(axi_if.t_rresp[0])
    );

    axi4_lite_target #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_REGS(4)
    ) target1 (
        .clk(clk),
        .rst(rst),
        .awvalid(axi_if.t_awvalid[1]),
        .awready(axi_if.t_awready[1]),
        .awaddr(axi_if.t_awaddr[1]),
        .wvalid(axi_if.t_wvalid[1]),
        .wready(axi_if.t_wready[1]),
        .wdata(axi_if.t_wdata[1]),
        .wstrb(axi_if.t_wstrb[1]),
        .bvalid(axi_if.t_bvalid[1]),
        .bready(axi_if.t_bready[1]),
        .bresp(axi_if.t_bresp[1]),
        .arvalid(axi_if.t_arvalid[1]),
        .arready(axi_if.t_arready[1]),
        .araddr(axi_if.t_araddr[1]),
        .rvalid(axi_if.t_rvalid[1]),
        .rready(axi_if.t_rready[1]),
        .rdata(axi_if.t_rdata[1]),
        .rresp(axi_if.t_rresp[1])
    );

    initial begin
        // put interface in config db for UVM components to find
        uvm_config_db #(virtual axi4_lite_if)::set(null, "uvm_test_top.*", "vif", axi_if);

        // reset sequence
        rst = 1;
        repeat(10) @(posedge clk);
        rst = 0;
        repeat(5) @(posedge clk);

        // run the test
        run_test("axi4_lite_test");
    end

endmodule