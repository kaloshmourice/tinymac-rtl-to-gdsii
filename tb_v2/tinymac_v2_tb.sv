//============================================================
// TinyMAC Project
// Testbench: tinymac_v2_tb
// Description:
//   SystemVerilog testbench for TinyMAC v2.
//   Applies several input vectors and checks the pipelined
//   2-cycle result latency behavior.
//============================================================

`timescale 1ns/1ps

module tinymac_v2_tb;

    logic        clk;
    logic        rst_n;
    logic        start;

    logic [7:0]  a0;
    logic [7:0]  a1;
    logic [7:0]  a2;
    logic [7:0]  a3;

    logic [7:0]  b0;
    logic [7:0]  b1;
    logic [7:0]  b2;
    logic [7:0]  b3;

    logic        done;
    logic [31:0] result;

    logic [31:0] expected;

    // Device Under Test
    tinymac_top_v2 dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .start  (start),

        .a0     (a0),
        .a1     (a1),
        .a2     (a2),
        .a3     (a3),

        .b0     (b0),
        .b1     (b1),
        .b2     (b2),
        .b3     (b3),

        .done   (done),
        .result (result)
    );

    // Clock generation: 100 MHz clock period = 10 ns
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task automatic run_test (
        input logic [7:0] ta0,
        input logic [7:0] ta1,
        input logic [7:0] ta2,
        input logic [7:0] ta3,

        input logic [7:0] tb0,
        input logic [7:0] tb1,
        input logic [7:0] tb2,
        input logic [7:0] tb3
    );
        begin
            expected = ({24'd0, ta0} * {24'd0, tb0}) +
                       ({24'd0, ta1} * {24'd0, tb1}) +
                       ({24'd0, ta2} * {24'd0, tb2}) +
                       ({24'd0, ta3} * {24'd0, tb3});

            @(negedge clk);

            a0    = ta0;
            a1    = ta1;
            a2    = ta2;
            a3    = ta3;

            b0    = tb0;
            b1    = tb1;
            b2    = tb2;
            b3    = tb3;

            start = 1'b1;

            // Cycle 1:
            // v2 captures multiplier outputs into product pipeline registers.
            @(posedge clk);
            #1;
            start = 1'b0;

            if (done !== 1'b0) begin
                $fatal(1, "TEST FAILED: done asserted too early");
            end

            // Cycle 2:
            // v2 captures adder_tree output into result register and asserts done.
            @(posedge clk);
            #1;

            if (done !== 1'b1) begin
                $fatal(1, "TEST FAILED: done was not asserted after v2 pipeline latency");
            end

            if (result !== expected) begin
                $fatal(1, "TEST FAILED: result=%0d expected=%0d", result, expected);
            end

            $display("TEST PASSED: result=%0d expected=%0d", result, expected);

            // Next cycle:
            // done should return low when FSM returns to IDLE.
            @(posedge clk);
            #1;

            if (done !== 1'b0) begin
                $fatal(1, "TEST FAILED: done did not return low");
            end
        end
    endtask

    initial begin
        $display("Starting TinyMAC v2 pipelined simulation...");

        rst_n = 1'b0;
        start = 1'b0;

        a0 = 8'd0;
        a1 = 8'd0;
        a2 = 8'd0;
        a3 = 8'd0;

        b0 = 8'd0;
        b1 = 8'd0;
        b2 = 8'd0;
        b3 = 8'd0;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        run_test(8'd1,   8'd3,   8'd5,   8'd7,
                 8'd2,   8'd4,   8'd6,   8'd8);

        run_test(8'd10,  8'd20,  8'd30,  8'd40,
                 8'd1,   8'd2,   8'd3,   8'd4);

        run_test(8'd255, 8'd255, 8'd255, 8'd255,
                 8'd255, 8'd255, 8'd255, 8'd255);

        run_test(8'd0,   8'd15,  8'd100, 8'd200,
                 8'd50,  8'd0,   8'd3,   8'd2);

        $display("All TinyMAC v2 tests passed.");
        $finish;
    end

endmodule
