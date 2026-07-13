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
// Revision 1.00 - 2026-07-13 - Fixed reset bug (state_reg instead of state_next),
//                               applied lowRISC naming conventions
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module seq_detector (
    input  wire        clk,
    input  wire        rstn,
    input  wire        in,
    output wire        out
);

    // State encoding for the "1011" sequence detector (Moore FSM)
    localparam IDLE = 3'b000;
    localparam S1   = 3'b001;
    localparam S10  = 3'b010;
    localparam S101 = 3'b011;
    localparam S1011= 3'b100;

    reg [2:0] state_reg;
    reg [2:0] state_next;

    // Sequential logic: update state_reg on each clock edge,
    // or reset to IDLE when rstn is asserted low.
    always @(posedge clk) begin
        if (!rstn) begin
            state_reg <= IDLE;
        end else begin
            state_reg <= state_next;
        end
    end

    // Next-state logic (combinational):
    // Advance through the state chain only when the next expected
    // bit is received; otherwise fall back to the appropriate state.
    always @(*) begin
        state_next = state_reg;

        case (state_reg)
            IDLE : state_next = (in) ? S1    : IDLE;
            S1   : state_next = (in) ? IDLE  : S10;
            S10  : state_next = (in) ? S101  : IDLE;
            S101 : state_next = (in) ? S1011 : IDLE;
            S1011: state_next = IDLE;
            default: state_next = IDLE;
        endcase
    end

    // Output is asserted only in the final "pattern detected" state
    assign out = (state_reg == S1011);

endmodule
