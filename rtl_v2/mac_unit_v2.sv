//============================================================
// TinyMAC Project
// Module: mac_unit_v2
// Description:
//   TinyMAC v2 combinational 8-bit unsigned multiplier.
//   Same arithmetic behavior as v1 mac_unit, separated for
//   clean v1/v2 comparison.
//============================================================

`timescale 1ns/1ps

module mac_unit_v2 (
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    output logic [15:0] product
);

    assign product = a * b;

endmodule
