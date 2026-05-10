module axi4_lite_target #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 32,
    parameter int NUM_REGS   = 4
)(
    input  logic                    clk,
    input  logic                    rst,

    // write address channel
    input  logic                    awvalid,
    output logic                    awready,
    input  logic [ADDR_WIDTH-1:0]   awaddr,

    // write data channel
    input  logic                    wvalid,
    output logic                    wready,
    input  logic [DATA_WIDTH-1:0]   wdata,
    input  logic [DATA_WIDTH/8-1:0] wstrb,

    // write response channel
    output logic                    bvalid,
    input  logic                    bready,
    output logic [1:0]              bresp,

    // read address channel
    input  logic                    arvalid,
    output logic                    arready,
    input  logic [ADDR_WIDTH-1:0]   araddr,

    // read data channel
    output logic                    rvalid,
    input  logic                    rready,
    output logic [DATA_WIDTH-1:0]   rdata,
    output logic [1:0]              rresp
);

    // internal registers
    logic [DATA_WIDTH-1:0] registers [NUM_REGS-1:0];

    integer ri;
    initial begin
        for (ri = 0; ri < NUM_REGS; ri = ri + 1)
            registers[ri] = 0;
    end

    // write state machine
    typedef enum logic [1:0] {
        W_ADDR,
        W_DATA,
        W_RESP
    } wstate_t;

    wstate_t wstate;

    // read state machine
    typedef enum logic [1:0] {
        R_ADDR,
        R_DATA
    } rstate_t;

    rstate_t rstate;

    logic [ADDR_WIDTH-1:0] waddr_reg;
    logic [ADDR_WIDTH-1:0] raddr_reg;

    // write state machine
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wstate    <= W_ADDR;
            awready   <= 1;
            wready    <= 1;
            bvalid    <= 0;
            bresp     <= 2'b00;
            waddr_reg <= 0;
        end else begin
            case (wstate)
                W_ADDR: begin
                    if (awvalid) begin
                        waddr_reg <= awaddr;
                        wstate    <= W_DATA;
                    end
                end

                W_DATA: begin
                    if (wvalid && wready) begin
                        wready <= 0;
                        for (int i = 0; i < DATA_WIDTH/8; i++) begin
                            if (wstrb[i])
                                registers[waddr_reg[3:2]][i*8 +: 8] <= wdata[i*8 +: 8];
                        end
                        bvalid <= 1;
                        bresp  <= 2'b00;
                        wstate <= W_RESP;
                    end
                end

                W_RESP: begin
                    if (bready && bvalid) begin
                        bvalid  <= 0;
                        awready <= 1;
                        wready  <= 1;
                        wstate  <= W_ADDR;
                    end
                end

                default: begin
                    wstate  <= W_ADDR;
                    awready <= 1;
                    wready  <= 1;
                end
            endcase
        end
    end

    // read state machine
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rstate    <= R_ADDR;
            arready   <= 1;
            rvalid    <= 0;
            rdata     <= 0;
            rresp     <= 2'b00;
            raddr_reg <= 0;
        end else begin
            case (rstate)
                R_ADDR: begin
                    if (arvalid) begin
                        raddr_reg <= araddr;
                        arready   <= 0;
                        rvalid    <= 1;
                        rdata     <= registers[araddr[3:2]];
                        rresp     <= 2'b00;
                        rstate    <= R_DATA;
                    end
                end

                R_DATA: begin
                    if (rvalid && rready) begin
                        rvalid  <= 0;
                        arready <= 1;
                        rstate  <= R_ADDR;
                    end
                end

                default: begin
                    rstate  <= R_ADDR;
                    arready <= 1;
                end
            endcase
        end
    end

// SVA Assertions

// bvalid only goes high after a write - never during reset
property p_bvalid_after_reset;
    @(posedge clk)
    rst |-> (bvalid == 0);
endproperty
assert property (p_bvalid_after_reset)
    else $error("ASSERT FAIL: bvalid high during reset");

// rvalid only goes high after a read - never during a reset
property p_valid_after_reset;
    @(posedge clk)
    rst |-> (rvalid == 0);
endproperty
assert property (p_valid_after_reset)
    else $error("ASSERT FAIL: rvalid high during reset");

// awready and wready always high when in W_ADDR state
property p_awready_in_waddr;
    @(posedge clk) disable iff (rst)
    (wstate == W_ADDR) |-> (awready == 1);
endproperty
assert property (p_awready_in_waddr)
    else $error("ASSERT FAIL: awready low in W_ADDR state");

// bvalid only high in W_RESP state
property p_bvalid_in_wresp;
    @(posedge clk) disable iff (rst)
    (bvalid == 1) |-> (wstate == W_RESP);
endproperty
assert property (p_bvalid_in_wresp)
    else $error("ASSERT FAIL: bvalid high outside W_RESP state");

// rvalid only high in R_DATA state
property p_rvalid_in_rdata;
    @(posedge clk) disable iff (rst)
    (rvalid == 1) |-> (rstate == R_DATA);
endproperty
assert property (p_rvalid_in_rdata)
    else $error("ASSERT FAIL: rvalid high outside R_DATA state");

endmodule