//============================================================
// TinyMAC Project
// Module: tinymac_top
// Description:
//   Top-level TinyMAC module.
//   Connects four multiplier units, one adder tree,
//   one control FSM, and a registered 32-bit result output.
//============================================================

`timescale 1ns/1ps

module tinymac_top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,

    input  logic [7:0]  a0,
    input  logic [7:0]  a1,
    input  logic [7:0]  a2,
    input  logic [7:0]  a3,

    input  logic [7:0]  b0,
    input  logic [7:0]  b1,
    input  logic [7:0]  b2,
    input  logic [7:0]  b3,

    output logic        done,
    output logic [31:0] result
);

    logic [15:0] p0;
    logic [15:0] p1;
    logic [15:0] p2;
    logic [15:0] p3;

    logic [31:0] sum_comb;
    logic        result_en;

    // Multiplier units
    mac_unit u_mac0 (
        .a       (a0),
        .b       (b0),
        .product (p0)
    );

    mac_unit u_mac1 (
        .a       (a1),
        .b       (b1),
        .product (p1)
    );

    mac_unit u_mac2 (
        .a       (a2),
        .b       (b2),
        .product (p2)
    );

    mac_unit u_mac3 (
        .a       (a3),
        .b       (b3),
        .product (p3)
    );

    // Adder tree
    adder_tree u_adder_tree (
        .p0  (p0),
        .p1  (p1),
        .p2  (p2),
        .p3  (p3),
        .sum (sum_comb)
    );

    // Control FSM
    control_fsm u_control_fsm (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (start),
        .result_en (result_en),
        .done      (done)
    );

    // Result register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 32'd0;
        end else if (result_en) begin
            result <= sum_comb;
        end
    end

endmodule
