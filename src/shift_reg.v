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
//              shift direction. Active-low asynchronous reset (`rstn`) clears
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
    parameter  N     = 4,  // Width of the shift register
    localparam left  = 0,  // Left-shift direction encoding
    localparam right = 1   // Right-shift direction encoding
) (
    input                d,     // Serial data input
    input                clk,   // Clock
    input                rstn,  // Active-low asynchronous reset
    input                dir,   // Direction select (left = 0, right = 1)
    input                en,    // Enable: shifts only when asserted
    output reg [N-1 : 0] out    // Parallel output
);

    // Shift on rising clock edge; clear on reset
    always @(posedge clk or negedge rstn) begin
        if (!rstn) out <= 0;
        else if (en) begin
            case (dir)
                left: out <= {out[N-2 : 0], d};  // Left shift: LSB ← d
                right: out <= {d, out[N-1 : 1]};  // Right shift: MSB ← d
                default: out <= out;
            endcase
        end
    end


endmodule
