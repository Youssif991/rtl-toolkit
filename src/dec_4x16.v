`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/29/2026 02:07:49 AM
// Design Name: 4-to-16 Decoder
// Module Name: dec_4x16
// Tool Versions: Vivado 2025.2
// Description: Produces a one-hot 16-bit output from a 4-bit input when
//              enabled. Output bit corresponding to `in` is asserted.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module dec_4x16 (
    input [3:0] in,
    input en,
    output [15:0] out
);

  // Shift a 1 to the bit position indicated by `in` when enabled
  assign out = en ? 16'b1 << in : 0;


endmodule
