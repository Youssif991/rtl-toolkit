`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/08/2026 18:16:56
// Design Name: Gray Counter
// Module Name: gray_ctr
// Tool Versions: Vivado 2025.2
// Description: N-bit Gray-code counter. Maintains an internal binary counter
//              whose value is converted to Gray code on every clock edge via
//              the formula `gray = binary ^ (binary >> 1)`. Only one output bit
//              toggles per cycle, reducing metastability risk in cross-clock-
//              domain handshakes (e.g., FIFO pointers, rotary encoders, ADCs).
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module gray_ctr #(
    parameter WIDTH = 4
) (
    input  wire             clk_i,
    input  wire             rst_n_i,
    output reg  [WIDTH-1:0] out_o
);

    // Internal binary counter (registered), incremented each cycle
    reg  [WIDTH-1:0] binary_q;
    // Next binary value (combinational)
    wire [WIDTH-1:0] binary_d;

    // Combinational: binary increment
    assign binary_d = binary_q + 1;

    // Sequential: register update with Gray-code conversion
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            binary_q <= 0;
            out_o    <= 0;
        end else begin
            binary_q <= binary_d;
            // Gray-code conversion: gray = binary ^ (binary >> 1)
            out_o    <= {binary_d[WIDTH-1], binary_d[WIDTH-1:1] ^ binary_d[WIDTH-2:0]};
        end
    end

endmodule
