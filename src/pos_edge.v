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
    input      clk_i,
    input      rst_n_i,
    input      sig_i,
    output reg out_o
);

    reg sig_d;  // Delayed version of sig_i (one clock cycle behind)

    // Sequential edge detector: compare current input against its delayed copy
    //   - sig_d tracks sig_i, delayed by one cycle
    //   - out_o goes high for one cycle when sig_i is high and sig_d is low
    //     (i.e. a 0-to-1 transition was just detected)
    //   - rst_n_i low forces both registers to 0 (no edge pulse)
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            sig_d <= 1'b0;
            out_o <= 1'b0;
        end else begin
            sig_d <= sig_i;  // Delay the input by one cycle
            out_o <= sig_i & ~sig_d;  // Rising edge: sig_i=1, previous sig_d=0
        end
    end

endmodule
