`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/08/2026 22:54:53
// Design Name: Shift Register
// Module Name: shift_reg
// Tool Versions: Vivado 2025.2
// Description: N-bit shift register with configurable left/right shifting.
//              Serial data is loaded via `d` and shifted on the rising edge
//              of `clk` when `en` is asserted. The `dir` port selects the
//              shift direction. Active-low asynchronous reset (`rst_n`) clears
//              the register to zero.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module shift_reg #(
    parameter N = 4  // Width of the shift register
) (
    input               clk_i,    // Clock
    input               rst_n_i,  // Active-low asynchronous reset
    input               d_i,      // Serial data input
    input               dir_i,    // Direction select (LEFT = 0, RIGHT = 1)
    input               en_i,     // Enable: shifts only when asserted
    output wire [N-1:0] out_o     // Parallel output
);

    // Left-shift / right-shift direction encoding
    localparam LEFT = 0;
    localparam RIGHT = 1;

    // Internal register
    reg [N-1:0] out_q;

    // Sequential block: shift on rising clock edge, reset on rst_n low
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            out_q <= 0;
        end else if (en_i) begin
            // Shift direction mux: select left or right shift
            case (dir_i)
                LEFT: out_q <= {out_q[N-2:0], d_i};  // Left shift: shift in d_i at LSB, discard MSB
                RIGHT:
                out_q <= {d_i, out_q[N-1:1]};  // Right shift: shift in d_i at MSB, discard LSB
                default: out_q <= out_q;
            endcase
        end
    end

    assign out_o = out_q;

endmodule
