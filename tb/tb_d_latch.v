`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/04/2026 18:07:03
// Design Name: D-latch Testbench
// Module Name: tb_d_latch
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `d_latch` module. Uses a
//              golden reference model (transparent latch with async reset)
//              compared against the DUT on every input change. Covers
//              transparency, hold, async reset, and randomized stimulus.
// 
// Dependencies: d_latch (src/blocks/d_latch.v)
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Fixed end-of-test race condition, added directed reset test,
//                 seeded $random for reproducibility, added waveform dump.
// Revision 0.03 - Fixed blocking/non-blocking mix in stimulus loop,
//                 fixed d being assigned loop index instead of random value.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_d_latch;

  // DUT interface
  reg  d;     // Data input
  reg  en;    // Enable (transparent when high, holds when low)
  reg  rstn;  // Active-low asynchronous reset
  wire q;     // Output

  // Test infrastructure
  reg             expected_q;  // Golden reference output
  integer         i;           // Loop counter
  integer         errors = 0;  // Mismatch counter
  reg     [2 : 0] delay;       // Random delay for toggling inputs
  reg     [1 : 0] delay2;      // Random delay for toggling enable

  // Module instantiation
  d_latch dut (
      .d   (d),
      .en  (en),
      .rstn(rstn),
      .q   (q)
  );

  // Golden reference model
  // Models the transparent-latch behavior with asynchronous reset:
  //   - When rstn is low, q is forced to 0 regardless of en or d.
  //   - When en is high, the latch is transparent (q follows d).
  //   - When en is low, the latch holds its previous value.
  // The checker runs inline and flags any mismatch immediately.
  always @(d, en, rstn, q) begin : reference
    if (!rstn) expected_q <= 1'b0;
    else if (en) expected_q <= d;

    // Checker — compare on every input/output change
    if (q !== expected_q) begin : check
      errors = errors + 1;
      $display("FAIL at time %0t: d=%b en=%b rstn=%b | dut_q=%b expected_q=%b",
               $time, d, en, rstn, q, expected_q);
    end
  end

  // Test procedure
  initial begin : test
    // Drive all inputs low and assert reset
    d    = 0;
    en   = 0;
    rstn = 0;

    // --- Directed test 1: release reset while idle ---
    #10 rstn = 1;

    // --- Directed test 2: transparency (en=1, q follows d) ---
    en = 1;
    d  = 1;
    #5;

    // --- Directed test 3: async reset forces q to 0 ---
    rstn = 0;
    #5;

    // --- Directed test 4: return to normal operation ---
    rstn = 1;
    #5;

    // --- Randomized stimulus ---
    // Toggle en and d at random intervals to stress-test the latch.
    for (i = 0; i < 5; i = i + 1) begin
      delay  = $random;
      delay2 = $random;
      #(delay2) en = ~en;
      #(delay) d = $random;
    end

    // Allow last transaction to settle, then report
    #5;

    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);

    #10 $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin : monitor
    $monitor("Time=%0t | rstn=%b en=%b d=%b | dut_q=%b expected_q=%b",
             $time, rstn, en, d, q, expected_q);
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_d_latch.vcd");
    $dumpvars(0, tb_d_latch);
  end

endmodule
