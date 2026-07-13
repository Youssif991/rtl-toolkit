`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/05/2026 13:34:23
// Design Name: Ripple Counter
// Module Name: ripple_ctr
// Tool Versions: Vivado 2025.2
// Description: N-bit asynchronous ripple counter built from cascaded D flip-flops.
//              Each stage is clocked by the inverted output (`q_bar_o`) of the
//              previous stage, creating a ripple effect. The first stage is
//              driven by the external `clk_i`. Suitable for low-frequency
//              division; propagation delay accumulates with each stage.
//
// Dependencies: d_ff (src/d_ff.v)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module ripple_ctr #(
    parameter Width = 4
) (
    input  wire             clk_i,
    input  wire             rst_n_i,
    output wire [Width-1:0] out_o
);

    wire [Width-1:0] stage_q;
    wire [Width-1:0] stage_q_bar;
    // Clock chain: clk_chain[i] clocks stage i; each stage toggles the next
    wire [  Width:0] clk_chain;

    assign clk_chain[0] = clk_i;

    genvar i;

    // Generate: ripple stages, each clocked from the previous stage's q_bar
    generate
        for (i = 0; i < Width; i = i + 1) begin : gen_ripple_stage
            // Feed inverted output of this stage as the clock for the next stage
            assign clk_chain[i+1] = stage_q_bar[i];
            d_ff d_inst (
                .d_i    (stage_q_bar[i]),
                .clk_i  (clk_chain[i]),
                .rst_n_i(rst_n_i),
                .q_o    (stage_q[i]),
                .q_bar_o(stage_q_bar[i])
            );
        end
    endgenerate

    assign out_o = stage_q;

endmodule
