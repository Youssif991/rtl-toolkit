`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/29/2026 04:05:23 PM
// Design Name: Indexed Multiplexer
// Module Name: mux
// Tool Versions: Vivado 2025.2
// Description: Selects a single bit from the input vector `in` using
//              index `s` and drives `out` with the selected bit.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module mux #(
    parameter DATA_WIDTH = 4,
    parameter SEL_WIDTH  = $clog2(DATA_WIDTH)
) (
    input [DATA_WIDTH - 1 : 0] in_i,
    input [  SEL_WIDTH - 1 : 0] s_i,
    output out_o
);

    // Bit-select: pick the bit at index s_i from the input vector in_i.
    assign out_o = in_i[s_i];

endmodule
