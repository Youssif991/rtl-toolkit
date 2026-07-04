`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/29/2026 05:14:00 PM
// Design Name: Bus Multiplexer (parameterizable)
// Module Name: mux_bus
// Tool Versions: Vivado 2025.2
// Description: This module is a multiplexer that selects one of the input buses based on the selection signal.
// The width of the bus, number of input buses, and the number of selection lines can be parameterized.    
// The output is selected by using the selection signal to index into the concatenated input buses.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mux_bus #(
    parameter bus = 4,
    parameter inputs = 4,
    parameter selection = $clog2(
        inputs
    )  // Calculate the number of selection lines needed based on the number of inputs
) (
    input [bus*inputs - 1:0] in,
    input [selection - 1:0] s,
    output [bus - 1:0] out
);

  assign out = in[s*bus+:bus];  // Select the appropriate bus based on the selection signal

endmodule
