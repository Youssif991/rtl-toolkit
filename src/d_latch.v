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
    input d,  // Data input
    input en,  // Enable input
    input rstn,  // Reset input (active low)
    output reg q  // Output
);

    always @(en or rstn or d) begin : Latch_Logic
        if (!rstn) begin : Async_Reset  // Asynchronous reset
            q <= 1'b0;
        end else if (en) begin : Latch_Enable  // When enable is high, latch the value of D
            q <= d;
        end
    end

endmodule
