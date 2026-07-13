`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/05/2026 18:54:19
// Design Name: Johnson Counter
// Module Name: johnson_ctr
// Tool Versions: Vivado 2025.2
// Description: N-bit Johnson (twisted-ring) counter. On each clock cycle the
//              complement of the LSB is shifted into the MSB, and all bits are
//              shifted right by one position. Produces 2xN unique states with
//              only one bit transitioning per cycle, useful for glitch-free
//              decoding in control and timing applications.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module johnson_ctr #(
    parameter WIDTH = 4
) (
    input  wire             clk_i,
    input  wire             rst_n_i,
    output wire [WIDTH-1:0] out_o
);

    // Registered Johnson state (current value)
    reg [WIDTH-1:0] state_q;
    // Next-state value (combinational)
    reg [WIDTH-1:0] state_d;
    integer i;

    // Combinational: Johnson (twisted-ring) next-state logic
    always @(*) begin
        // Complement of LSB feeds into MSB (twisted feedback)
        state_d[WIDTH-1] = ~state_q[0];
        // Shift all bits right by one position
        for (i = 0; i < WIDTH - 1; i = i + 1) begin : shift_loop
            state_d[i] = state_q[i+1];
        end
    end

    // Sequential: state register
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            state_q <= 0;
        end else begin
            state_q <= state_d;
        end
    end

    // Output is the current registered state (2*N unique states, single-bit transition)
    assign out_o = state_q;

endmodule
