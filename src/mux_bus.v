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
    parameter BusWidth  = 4,
    parameter NumInputs = 4,
    parameter SelWidth  = $clog2(NumInputs)
) (
    input  [BusWidth * NumInputs - 1 : 0] in_i,
    input  [            SelWidth - 1 : 0] s_i,
    output [            BusWidth - 1 : 0] out_o
);

    // Indexed part-select: pick the bus at position s_i from the concatenated input vector.
    assign out_o = in_i[s_i*BusWidth+:BusWidth];

endmodule
