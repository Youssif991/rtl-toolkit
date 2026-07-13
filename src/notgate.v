`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/26/2026 02:04:37 AM
// Design Name: notgate
// Module Name: notgate
// Tool Versions: Vivado 2025.2
// Description: Single-input NOT gate (inverter)
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module notgate (
    input  A_i,
    output B_o
);
    // Invert the input: output is the logical complement of A
    assign B_o = ~A_i;
endmodule
