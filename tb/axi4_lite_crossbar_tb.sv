module axi4_lite_crossbar_tb;
    localparam int NUM_INITIATORS = 2;
    localparam int NUM_TARGETS = 2;
    localparam int DATA_WIDTH = 32;
    localparam int ADDR_WIDTH = 32;

    logic clk;
    logic rst;

    logic [NUM_INITIATORS-1:0] awvalid;
    logic [NUM_INITIATORS-1:0] awready;
    logic [NUM_INITIATORS-1:0][ADDR_WIDTH-1:0] awaddr;
    logic [NUM_INITIATORS-1:0] wvalid;
    logic [NUM_INITIATORS-1:0] wready;
    logic [NUM_INITIATORS-1:0][DATA_WIDTH-1:0] wdata;
    logic [NUM_INITIATORS-1:0][DATA_WIDTH/8-1:0] wstrb;
    logic [NUM_INITIATORS-1:0] bvalid;
    logic [NUM_INITIATORS-1:0] bready;
    logic [NUM_INITIATORS-1:0][1:0] bresp;
    logic [NUM_INITIATORS-1:0] arvalid;
    logic [NUM_INITIATORS-1:0] arready;
    logic [NUM_INITIATORS-1:0][ADDR_WIDTH-1:0] araddr;
    logic [NUM_INITIATORS-1:0] rvalid;
    logic [NUM_INITIATORS-1:0] rready;
    logic [NUM_INITIATORS-1:0][DATA_WIDTH-1:0] rdata;
    logic [NUM_INITIATORS-1:0][1:0] rresp;

    logic [NUM_TARGETS-1:0] t_awvalid;
    logic [NUM_TARGETS-1:0] t_awready;
    logic [NUM_TARGETS-1:0][ADDR_WIDTH-1:0] t_awaddr;
    logic [NUM_TARGETS-1:0] t_wvalid;
    logic [NUM_TARGETS-1:0] t_wready;
    logic [NUM_TARGETS-1:0][DATA_WIDTH-1:0] t_wdata;
    logic [NUM_TARGETS-1:0][DATA_WIDTH/8-1:0] t_wstrb;
    logic [NUM_TARGETS-1:0] t_bvalid;
    logic [NUM_TARGETS-1:0] t_bready;
    logic [NUM_TARGETS-1:0][1:0] t_bresp;
    logic [NUM_TARGETS-1:0] t_arvalid;
    logic [NUM_TARGETS-1:0] t_arready;
    logic [NUM_TARGETS-1:0][ADDR_WIDTH-1:0] t_araddr;
    logic [NUM_TARGETS-1:0] t_rvalid;
    logic [NUM_TARGETS-1:0] t_rready;
    logic [NUM_TARGETS-1:0][DATA_WIDTH-1:0] t_rdata;
    logic [NUM_TARGETS-1:0][1:0] t_rresp;

    axi4_lite_crossbar #(
        .NUM_INITIATORS(NUM_INITIATORS),
        .NUM_TARGETS(NUM_TARGETS),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
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
        .rresp(rresp),
        .t_awvalid(t_awvalid),
        .t_awready(t_awready),
        .t_awaddr(t_awaddr),
        .t_wvalid(t_wvalid),
        .t_wready(t_wready),
        .t_wdata(t_wdata),
        .t_wstrb(t_wstrb),
        .t_bvalid(t_bvalid),
        .t_bready(t_bready),
        .t_bresp(t_bresp),
        .t_arvalid(t_arvalid),
        .t_arready(t_arready),
        .t_araddr(t_araddr),
        .t_rvalid(t_rvalid),
        .t_rready(t_rready),
        .t_rdata(t_rdata),
        .t_rresp(t_rresp)
    );

    axi4_lite_target #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_REGS(4)
    ) target0 (
        .clk(clk),
        .rst(rst),
        .awvalid(t_awvalid[0]),
        .awready(t_awready[0]),
        .awaddr(t_awaddr[0]),
        .wvalid(t_wvalid[0]),
        .wready(t_wready[0]),
        .wdata(t_wdata[0]),
        .wstrb(t_wstrb[0]),
        .bvalid(t_bvalid[0]),
        .bready(t_bready[0]),
        .bresp(t_bresp[0]),
        .arvalid(t_arvalid[0]),
        .arready(t_arready[0]),
        .araddr(t_araddr[0]),
        .rvalid(t_rvalid[0]),
        .rready(t_rready[0]),
        .rdata(t_rdata[0]),
        .rresp(t_rresp[0])
    );

    axi4_lite_target #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_REGS(4)
    ) target1 (
        .clk(clk),
        .rst(rst),
        .awvalid(t_awvalid[1]),
        .awready(t_awready[1]),
        .awaddr(t_awaddr[1]),
        .wvalid(t_wvalid[1]),
        .wready(t_wready[1]),
        .wdata(t_wdata[1]),
        .wstrb(t_wstrb[1]),
        .bvalid(t_bvalid[1]),
        .bready(t_bready[1]),
        .bresp(t_bresp[1]),
        .arvalid(t_arvalid[1]),
        .arready(t_arready[1]),
        .araddr(t_araddr[1]),
        .rvalid(t_rvalid[1]),
        .rready(t_rready[1]),
        .rdata(t_rdata[1]),
        .rresp(t_rresp[1])
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task axi_write(
        input int initiator,
        input logic [ADDR_WIDTH-1:0] addr,
        input logic [DATA_WIDTH-1:0] data,
        input logic [DATA_WIDTH/8-1:0] strb
    );
        // hold awvalid and wvalid high until bvalid arrives
        awvalid[initiator] = 1;
        awaddr[initiator] = addr;
        wvalid[initiator] = 1;
        wdata[initiator] = data;
        wstrb[initiator] = strb;

        // wait for bvalid - keep signals high the whole time
        @(posedge clk); #1;
        while (!bvalid[initiator]) begin @(posedge clk); #1; end

        // transaction complete - deassert and acknowledge
        awvalid[initiator] = 0;
        wvalid[initiator] = 0;
        bready[initiator] = 1;
        @(posedge clk); #1;
        bready[initiator] = 0;
    endtask

    task axi_read(
        input int initiator,
        input logic [ADDR_WIDTH-1:0] addr,
        output logic [DATA_WIDTH-1:0] data
    );
        arvalid[initiator] = 1;
        araddr[initiator] = addr;

        // hold arvalid high until rvalid arrives
        @(posedge clk); #1;
        while (!rvalid[initiator]) begin @(posedge clk); #1; end

        // capture data while rvalid is still high
        data = rdata[initiator];
        
        // transaction complete
        arvalid[initiator] = 0;
        rready[initiator] = 1;
        @(posedge clk); #1;
        rready[initiator] = 0;
    endtask

    logic [DATA_WIDTH-1:0] read_data;

    initial begin
        rst = 1;
        awvalid = 0;
        awaddr = 0;
        wvalid = 0;
        wdata = 0;
        wstrb = 0;
        bready = 0;
        arvalid = 0;
        araddr = 0;
        rready = 0;

        repeat(10) @(posedge clk); #1;
        rst = 0;
        repeat(5) @(posedge clk); #1;

        $display("Test 1: initiator 0 writing to target 0");
        axi_write(0, 32'h00000000, 32'hDEADBEEF, 4'hF);
        repeat(2) @(posedge clk); #1;

        $display("Test 2: initiator 0 writing to target 1");
        axi_write(0, 32'h80000000, 32'h12345678, 4'hF);
        repeat(2) @(posedge clk); #1;

        $display("Test 3: initiator 0 reading from target 0");
        axi_read(0, 32'h00000000, read_data);
        if (read_data == 32'hDEADBEEF)
            $display("PASS: target 0 got 0x%h", read_data);
        else
            $display("FAIL: target 0 expected 0xDEADBEEF, got 0x%h", read_data);

        $display("Test 4: initiator 0 reading from target 1");
        axi_read(0, 32'h80000000, read_data);
        if (read_data == 32'h12345678)
            $display("PASS: target 1 got 0x%h", read_data);
        else
            $display("FAIL: target 1 expected 0x12345678, got 0x%h", read_data);

        repeat(4) @(posedge clk);
        $display("Simulation complete");
        $finish;
    end

endmodule