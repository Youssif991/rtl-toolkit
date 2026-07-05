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
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_t_ff;

  // Inputs
  reg t;
  reg clk;
  reg rstn;

  // Outputs
  wire q;

  // Test variables
  integer i;
  integer errors = 0;
  reg expected_q;

  // Todule inistintation
  t_ff dut (
      .t(t),
      .clk(clk),
      .rstn(rstn),
      .q(q)
  );

  // Golden Reference
  always @(posedge clk or negedge rstn) begin : Reference_Model
    if (!rstn) expected_q <= 1'b0;
    else if (t) expected_q <= ~expected_q;
  end
  // Check the dut against the golden reference
  always @(negedge clk) begin : check_model  // check at negedge, after posedge settled
    if (rstn && (q !== expected_q)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: t=%b | dut_q=%b expected_q=%b", $time, t, q, expected_q);
    end
  end

  // Clock generation
  initial begin : Clock
    clk = 0;
    forever #5 clk = ~clk;  // 10 ns period clock
  end

  // Test procedure
  initial begin : Test_cases

    // initialize the inputs
    t = 0;
    rstn = 0;

    @(negedge clk);
    t = 1;

    @(negedge clk);
    rstn = 1;  // release the reset

    @(negedge clk);
    t = 1;  // toggle
    @(negedge clk);
    t = 0;  // mantain

    // Random stimulus — stress test
    for (i = 0; i < 20; i = i + 1) begin : random_stimulus
      @(negedge clk);
      t = $random;
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
    $monitor("Time=%0t | rstn=%b t=%b | dut_q=%b expected_q=%b", $time, rstn, t, q, expected_q);
  end

  // Vcd dump
  initial begin
    $dumpfile("tb_t_ff.vcd");
    $dumpvars(0, tb_t_ff);
  end

endmodule
