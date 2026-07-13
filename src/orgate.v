`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/26/2026 02:03:56 AM
// Design Name:
// Module Name: orgate
// Tool Versions: Vivado 2025.2
// Description: Insert description here
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module orgate (
    input  A,
    input  B,
    output C
);
    assign C = A | B;
endmodule
