`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/04/2026 21:24:12
// Design Name: T Flip-Flop
// Module Name: t_ff
// Tool Versions: Vivado 2025.2
// Description: T Flip-Flop toggles its output on the rising edge of the clock when the T input is high.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module t_ff (
    input t,
    input clk,
    input rstn,
    output reg q
);

  always @(posedge clk or negedge rstn) begin : t_ff_logic
    if (!rstn) q <= 1'b0;
    else if (t) q <= ~q; // Toggle the output
  end

endmodule
