`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/08/2026 18:16:56
// Design Name: Gray Counter
// Module Name: gray_ctr
// Tool Versions: Vivado 2025.2
// Description: Gray Counter is just a binary counter but the output are converted to the gray code to achieve having only one bit changing in each transition,
// This is typically used in FIFO Memories, Rotary encoders, ADC, etc. It is used to get less errors between transisions as the error rate will decrease when having only one bit change
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module gray_ctr #(
    parameter N = 4  // Counter's width
) (
    input clk,
    input rstn,
    output reg [N - 1 : 0] out
);

  reg [N - 1 : 0] q;  // temporary variable to store the binary output

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      q   <= 0;
      out <= 0;
    end else begin
      q   <= q + 1;

      out <= {q[N-1], q[N-1 : 1] ^ q[N-2 : 0]};  // converting the binary output to the grey output
    end
  end
endmodule
