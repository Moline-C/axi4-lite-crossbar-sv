module traffic_light_tb;

    logic clk;
    logic rst;
    logic timer_done;
    logic red;
    logic green;
    logic yellow;

    traffic_light dut (
        .clk(clk),
        .rst(rst),
        .timer_done(timer_done),
        .red(red),
        .green(green),
        .yellow(yellow)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task wait_cycles(input int n);
        repeat(n) @(posedge clk);
        #1;
    endtask

    initial begin
        $dumpfile("sim/traffic_light.vcd");
        $dumpvars(0, traffic_light_tb);

        rst = 1;
        timer_done = 0;
        wait_cycles(2);

        rst = 0;
        wait_cycles(2);

        timer_done = 1;
        wait_cycles(1);
        timer_done = 0;
        wait_cycles(2);

        timer_done = 1;
        wait_cycles(1);
        timer_done = 0;
        wait_cycles(2);

        timer_done = 1;
        wait_cycles(1);
        timer_done = 0;
        wait_cycles(2);

        $display("red=%b green=%b yellow=%b", red, green, yellow);
        $finish;
    end

endmodule