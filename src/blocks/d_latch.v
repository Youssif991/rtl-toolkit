`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/04/2026 18:04:38
// Design Name: D-latch
// Module Name: d_latch
// Tool Versions: Vivado 2025.2
// Description: A D-latch that captures the value of `D` when `en` is high and holds it when `en` is low. 
// The output `Q` reflects the latched value, while `Qn` provides the inverted output.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module d_latch (
    input d,
    input en,
    input rstn,
    output reg q
);

  always @(en or rstn or en) begin
    if (!rstn) begin
      q <= 1'b0;
    end else if (en) begin
      q <= d;
    end
  end

endmodule
