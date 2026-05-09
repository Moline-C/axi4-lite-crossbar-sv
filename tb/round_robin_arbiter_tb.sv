module round_robin_arbiter_tb;
    localparam int NUM_INITIATORS = 3;
    logic clk;
    logic rst;
    logic [NUM_INITIATORS-1:0] request;
    logic transaction_done;
    logic [NUM_INITIATORS-1:0] grant;

    round_robin_arbiter # (
        .NUM_INITIATORS(NUM_INITIATORS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .request(request),
        .transaction_done(transaction_done),
        .grant(grant)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // initialize
        rst = 1;
        request = 0;
        transaction_done = 0;

        repeat(5) @(posedge clk);
        #1;
        rst = 0;
        repeat(2) @(posedge clk);
        #1;

        // all three initiators request simultaneously
        request = 3'b111;
        repeat(2) @(posedge clk);
        #1;
        $display("Grant after all request: %b (expect 001)", grant);

        // complete transaction, next should get grant
        transaction_done = 1;
        @(posedge clk); #1;
        transaction_done = 0;
        repeat(2) @(posedge clk); #1;
        $display("Grant after first done: %b (expect 010)", grant);
        
        // complete transaction, next should get grant
        transaction_done = 1;
        @(posedge clk); #1;
        transaction_done = 0;
        repeat(2) @(posedge clk); #1;
        $display("Grant after second done: %b (expect 100)", grant);

        // complete transaction, should wrap back to IO
        transaction_done = 1;
        @(posedge clk); #1;
        transaction_done = 0;
        repeat(2) @(posedge clk); #1;
        $display("Grant after third done: %b (expect 001)", grant);

        repeat(2) @(posedge clk);
        $display("Simulaion complete");
        $finish;
    end

endmodule