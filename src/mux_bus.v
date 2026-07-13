`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/29/2026 05:14:00 PM
// Design Name: Bus Multiplexer (parameterizable)
// Module Name: mux_bus
// Tool Versions: Vivado 2025.2
// Description: Selects one of the input buses based on the selection signal.
//              The width of the bus, number of input buses, and the number
//              of selection lines can be parameterized.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module mux_bus #(
    parameter BUS_WIDTH  = 4,
    parameter NUM_INPUTS = 4,
    parameter SEL_WIDTH  = $clog2(NUM_INPUTS)
) (
    input  [BUS_WIDTH * NUM_INPUTS - 1 : 0] in_i,
    input  [             SEL_WIDTH - 1 : 0] s_i,
    output [             BUS_WIDTH - 1 : 0] out_o
);

    // Indexed part-select: pick the bus at position s_i from the concatenated input vector.
    assign out_o = in_i[s_i*BUS_WIDTH+:BUS_WIDTH];

endmodule
