`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/10/2026 15:27:04
// Design Name: Testbench for Positive Edge Detector
// Module Name: tb_pos_edge
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `pos_edge` module. Uses a golden
//              reference model (registered rising-edge detector with async reset)
//              compared against the DUT on negedge clk. Covers reset, directed
//              edge cases, and randomized stimulus.
//
// Dependencies: pos_edge (src/blocks/pos_edge.v)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_pos_edge;

  // DUT interface
  reg     sig;  // Input signal to detect rising edges on
  reg     clk;  // Clock (free-running, 20 ns period)
  reg     rstn;  // Active-low asynchronous reset
  wire    out;  // DUT output — pulses high for one cycle on a rising edge of sig

  // Test infrastructure
  integer i;  // Loop counter for random stimulus
  integer errors = 0;  // Mismatch counter
  reg     expected_out;  // Golden reference output
  reg     sig_prev;  // Golden reference: previous-cycle value of sig

  // Module instantiation
  pos_edge dut (
      .sig (sig),
      .clk (clk),
      .rstn(rstn),
      .out (out)
  );

  // Golden reference model
  // On each clock edge, captures the current `sig` into `sig_prev` and
  // computes `expected_out` as `sig & ~sig_prev` — high only when `sig`
  // transitions from 0 to 1 (rising edge).
  always @(posedge clk or negedge rstn) begin : reference
    if (!rstn) begin
      sig_prev     <= 0;
      expected_out <= 0;
    end else begin
      sig_prev     <= sig;
      expected_out <= sig & ~sig_prev;
    end
  end

  // Checker
  // Compares the DUT output against the golden reference on the
  // falling clock edge, after the posedge capture has fully settled.
  always @(negedge clk) begin : check
    if (rstn && (out !== expected_out)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: sig=%b | dut_out=%b expected_out=%b", $time, sig, out,
               expected_out);
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
    sig  = 0;
    rstn = 0;

    // Wait one negedge, then release reset
    @(negedge clk);
    rstn = 1;

    // --- Directed test 1: sig stays low ---
    // No rising edge present; out should remain 0.
    @(negedge clk);
    sig = 0;

    // --- Directed test 2: low-to-high transition ---
    // Rising edge expected on the next posedge.
    @(negedge clk);
    sig = 1;

    // --- Directed test 3: sig stays high ---
    // No new rising edge; out should return to 0.
    @(negedge clk);

    // --- Directed test 4: high-to-low transition ---
    // Falling edge only; no rising edge expected.
    @(negedge clk);
    sig = 0;

    // --- Directed test 5: back-to-back rising edges ---
    // Toggle sig every cycle to produce multiple pulses.
    repeat (3) begin
      @(negedge clk);
      sig = 1;
      @(negedge clk);
      sig = 0;
    end

    // --- Random stimulus ---
    // Stress-test the detector with 30 random sig values to
    // catch unexpected corner cases.
    for (i = 0; i < 30; i = i + 1) begin
      @(negedge clk);
      sig = $random;
    end

    // Allow last transaction to settle, then report
    #20;

    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);

    $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin
    $monitor("Time=%0t | rstn=%b sig=%b | dut_out=%b expected_out=%b", $time, rstn, sig, out,
             expected_out);
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_pos_edge.vcd");
    $dumpvars(0, tb_pos_edge);
  end

endmodule
