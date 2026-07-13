`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/09/2026 17:03:43
// Design Name: Sequence detector
// Module Name: seq_detector
// Tool Versions: Vivado 2025.2
// Description: Moore finite-state machine that detects the non-overlapping binary sequence "1011"
//              on the serial input `in`. The output `out` is asserted (high) for one clock cycle
//              when the full pattern is recognized, then the FSM resets to IDLE and begins a
//              fresh search on the next input bit.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - 2026-07-13 - Fixed reset bug (state_q instead of state_d),
//                               applied lowRISC naming conventions
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module seq_detector (
    input  wire clk_i,
    input  wire rst_n_i,
    input  wire in_i,
    output wire out_o
);

    // State encoding for the "1011" sequence detector (Moore FSM)
    localparam IDLE = 3'b000;
    localparam S1 = 3'b001;
    localparam S10 = 3'b010;
    localparam S101 = 3'b011;
    localparam S1011 = 3'b100;

    reg [2:0] state_q;
    reg [2:0] state_d;

    // Sequential logic: update state_q on each clock edge,
    // or reset to IDLE when rst_n is asserted low.
    always @(posedge clk_i) begin
        if (!rst_n_i) begin
            state_q <= IDLE;
        end else begin
            state_q <= state_d;
        end
    end

    // Next-state logic (combinational):
    // Advance through the state chain only when the next expected
    // bit is received; otherwise fall back to the appropriate state.
    always @(*) begin
        state_d = state_q;

        case (state_q)
            IDLE:  state_d = (in_i) ? S1    : IDLE;
            S1:    state_d = (in_i) ? IDLE  : S10;
            S10:   state_d = (in_i) ? S101  : IDLE;
            S101:  state_d = (in_i) ? S1011 : IDLE;
            S1011: state_d = IDLE;
            default: state_d = IDLE;
        endcase
    end

    // Output decode: assert out_o only in the S1011 (pattern detected) state
    assign out_o = (state_q == S1011);

endmodule
