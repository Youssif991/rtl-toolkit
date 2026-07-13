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
    input      clk_i,
    input      rst_n_i,
    input      d_i,
    output reg q_o,
    output     q_bar_o
);

    // Sequential logic: capture input on rising clock edge
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            q_o <= 1'b0;  // Asynchronous active-low reset clears the output
        end else begin
            q_o <= d_i;  // Sample data input on rising edge of clock
        end
    end

    // Combinational output: generate complementary signal
    assign q_bar_o = ~q_o;

endmodule
