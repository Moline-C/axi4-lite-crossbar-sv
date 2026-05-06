module axi4_lite_target # (
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 32,
    parameter int NUM_REGS = 4
) (
    input logic clk,
    input logic rst,

    // write address channel
    input logic awvalid,
    output logic awready,
    input logic [ADDR_WIDTH-1:0] awaddr,

    // write data channel
    input logic wvalid,
    output logic wready,
    input logic [DATA_WIDTH-1:0] wdata,
    input logic [DATA_WIDTH/8-1:0] wstrb,

    // write response channel
    output logic bvalid,
    input logic bready,
    output logic [1:0] bresp,

    // read address channel
    input logic arvalid,
    output logic arready,
    input logic [ADDR_WIDTH-1:0] araddr,

    // read data channel
    output logic rvalid,
    input logic rready,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic [1:0] rresp
);

    // internal registers 
    logic [DATA_WIDTH-1:0] registers [NUM_REGS-1:0];

    // wrrite state machine
    typedef enum logic [1:0] {
        W_IDLE,
        W_ADDR,
        W_DATA,
        W_RESP
    } wstate_t;

    wstate_t wstate;

    // read state machin
    typedef enum logic [1:0] {
        R_IDLE,
        R_ADDR,
        R_DATA
    }  rstate_t;
    
    rstate_t rstate;

    // captured address registers
    logic [ADDR_WIDTH-1:0] waddr_reg;
    logic [ADDR_WIDTH-1:0] raddr_reg;

    // write state machine
    always_ff @(posedge clk) begin
        if (rst) begin
            wstate <= W_IDLE;
            awready <= 0;
            wready <= 0;
            bvalid <= 0;
            bresp <= 2'b00;
            waddr_reg <= 0;
        end else begin
            case (wstate)
                W_IDLE: begin
                    awready <= 1;
                    wready <= 1;
                    wstate <= W_ADDR;
                end

                W_ADDR: begin
                    if (awvalid && awready) begin
                        waddr_reg <= awaddr;
                        awready <= 0;
                        wstate <= W_DATA;
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
                        bresp <= 2'b00;
                        wstate <= W_RESP;
                    end
                end

                W_RESP: begin
                    if (bready && bvalid) begin
                        bvalid <= 0;
                        wstate <= W_IDLE;
                    end 
                end 
            endcase
        end 
    end 

    // read state machine
    always_ff @(posedge clk) begin
        if (rst) begin
            rstate <= R_IDLE;
            arready <= 0;
            rvalid <= 0;
            rdata <= 0;
            rresp <= 2'b00;
            raddr_reg <= 0;
        end else begin
            case (rstate)
            R_IDLE: begin
                arready <= 1;
                rstate <= R_ADDR;
            end 

            R_ADDR: begin
                if (arvalid && arready) begin
                    raddr_reg <= araddr;
                    arready <= 0;
                    rvalid <= 1;
                    rdata <= registers[araddr[3:2]];
                    rresp <= 2'b00;
                    rstate <= R_DATA;
                end 
            end 

            R_DATA: begin
                if (rvalid && rready) begin
                    rvalid <= 0;
                    rstate <= R_IDLE;
                end 
            end 
            endcase 
        end 
    end 

endmodule