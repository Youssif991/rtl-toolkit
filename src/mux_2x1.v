`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/26/2026 02:33:35 AM
// Design Name: 2-to-1 Multiplexer
// Module Name: mux_2x1
// Tool Versions: Vivado 2025.2
// Description: Selects between D0 and D1 based on select S. Outputs
//              Y = S ? D1 : D0. Combinational single-bit mux.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module mux_2x1 (
    input  D0_i,
    input  D1_i,
    input  S_i,
    output Y_o
);

    // Ternary multiplexer: Y = S ? D1 : D0.
    assign Y_o = S_i ? D1_i : D0_i;

endmodule
