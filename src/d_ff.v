`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/05/2026 13:39:40
// Design Name: D FlipFlop
// Module Name: d_ff
// Tool Versions: Vivado 2025.2
// Description: Positive-edge-triggered D flip-flop with asynchronous active-low
//              reset. Captures the value of `d` on the rising edge of `clk` and
//              drives both `q` (buffered) and `q_bar` (inverted) outputs.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module d_ff (
    input d,
    input clk,
    input rstn,
    output reg q,
    output q_bar
);

    // On rising clock edge, capture `d`; on negated reset, clear `q`
    always @(posedge clk or negedge rstn) begin
        if (!rstn) q <= 1'b0;
        else q <= d;
    end

    assign q_bar = ~q;  // Complementary output

endmodule
