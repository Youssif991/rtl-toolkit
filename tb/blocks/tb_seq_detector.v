`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/09/2026 20:51:13
// Design Name: Sequence Detector Testbench
// Module Name: tb_seq_detector
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `seq_detector` module. Uses a
//              golden reference model (Moore FSM detecting "1011") compared
//              against the DUT on negedge clk. Covers reset, directed
//              sequence patterns, and randomized stimulus.
// 
// Dependencies: seq_detector (src/blocks/seq_detector.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_seq_detector;

  // State encoding — mirrors the `seq_detector` DUT's Moore FSM states
  // IDLE  : No partial match yet
  // S1    : Matched '1'
  // S10   : Matched '10'
  // S101  : Matched '101'
  // S1011 : Full match '1011' (output asserted)
  localparam IDLE = 3'b000;
  localparam S1 = 3'b001;
  localparam S10 = 3'b010;
  localparam S101 = 3'b011;
  localparam S1011 = 3'b100;

  // DUT interface
  reg             in;  // Serial data input
  reg             clk;  // Clock (free-running, 20 ns period)
  reg             rstn;  // Active-low asynchronous reset
  wire            out;  // DUT output — high for one cycle when "1011" is detected

  // Test infrastructure
  integer         i;  // Loop counter for random stimulus
  integer         errors = 0;  // Mismatch counter
  wire            expected_out;  // Golden reference output
  reg     [2 : 0] ref_state;  // Golden reference: current state (registered)
  reg     [2 : 0] ref_next;  // Golden reference: next state (combinational)

  // Module instantiation
  seq_detector dut (
      .in  (in),
      .clk (clk),
      .rstn(rstn),
      .out (out)
  );

  // Golden reference model
  // A two-stage pipeline (ref_next → ref_state) that mirrors the
  // DUT's architecture cycle-for-cycle.
  //
  // Sequential: on async reset, prime ref_next to IDLE; otherwise
  // advance ref_state to the previously computed ref_next.
  always @(posedge clk or negedge rstn) begin : reference_seq
    if (!rstn) begin
        ref_state <= IDLE;
    end else begin
        ref_state <= ref_next;
    end
  end

  // Combinational: compute the next state based on the current
  // ref_state and the serial input `in`. Follows the same
  // "1011" transition logic as the DUT.
  always @(*) begin : reference_comb
    case (ref_state)
      IDLE:    ref_next = (in) ? S1 : IDLE;  // First '1' seen
      S1:      ref_next = (in) ? IDLE : S10;  // '1' then '0' → "10"
      S10:     ref_next = (in) ? S101 : IDLE;  // '10' then '1' → "101"
      S101:    ref_next = (in) ? S1011 : IDLE;  // '101' then '1' → "1011" ✓
      S1011:   ref_next = IDLE;  // Full match; restart
      default: ref_next = IDLE;
    endcase
  end

  // Output decode: expected_out is high only when ref_state reaches
  // the terminal state S1011 (Moore machine property).
  assign expected_out = (ref_state == S1011);

  // Checker
  // Compares the DUT output against the golden reference on the
  // falling clock edge, after the posedge capture has fully settled.
  always @(negedge clk) begin : check
    if (rstn && (out !== expected_out)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: in=%b | dut_out=%b expected_out=%b (ref_state=%b)", $time, in,
               out, expected_out, ref_state);
    end
  end

  // Clock generation: free-running 20 ns period (50 MHz)

  initial begin : clock
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Test procedure
  initial begin : test
    // Drive all inputs low and assert reset
    in   = 0;
    rstn = 0;

    // Wait one negedge, then release reset
    @(negedge clk);
    rstn = 1;

    // --- Directed test 1: successful "1011" detection ---
    // Feed the bits one-by-one at each negedge so they are
    // stable when sampled on the following posedge.
    @(negedge clk);
    in = 1;  // bit 1
    @(negedge clk);
    in = 0;  // bit 2
    @(negedge clk);
    in = 1;  // bit 3
    @(negedge clk);
    in = 1;  // bit 4 — DUT should assert out

    // --- Directed test 2: partial match then recovery ---
    // After seeing "10", a wrong bit ("0" instead of "1") should
    // send the FSM back to IDLE to restart the search.
    @(negedge clk);
    in = 1;  //  1
    @(negedge clk);
    in = 0;  // 10
    @(negedge clk);
    in = 0;  // 100 — mismatch, back to IDLE
    @(negedge clk);
    in = 1;  // restart:  1
    @(negedge clk);
    in = 0;  //          10
    @(negedge clk);
    in = 1;  //         101
    @(negedge clk);
    in = 1;  //        1011 — should detect again

    // --- Random stimulus ---
    // Stress-test the FSM with 50 random bits to catch
    // unexpected corner cases.
    for (i = 0; i < 50; i = i + 1) begin
      @(negedge clk);
      in = $random;
    end

    // Allow last transaction to settle, then report
    #20;

    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);

    $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin
    $monitor("Time=%0t | rstn=%b in=%b | dut_out=%b expected_out=%b ref_state=%b", $time, rstn, in,
             out, expected_out, ref_state);
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_seq_detector.vcd");
    $dumpvars(0, tb_seq_detector);
  end

endmodule
