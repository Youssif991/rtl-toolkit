`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/26/2026 02:19:24 AM
// Design Name: ANDOR
// Module Name: ANDOR
// Tool Versions: Vivado 2025.2
// Description: Implements F = C | (A & B). Computes A & B then ORs
//              the result with C. Combinational logic, single-bit I/O.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module ANDOR (
    input  A_i,
    input  B_i,
    input  C_i,
    output F_o
);

    // Intermediate result: bitwise AND of the A and B inputs.
    wire AB;
    // Compute final output: F = C | (A & B).
    assign AB  = A_i & B_i;
    assign F_o = C_i | AB;

endmodule
