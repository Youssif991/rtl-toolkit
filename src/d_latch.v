`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/04/2026 18:04:38
// Design Name: D-latch
// Module Name: d_latch
// Tool Versions: Vivado 2025.2
// Description: A D-latch that captures the value of `D` when `en` is high and holds it when `en` is low.
// The output `Q` reflects the latched value, while `Qn` provides the inverted output.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module d_latch (
    input      rst_n_i,
    input      en_i,
    input      d_i,
    output reg q_o
);

    // Combinational latch: transparent when enabled, holding when disabled
    //   - rst_n_i asserted:  asynchronously clear q to 0 (highest priority)
    //   - en_i high:         q follows d_i (transparent / feed-through mode)
    //   - en_i low:          q retains its current value (hold / opaque mode)
    always @(*) begin
        if (!rst_n_i) begin
            q_o = 1'b0;  // Reset dominates all other conditions
        end else if (en_i) begin
            q_o = d_i;  // Transparent: output tracks input
        end
        // When en_i is low, q_o holds its previous value (inferred latch)
    end

endmodule
