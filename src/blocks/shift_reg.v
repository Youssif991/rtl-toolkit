`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/08/2026 22:54:53
// Design Name: Shift Register
// Module Name: shift_reg
// Tool Versions: Vivado 2025.2
// Description: N-bit shift register with configurable left/right shifting.
//              Shifts on the rising edge of `clk` when `en` is high
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
    localparam left = 0, // Shift left parameter
    localparam right = 1 // Shift right parameter
) (
    input d,
    input clk,
    input rstn,
    input dir, // input to decide the direction of shifting
    input en, // enable 
    output reg [N - 1 : 0] out
);

  always @(posedge clk or negedge rstn) begin
    if (!rstn) out <= 0;
    else begin
      if (en) begin
        case (dir)
          left: out <= {out[N-2 : 0], d};
          right: out <= {d, out[N-1 : 1]};
          default: out <= out;
        endcase
      end else out <= out; // honestly this line does not really matter but I will leave it here and do not ask me why
    end
  end


endmodule
