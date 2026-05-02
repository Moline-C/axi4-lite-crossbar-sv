module and_gate_tb;

    logic a;
    logic b;
    logic y;

    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        $dumpfile("sim/and_gate.vcd");
        $dumpvars(0, and_gate_tb);

        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $display("Simulation complete");
        $finish;
    end

endmodule