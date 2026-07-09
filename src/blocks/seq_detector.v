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
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module seq_detector (
    input  clk,
    input  rstn,
    input  in,
    output out
);

  // State encoding for the "1011" sequence detector (Moore FSM)
  localparam IDLE = 3'b000;   // No partial match yet
  localparam S1   = 3'b001;   // Matched '1'
  localparam S10  = 3'b010;   // Matched '10'
  localparam S101 = 3'b011;   // Matched '101'
  localparam S1011= 3'b100;   // Full match '1011'

  reg [2 : 0] current_state;
  reg [2 : 0] next_state;

  // Sequential logic: update current_state on each clock edge,
  // or reset to IDLE when rstn is asserted low.
  always @(posedge clk) begin
    if (!rstn) next_state <= IDLE;
    else       current_state <= next_state;
  end

  // Next-state logic (combinational):
  // Advance through the state chain only when the next expected
  // bit is received; otherwise fall back to the appropriate state.
  always @(*) begin
    case (current_state)
      IDLE : next_state = (in) ? S1    : IDLE;   // Saw first '1'
      S1   : next_state = (in) ? IDLE  : S10;    // Saw '1' then '0'
      S10  : next_state = (in) ? S101  : IDLE;   // Saw '10' then '1'
      S101 : next_state = (in) ? S1011 : IDLE;   // Saw '101' then '1'
      S1011: next_state = IDLE;                    // Full pattern seen; restart
      default: next_state = IDLE;
    endcase
  end

  // Output is asserted only in the final "pattern detected" state
  assign out = (current_state == S1011);

endmodule
