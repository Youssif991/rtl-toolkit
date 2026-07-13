`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/08/2026 18:16:56
// Design Name: Gray Counter
// Module Name: gray_ctr
// Tool Versions: Vivado 2025.2
// Description: N-bit Gray-code counter. Maintains an internal binary counter
//              whose value is converted to Gray code on every clock edge via
//              the formula `gray = binary ^ (binary >> 1)`. Only one output bit
//              toggles per cycle, reducing metastability risk in cross-clock-
//              domain handshakes (e.g., FIFO pointers, rotary encoders, ADCs).
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

  // Increment binary counter on each clock, then convert to Gray code
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      q   <= 0;
      out <= 0;
    end else begin
      q   <= q + 1;  // Binary increment

      // Convert binary to Gray: gray = binary ^ (binary >> 1)
      out <= {q[N-1], q[N-1 : 1] ^ q[N-2 : 0]};
    end
  end
endmodule
