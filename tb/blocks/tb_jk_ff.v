`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/03/2026 17:14:08
// Design Name: JK Flip-Flop Testbench
// Module Name: tb_jk_ff
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `jk_ff` module. Uses a
//              golden reference model (JK truth table: hold, reset, set,
//              toggle) compared against the DUT on negedge clk. Covers
//              directed cases and randomized stimulus.
// 
// Dependencies: jk_ff (src/blocks/jk_ff.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_jk_ff;

  // DUT interface
  reg  j;      // Set input
  reg  k;      // Reset input
  reg  clk;    // Clock
  reg  rstn;   // Active-low asynchronous reset
  wire q;      // Output
  wire q_bar;  // Complementary output

  // Test infrastructure
  reg expected_q;       // Golden reference output
  integer errors = 0;   // Mismatch counter
  integer i;            // Loop counter

  // Module instantiation
  jk_ff dut (
      .j   (j),
      .k   (k),
      .clk (clk),
      .rstn(rstn),
      .q   (q),
      .q_bar(q_bar)
  );

  // Clock generation: free-running 10 ns period (100 MHz)
  initial begin : clock
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Golden reference
  // Implements the JK flip-flop truth table:
  //   00 = hold, 01 = reset, 10 = set, 11 = toggle
  // On async reset, output is cleared to 0.
  always @(posedge clk or negedge rstn) begin : reference
    if (!rstn) expected_q <= 0;
    else begin
      case ({j, k})
        2'b00: expected_q <= expected_q;  // hold
        2'b01: expected_q <= 0;            // reset
        2'b10: expected_q <= 1;            // set
        2'b11: expected_q <= ~expected_q;   // toggle
      endcase
    end
  end

  // Checker — compare at negedge, after posedge capture has settled
  always @(negedge clk) begin : check
    if (rstn && (q !== expected_q)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: j=%b k=%b | dut_q=%b expected_q=%b", $time, j, k, q, expected_q);
    end
  end

  // Test procedure
  initial begin : test
    // Drive all inputs low and assert reset
    j    = 0;
    k    = 0;
    rstn = 0;

    #10 rstn = 1;

    // --- Directed test 1: hold (j=0, k=0) ---
    @(negedge clk);
    j = 0; k = 0;

    // --- Directed test 2: reset (j=0, k=1) ---
    @(negedge clk);
    j = 0; k = 1;

    // --- Directed test 3: set (j=1, k=0) ---
    @(negedge clk);
    j = 1; k = 0;

    // --- Directed test 4: toggle (j=1, k=1) ---
    @(negedge clk);
    j = 1; k = 1;

    // --- Directed test 5: toggle again ---
    @(negedge clk);

    // --- Random stimulus ---
    // Stress-test the flip-flop with 20 random (j, k) pairs.
    for (i = 0; i < 20; i = i + 1) begin
      @(negedge clk);
      j = $random;
      k = $random;
    end

    // Allow last transaction to settle, then report
    #20;

    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);

    $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin : monitor
    $monitor("Time=%0t | rstn=%b j=%b k=%b | dut_q=%b expected_q=%b",
             $time, rstn, j, k, q, expected_q);
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_jk_ff.vcd");
    $dumpvars(0, tb_jk_ff);
  end

endmodule
