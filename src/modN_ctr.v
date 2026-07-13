`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/04/2026 02:15:44
// Design Name: Mod-N Counter
// Module Name: modN_ctr
// Tool Versions: Vivado 2025.2
// Description: Parametrizable modulo-N up-counter with asynchronous
//              active-low reset. Counter width is calculated from N.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module modN_ctr #(
    parameter MODULUS = 10,
    parameter WIDTH   = $clog2(MODULUS)
) (
    input  wire             clk_i,
    input  wire             rst_n_i,
    output wire [WIDTH-1:0] count_o
);

    // Registered counter value
    reg  [WIDTH-1:0] count_q;
    // Next counter value (combinational, wraps at MODULUS-1)
    wire [WIDTH-1:0] count_d;

    // Combinational: modulo-N next-state logic
    assign count_d = (count_q == MODULUS - 1) ? 0 : count_q + 1;

    // Sequential: count register
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            count_q <= 0;
        end else begin
            count_q <= count_d;
        end
    end

    assign count_o = count_q;

endmodule
