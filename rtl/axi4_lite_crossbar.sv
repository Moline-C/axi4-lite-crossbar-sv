module axi4_lite_crossbar # (
    parameter int NUM_INITIATORS = 2,
    parameter int NUM_TARGETS = 2,
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic [NUM_INITIATORS-1:0] awvalid,
    output logic [NUM_INITIATORS-1:0] awready,
    input logic [NUM_INITIATORS-1:0][ADDR_WIDTH-1:0] awaddr,
    input logic [NUM_INITIATORS-1:0] wvalid,
    output logic [NUM_INITIATORS-1:0] wready,
    input logic [NUM_INITIATORS-1:0][DATA_WIDTH-1:0] wdata,
    input logic [NUM_INITIATORS-1:0][DATA_WIDTH/8-1:0] wstrb,
    output logic [NUM_INITIATORS-1:0] bvalid,
    input logic [NUM_INITIATORS-1:0] bready,
    output logic [NUM_INITIATORS-1:0][1:0] bresp,
    input logic [NUM_INITIATORS-1:0] arvalid,
    output logic [NUM_INITIATORS-1:0] arready,
    input logic [NUM_INITIATORS-1:0][ADDR_WIDTH-1:0] araddr,
    output logic [NUM_INITIATORS-1:0] rvalid,
    input logic [NUM_INITIATORS-1:0] rready,
    output logic [NUM_INITIATORS-1:0][DATA_WIDTH-1:0] rdata,
    output logic [NUM_INITIATORS-1:0][1:0] rresp,

    // target side
    output logic [NUM_TARGETS-1:0] t_awvalid,
    input logic [NUM_TARGETS-1:0] t_awready,
    output logic [NUM_TARGETS-1:0][ADDR_WIDTH-1:0] t_awaddr,
    output logic [NUM_TARGETS-1:0] t_wvalid,
    input logic [NUM_TARGETS-1:0] t_wready,
    output logic [NUM_TARGETS-1:0][DATA_WIDTH-1:0] t_wdata,
    output logic [NUM_TARGETS-1:0][DATA_WIDTH/8-1:0] t_wstrb,
    input logic [NUM_TARGETS-1:0] t_bvalid,
    output logic [NUM_TARGETS-1:0] t_bready,
    input logic [NUM_TARGETS-1:0][1:0] t_bresp,
    output logic [NUM_TARGETS-1:0] t_arvalid,
    input logic [NUM_TARGETS-1:0] t_arready,
    output logic [NUM_TARGETS-1:0][ADDR_WIDTH-1:0] t_araddr,
    input logic [NUM_TARGETS-1:0] t_rvalid,
    output logic [NUM_TARGETS-1:0] t_rready,
    input logic [NUM_TARGETS-1:0][DATA_WIDTH-1:0] t_rdata,
    input logic [NUM_TARGETS-1:0][1:0] t_rresp
);
    // arbiter signals
    logic [NUM_INITIATORS-1:0] grant;
    logic transaction_done;

    // address decode - which target does the granted initiator want
    logic [$clog2(NUM_TARGETS)-1:0] target_sel;

    // granted initiator index
    logic [$clog2(NUM_INITIATORS)-1:0] granted_initiator;

    round_robin_arbiter # (
        .NUM_INITIATORS(NUM_INITIATORS)
    ) arbiter (
        .clk(clk),
        .rst(rst),
        .request(awvalid | arvalid),
        .transaction_done(transaction_done),
        .grant(grant)
    );

    // find which initiator was granted
    always_comb begin
        granted_initiator = 0;
        for (int i = 0; i < NUM_INITIATORS; i++) begin
            if (grant[i]) granted_initiator = i;
        end
    end

    // address decoder - which target does the granted initiator want
    always_comb begin
        target_sel = 0;
        if (grant != 0) begin
            if (awvalid[granted_initiator])
                target_sel = awaddr[granted_initiator][ADDR_WIDTH-1 -: $clog2(NUM_TARGETS)];
            else
                target_sel = araddr[granted_initiator][ADDR_WIDTH-1 -: $clog2(NUM_TARGETS)];
        end
    end

    // transaction done when write or read response handshake completes
    always_comb begin
        transaction_done = 0;
        for (int i = 0; i < NUM_TARGETS; i++) begin
            if (t_bvalid[i] && t_bready[i]) transaction_done = 1;
            if (t_rvalid[i] && t_rready[i]) transaction_done = 1;
        end
    end

    // signal routing - connect granted initiator to correct target
    always_comb begin
        // default everything to 0
        t_awvalid = 0;
        t_awaddr = 0;
        t_wvalid = 0;
        t_wdata = 0;
        t_wstrb = 0;
        t_bready = 0;
        t_arvalid = 0;
        t_araddr = 0;
        t_rready = 0;
        awready = 0;
        wready = 0;
        bvalid = 0;
        bresp = 0;
        arready = 0;
        rvalid = 0;
        rdata = 0;
        rresp = 0;

        if (grant != 0) begin
            // route initiator signals to selected target
            t_awvalid[target_sel] = awvalid[granted_initiator];
            t_awaddr[target_sel] = awaddr[granted_initiator];
            t_wvalid[target_sel] = wvalid[granted_initiator];
            t_wdata[target_sel] = wdata[granted_initiator];
            t_wstrb[target_sel] = wstrb[granted_initiator];
            t_bready[target_sel] = bready[granted_initiator];
            t_arvalid[target_sel] = arvalid[granted_initiator];
            t_araddr[target_sel] = araddr[granted_initiator];
            t_rready[target_sel] = rready[granted_initiator];

            // route target responses back to granted initiator
            awready[granted_initiator] = t_awready[target_sel];
            wready[granted_initiator] = t_wready[target_sel];
            bvalid[granted_initiator] = t_bvalid[target_sel];
            bresp[granted_initiator] = t_bresp[target_sel];
            arready[granted_initiator] = t_arready[target_sel];
            rvalid[granted_initiator] = t_rvalid[target_sel];
            rdata[granted_initiator] = t_rdata[target_sel];
            rresp[granted_initiator] = t_rresp[target_sel];
        end
    end

endmodule