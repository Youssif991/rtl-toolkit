`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 02:19:24 AM
// Design Name: ANDOR - This module implements the logic function F = C | (A & B).
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
    input  A,
    input  B,
    input  C,
    output F
);

  wire AB;         // Intermediate: AND of A and B
  assign AB = A & B; // AB = 1 when both A and B are asserted
  assign F  = C | AB; // F = 1 when C is asserted OR (A & B) is asserted

endmodule
