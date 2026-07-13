`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/26/2026 02:03:56 AM
// Design Name: orgate
// Module Name: orgate
// Tool Versions: Vivado 2025.2
// Description: 2-input OR gate
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module orgate (
    input  A_i,
    input  B_i,
    output C_o
);
    // Drive output high when at least one input is asserted
    assign C_o = A_i | B_i;
endmodule
