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
    input      clk_i,
    input      rst_n_i,
    input      t_i,
    output reg q_o
);

    // Sequential logic: toggle or hold on rising clock edge
    //   - rst_n_i asserted: asynchronously clear q to 0
    //   - t_i high:         invert q (toggle)
    //   - t_i low:          q holds its previous value (implied storage)
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            q_o <= 1'b0;  // Asynchronous active-low reset
        end else if (t_i) begin
            q_o <= ~q_o;  // Toggle the output
        end
        // When t_i is low, q_o retains its current value (no assignment)
    end

endmodule
