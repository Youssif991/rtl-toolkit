`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/05/2026 18:54:19
// Design Name: Johnson Counter
// Module Name: johnson_ctr
// Tool Versions: Vivado 2025.2
// Description: N-bit Johnson (twisted-ring) counter. On each clock cycle the
//              complement of the LSB is shifted into the MSB, and all bits are
//              shifted right by one position. Produces 2×N unique states with
//              only one bit transitioning per cycle, useful for glitch-free
//              decoding in control and timing applications.
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

  // Shift-right and inject the complement of the LSB into the MSB
  always @(posedge clk) begin
    if (!rstn) out <= 0;
    else begin
      // Johnson (twisted-ring) feedback: complement of LSB goes to MSB
      out[N-1] <= ~out[0];

      // Shift all bits right by one position
      for (i = 0; i < N - 1; i = i + 1) begin : counting_loop
        out[i] <= out[i+1];
      end
    end
  end

endmodule
