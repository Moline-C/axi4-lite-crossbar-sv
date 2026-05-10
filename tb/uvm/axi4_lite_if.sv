interface axi4_lite_if #(
    parameter int NUM_INITIATORS = 2,
    parameter int NUM_TARGETS = 2,
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 32
) (
    input logic clk,
    input logic rst
);

    // initiator side
    
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

    // target side
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

endinterface