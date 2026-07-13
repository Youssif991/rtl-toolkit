`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/05/2026 13:34:23
// Design Name: Ripple Counter
// Module Name: ripple_ctr
// Tool Versions: Vivado 2025.2
// Description: N-bit asynchronous ripple counter built from cascaded D flip-flops.
//              Each stage is clocked by the inverted output (`q_bar`) of the
//              previous stage, creating a ripple effect. The first stage is
//              driven by the external `clk`. Suitable for low-frequency
//              division; propagation delay accumulates with each stage.
//
// Dependencies: d_ff (src/blocks/d_ff.v)
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
    // Internal flip-flop outputs: q drives the next stage's clock,
    // q_bar is fed back to the D input for divide-by-2 operation
    wire [N - 1 : 0] q;
    wire [N - 1 : 0] q_bar;

    genvar i;

    // Generate N cascaded D flip-flop stages.
    // Stage 0 is clocked by the external `clk`; subsequent stages are
    // clocked by `q_bar` of the preceding stage (ripple / asynchronous).
    generate
        for (i = 0; i < N; i = i + 1) begin : ripple_stage
            d_ff d_inst (
                .d(q_bar[i]),
                .clk(i == 0 ? clk : q_bar[i-1]),
                .rstn(rstn),
                .q(q[i]),
                .q_bar(q_bar[i])
            );
        end
    endgenerate

    assign out = q;  // Parallel output of the counter

endmodule
