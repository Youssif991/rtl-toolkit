`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/05/2026 13:43:55
// Design Name: D FlipFlop Test Bench
// Module Name: tb_d_ff
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `d_ff` module. Uses a golden
//              reference model (posedge-triggered D flip-flop with async reset)
//              compared against the DUT on negedge clk. Covers directed reset/
//              capture cases plus randomized stimulus.
// 
// Dependencies: d_ff (src/blocks/d_ff.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_d_ff;

  // Inputs
  reg d;
  reg clk;
  reg rstn;

  // Outputs
  wire q;
  wire q_bar;

  // Test Variables
  integer i;
  integer errors = 0;
  reg expected_q;

  // Module inistantation
  d_ff dut (
      .d(d),
      .clk(clk),
      .rstn(rstn),
      .q(q),
      .q_bar(q_bar)
  );

  // Clock generation
  initial begin : Clock
    clk = 0;
    forever #10 clk = ~clk;  // 20 ns period clock
  end

  // Golden reference
  always @(posedge clk or negedge rstn) begin : Reference_Model
    if (!rstn) expected_q <= 1'b0;
    else expected_q = d;
  end

  // Check the dut against the golden reference
  always @(negedge clk) begin : check_model  // check at negedge, after posedge settled
    if (rstn && (q !== expected_q)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: d=%b | dut_q=%b expected_q=%b", $time, d, q, expected_q);
    end
  end

  // Test procedure
  initial begin : Test

    // Initialize the inputs
    d = 0;
    rstn = 0;

    @(negedge clk);
    d = 1;  // test whether the input will change or not when the reset is active

    @(negedge clk);
    rstn = 1;  // release the reset

    @(negedge clk);
    d = 0;  // set the output to 0

    @(negedge clk);
    d = 1;  // set the output to 1

    // Random stimulus — stress test
    for (i = 0; i < 20; i = i + 1) begin : random_test
      @(negedge clk);
      d = $random;
    end

    #20;

    // Final report
    if (errors == 0) begin : report_pass
      $display(" TEST PASSED — all checks matched");
    end else begin : report_fail
      $display(" TEST FAILED — %0d mismatches found", errors);
    end
    $finish;
  end

  // Live monitor 
  initial begin : live_monitor
    $monitor("Time=%0t | rstn=%b d=%b | dut_q=%b expected_q=%b", $time, rstn, d, q, expected_q);
  end

  // Vcd dump
  initial begin
    $dumpfile("tb_d_ff.vcd");
    $dumpvars(0, tb_d_ff);
  end

endmodule
