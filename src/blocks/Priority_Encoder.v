`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/01/2026 21:46:45
// Design Name: 
// Module Name: Priority_Encoder
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

module Priority_Encoder #(
    parameter bus = 8, // Width of each input bus
    parameter inputs = 4 // Number of input buses
) (
    input [bus * inputs - 1 : 0] in, // Concatenated input buses
    output reg [bus - 1 : 0] out // Output bus
);

  integer i; // Declaring the loop variable

  always @(*) begin
    out = 0;

    for (i = 0; i < inputs; i = i + 1) begin
      if (in[i*bus+:bus] != 0) begin
        out = in[i*bus+:bus];
      end
    end
  end

endmodule
