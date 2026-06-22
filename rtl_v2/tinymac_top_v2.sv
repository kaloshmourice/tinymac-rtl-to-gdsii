//============================================================
// TinyMAC Project
// Module: tinymac_top_v2
// Description:
//   TinyMAC v2 top-level module.
//   Implements a pipelined datapath by registering multiplier
//   products before the adder tree.
//============================================================

`timescale 1ns/1ps

module tinymac_top_v2 (
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

    logic [15:0] p0_comb;
    logic [15:0] p1_comb;
    logic [15:0] p2_comb;
    logic [15:0] p3_comb;

    logic [15:0] p0_reg;
    logic [15:0] p1_reg;
    logic [15:0] p2_reg;
    logic [15:0] p3_reg;

    logic [31:0] sum_comb;

    logic        product_en;
    logic        result_en;

    // Multiplier units
    mac_unit_v2 u_mac0 (
        .a       (a0),
        .b       (b0),
        .product (p0_comb)
    );

    mac_unit_v2 u_mac1 (
        .a       (a1),
        .b       (b1),
        .product (p1_comb)
    );

    mac_unit_v2 u_mac2 (
        .a       (a2),
        .b       (b2),
        .product (p2_comb)
    );

    mac_unit_v2 u_mac3 (
        .a       (a3),
        .b       (b3),
        .product (p3_comb)
    );

    // Product pipeline registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p0_reg <= 16'd0;
            p1_reg <= 16'd0;
            p2_reg <= 16'd0;
            p3_reg <= 16'd0;
        end else if (product_en) begin
            p0_reg <= p0_comb;
            p1_reg <= p1_comb;
            p2_reg <= p2_comb;
            p3_reg <= p3_comb;
        end
    end

    // Adder tree uses registered multiplier products
    adder_tree_v2 u_adder_tree (
        .p0  (p0_reg),
        .p1  (p1_reg),
        .p2  (p2_reg),
        .p3  (p3_reg),
        .sum (sum_comb)
    );

    // Control FSM for pipelined datapath
    control_fsm_v2 u_control_fsm_v2 (
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (start),
        .product_en (product_en),
        .result_en  (result_en),
        .done       (done)
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
