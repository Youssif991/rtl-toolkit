`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/29/2026 02:07:49 AM
// Design Name: 
// Module Name: dec_4x16
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

module dec_4x16 (
    input [3:0] in,
    input en,
    output [15:0] out
);

  assign out = en ? 16'b1 << in : 0;
  

endmodule
