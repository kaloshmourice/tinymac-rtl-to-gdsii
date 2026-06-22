//============================================================
// TinyMAC Project
// Module: adder_tree_v2
// Description:
//   TinyMAC v2 combinational adder tree.
//   Same arithmetic behavior as v1 adder_tree, separated for
//   clean v1/v2 comparison.
//============================================================

`timescale 1ns/1ps

module adder_tree_v2 (
    input  logic [15:0] p0,
    input  logic [15:0] p1,
    input  logic [15:0] p2,
    input  logic [15:0] p3,
    output logic [31:0] sum
);

    assign sum = {16'd0, p0} +
                 {16'd0, p1} +
                 {16'd0, p2} +
                 {16'd0, p3};

endmodule
