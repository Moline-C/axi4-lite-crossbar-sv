module axi4_lite_target_tb;

    localparam int DATA_WIDTH = 32;
    localparam int ADDR_WIDTH = 32;
    localparam int NUM_REGS   = 4;

    logic clk;
    logic rst;

    logic                    awvalid;
    logic                    awready;
    logic [ADDR_WIDTH-1:0]   awaddr;

    logic                    wvalid;
    logic                    wready;
    logic [DATA_WIDTH-1:0]   wdata;
    logic [DATA_WIDTH/8-1:0] wstrb;

    logic                    bvalid;
    logic                    bready;
    logic [1:0]              bresp;

    logic                    arvalid;
    logic                    arready;
    logic [ADDR_WIDTH-1:0]   araddr;

    logic                    rvalid;
    logic                    rready;
    logic [DATA_WIDTH-1:0]   rdata;
    logic [1:0]              rresp;

    axi4_lite_target #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_REGS(NUM_REGS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .awvalid(awvalid),
        .awready(awready),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wready(wready),
        .wdata(wdata),
        .wstrb(wstrb),
        .bvalid(bvalid),
        .bready(bready),
        .bresp(bresp),
        .arvalid(arvalid),
        .arready(arready),
        .araddr(araddr),
        .rvalid(rvalid),
        .rready(rready),
        .rdata(rdata),
        .rresp(rresp)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task axi_write(
    input logic [ADDR_WIDTH-1:0] addr,
    input logic [DATA_WIDTH-1:0] data,
    input logic [DATA_WIDTH/8-1:0] strb
);
    // present address and data
    awvalid = 1;
    awaddr  = addr;
    wvalid  = 1;
    wdata   = data;
    wstrb   = strb;

    // wait for write address handshake
    @(posedge clk iff (awvalid && awready));
    #1;
    awvalid = 0;

    // wait for write data handshake
    @(posedge clk iff (wvalid && wready));
    #1;
    wvalid = 0;

    // wait for write response handshake
    @(posedge clk iff bvalid);
    #1;
    bready = 1;
    @(posedge clk);
    #1;
    bready = 0;
    endtask

    task axi_read(
    input  logic [ADDR_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] data
);
    arvalid = 1;
    araddr  = addr;

    // wait for read address handshake
    @(posedge clk iff (arvalid && arready));
    #1;
    arvalid = 0;

    // wait for read data handshake
    @(posedge clk iff rvalid);
    #1;
    rready = 1;
    @(posedge clk);
    #1;
    data   = rdata;
    rready = 0;
    endtask

    logic [DATA_WIDTH-1:0] read_data;

    initial begin
        rst     = 1;
        awvalid = 0;
        awaddr  = 0;
        wvalid  = 0;
        wdata   = 0;
        wstrb   = 0;
        bready  = 0;
        arvalid = 0;
        araddr  = 0;
        rready  = 0;

        // hold reset for 10 cycles to ensure clean startup
        repeat(10) @(posedge clk);
        #1;
        rst = 0;

        // wait 5 more cycles after reset before starting
        repeat(5) @(posedge clk);
        #1;

        $display("Writing 0xDEADBEEF to address 0x0");
        axi_write(32'h00, 32'hDEADBEEF, 4'hF);
        @(posedge clk); #1;
        @(posedge clk); #1;

        $display("Writing 0x12345678 to address 0x4");
        axi_write(32'h04, 32'h12345678, 4'hF);
        @(posedge clk); #1;
        @(posedge clk); #1;

        $display("Reading from address 0x0");
        axi_read(32'h00, read_data);
        if (read_data == 32'hDEADBEEF)
            $display("PASS: got 0x%h", read_data);
        else
            $display("FAIL: expected 0xDEADBEEF, got 0x%h", read_data);

        $display("Reading from address 0x4");
        axi_read(32'h04, read_data);
        if (read_data == 32'h12345678)
            $display("PASS: got 0x%h", read_data);
        else
            $display("FAIL: expected 0x12345678, got 0x%h", read_data);

        @(posedge clk); #1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        $display("Simulation complete");
        $finish;
    end

endmodule