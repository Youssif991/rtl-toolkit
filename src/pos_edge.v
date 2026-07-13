`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/10/2026 15:02:50
// Design Name: Positive Edge Detector
// Module Name: pos_edge
// Tool Versions: Vivado 2025.2
// Description: Detects the rising edge of an input signal. Generates a single-cycle
//              pulse on `out` when a rising edge is detected on `sig`.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pos_edge (
    input  sig,
    input  clk,
    input  rstn,
    output reg out
);

  reg sig_dly;

  // Delay `sig` and detect rising edges; clear on active-low reset
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      sig_dly <= 1'b0;
      out     <= 1'b0;
    end else begin
      sig_dly <= sig;
      out     <= sig & ~sig_dly;
    end
  end

endmodule
