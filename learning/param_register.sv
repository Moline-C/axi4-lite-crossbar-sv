module param_register # (
    parameter int DATA_WIDTH = 8,
    parameter int RESET_VAL = 0
)(
    input logic clk,
    input logic rst,
    input logic [DATA_WIDTH-1:0] d,
    output logic [DATA_WIDTH-1:0] q
);

    always_ff @(posedge clk) begin
        if (rst)
            q <=RESET_VAL;
        else
            q <= d;
    end

endmodule
