`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/26/2026 01:52:59 AM
// Design Name: andgate
// Module Name: andgate
// Tool Versions: Vivado 2025.2
// Description: 2-input AND gate
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module andgate (
    input  A_i,
    input  B_i,
    output C_o
);
    // Drive output high only when both inputs are asserted
    assign C_o = A_i & B_i;
endmodule
