//============================================================
// TinyMAC Project
// Module: adder_tree
// Description:
//   Combinational adder tree.
//   Adds four 16-bit unsigned products and produces a 32-bit sum.
//============================================================

`timescale 1ns/1ps

module adder_tree (
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
