module round_robin_arbiter # (
    parameter int NUM_INITIATORS = 3
) (
    input logic clk,
    input logic rst,
    input logic [NUM_INITIATORS-1:0]request,
    input logic transaction_done,
    output logic [NUM_INITIATORS-1:0] grant
);

    logic [$clog2(NUM_INITIATORS)-1:0] priority_ptr;
    logic [NUM_INITIATORS-1:0] grant_next;

    // combinational grant logic
    always_comb begin
        grant_next = 0;
        for (int i = 0; i < NUM_INITIATORS; i++) begin
            int idx;
            idx = (priority_ptr + i) % NUM_INITIATORS;
            if (request[idx] && grant_next == 0) begin
                grant_next[idx] = 1;
            end 
        end 
    end 

    // sequential logic - update grant and priority pointer
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            priority_ptr <= 0;
            grant <= 0;
        end else begin
            grant <= grant_next;
            if (transaction_done && grant != 0) begin
                if (priority_ptr == NUM_INITIATORS - 1)
                    priority_ptr <= 0;
                else
                    priority_ptr <= priority_ptr + 1;
            end 
        end 
    end 

endmodule