//============================================================
// TinyMAC Project
// Module: mac_unit
// Description:
//   Combinational 8-bit unsigned multiplier.
//   Multiplies two 8-bit operands and produces a 16-bit product.
//============================================================

`timescale 1ns/1ps

module mac_unit (
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    output logic [15:0] product
);

    assign product = a * b;

endmodule
