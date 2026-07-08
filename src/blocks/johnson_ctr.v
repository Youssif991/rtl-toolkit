`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/05/2026 18:54:19
// Design Name: Johnson Counter
// Module Name: johnson_ctr
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

module johnson_ctr #(
    parameter N = 4
) (
    input clk,
    input rstn,
    output reg [N - 1 : 0] out
);
  integer i;

  always @(posedge clk) begin
    if (!rstn) out <= 0;
    else begin

      out[N-1] <= ~out[0];  // in order to have the shifting pattern of the johnson counter

      for (i = 0; i < N - 1; i = i + 1) begin : counting_loop
        out[i] <= out[i+1];
      end
    end
  end

endmodule
