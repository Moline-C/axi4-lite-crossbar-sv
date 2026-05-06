module param_register_tb;

    logic clk;
    logic rst;
    logic [15:0] d;
    logic [15:0] q;

    param_register #(
        .DATA_WIDTH(16),
        .RESET_VAL(0)
    ) dut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task wait_cycles(input int n);
        repeat(n) @(posedge clk);
        #1;
    endtask

    initial begin
        $dumpfile("sim/param_register.vcd");
        $dumpvars(0, param_register_tb);

        rst = 1; d = 0;
        wait_cycles(2);

        rst = 0;

        d = 16'hABCD; wait_cycles(1);
        d = 16'h1234; wait_cycles(1);
        d = 16'hFFFF; wait_cycles(1);
        d = 16'h0000; wait_cycles(1);

        $display("Simulation complete");
        $finish;
    end

endmodule