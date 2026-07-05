`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/05/2026 13:39:40
// Design Name: D FlipFlop
// Module Name: d_ff
// Tool Versions: Vivado 2025.2
// Description: D FlipFlop implementation where at the positive edge the output is the same as the input D.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module d_ff (
    input d,
    input clk,
    input rstn,
    output reg q,
    output q_bar
);

  always @(posedge clk or negedge rstn) begin
    if (!rstn) q <= 1'b0;
    else q <= d;
  end

  assign q_bar = ~q;

endmodule
