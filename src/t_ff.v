`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/04/2026 21:24:12
// Design Name: T Flip-Flop
// Module Name: t_ff
// Tool Versions: Vivado 2025.2
// Description: Positive-edge-triggered T (toggle) flip-flop with asynchronous
//              active-low reset. When `t` is asserted, `q` toggles on each
//              rising clock edge; when `t` is low, `q` holds its current value.
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

  // Toggle `q` on rising clock edge when `t` is high; reset clears it
  always @(posedge clk or negedge rstn) begin : t_ff_logic
    if (!rstn)   q <= 1'b0;
    else if (t)  q <= ~q;  // Toggle the output
    // When t == 0, q retains its current value (implied latch)
  end

endmodule
