`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/26/2026 02:04:37 AM
// Design Name:
// Module Name: notgate
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

module notgate (
    input  A,
    output B
);
    assign B = ~A;
endmodule
