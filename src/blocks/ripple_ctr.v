`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/05/2026 13:34:23
// Design Name: Ripple Counter
// Module Name: ripple_ctr
// Tool Versions: Vivado 2025.2
// Description: Ripple counter is an asynchronous counter in which the all the flops except the first are clocked by the output of the preceding flop.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ripple_ctr #(
    parameter N = 4
) (
    input clk,
    input rstn,
    output [N - 1:0] out
);
  // Defining each flip flop output
  wire [N - 1 : 0] q;  // the normal output that will be fed to the clock
  wire [N - 1 : 0] q_bar;  // the inverted output which will be fed back to the input

  // Generating the instantations

  genvar i;  // the loop variable

  generate // to generate the total d flip flops needed for counting
    for (i = 0; i < N; i = i + 1) begin : ripple_stage
      d_ff d_inst (
          .d(q_bar[i]),
          .clk(i == 0 ? clk : q[i-1]),
          .rstn(rstn),
          .q(q[i]),
          .q_bar(q_bar[i])
      );
    end
  endgenerate

  assign out = q; // The total count from the flip flops

endmodule
