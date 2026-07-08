`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/08/2026 22:54:53
// Design Name: Shift Register
// Module Name: shift_reg
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

module shift_reg #(
    parameter N = 4,
    localparam left = 0,
    localparam right = 1
) (
    input d,
    input clk,
    input rstn,
    input dir,
    input en,
    output reg [N - 1 : 0] out
);

  always @(posedge clk or negedge rstn) begin
    if (!rstn) out <= 0;
    else begin
      if (en) begin
        case (dir)
          right: out <= {out[N-2 : 0], d};
          left: out <= {d, out[N-2 : 0]};
          default: out <= out;
        endcase
      end else out <= out;
    end
  end


endmodule
