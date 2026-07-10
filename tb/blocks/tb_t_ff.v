`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/04/2026 21:45:42
// Design Name: T Flip Flop test bench
// Module Name: tb_t_ff
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the t_ff module. Uses a golden
//              reference model (toggle on t=1, hold on t=0, async reset)
//              compared against the DUT on negedge clk. Covers directed
//              reset/toggle/hold cases plus randomized stimulus.
// 
// Dependencies: t_ff (src/blocks/t_ff.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_t_ff;

  // DUT interface
  reg t;     // Toggle input
  reg clk;   // Clock
  reg rstn;  // Active-low asynchronous reset
  wire q;    // Output

  // Test infrastructure
  integer i;              // Loop counter
  integer errors = 0;     // Mismatch counter
  reg expected_q;         // Golden reference output

  // Module instantiation
  t_ff dut (
      .t   (t),
      .clk (clk),
      .rstn(rstn),
      .q   (q)
  );

  // Golden reference
  // Toggles on t=1, holds on t=0, clears to 0 on async reset.
  always @(posedge clk or negedge rstn) begin : reference
    if (!rstn) expected_q <= 1'b0;
    else if (t) expected_q <= ~expected_q;
  end

  // Checker — compare at negedge, after posedge capture has settled
  always @(negedge clk) begin : check
    if (rstn && (q !== expected_q)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: t=%b | dut_q=%b expected_q=%b", $time, t, q, expected_q);
    end
  end

  // Clock generation: free-running 10 ns period (100 MHz)
  initial begin : clock
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test procedure
  initial begin : test
    // Drive all inputs low and assert reset
    t    = 0;
    rstn = 0;

    @(negedge clk);
    t = 1;

    // --- Directed test 1: release reset, then toggle ---
    @(negedge clk);
    rstn = 1;  // release the reset

    @(negedge clk);
    t = 1;  // toggle

    // --- Directed test 2: hold (t=0) ---
    @(negedge clk);
    t = 0;  // hold

    // --- Random stimulus ---
    // Stress-test with 20 random toggle values.
    for (i = 0; i < 20; i = i + 1) begin
      @(negedge clk);
      t = $random;
    end

    // Allow last transaction to settle, then report
    #20;

    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);

    $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin : monitor
    $monitor("Time=%0t | rstn=%b t=%b | dut_q=%b expected_q=%b", $time, rstn, t, q, expected_q);
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_t_ff.vcd");
    $dumpvars(0, tb_t_ff);
  end

endmodule
