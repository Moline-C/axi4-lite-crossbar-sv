module d_flip_flop_tb;
    
    logic clk;
    logic rst;
    logic d;
    logic q;

    d_flip_flop dut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/d_flip_flop.vcd");
        $dumpvars(0, d_flip_flop_tb);

        rst = 1; d = 0;
        #20;

        rst = 0;

        d = 1; #10;
        d = 0; #10;
        d = 1; #10;
        d = 1; #10;
        d = 0; #10;

        $display("Simulation complete");
        $finish;
    end

endmodule