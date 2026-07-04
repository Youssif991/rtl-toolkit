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

  wire AB;
  assign AB = A & B;
  assign F  = C | AB;

endmodule
