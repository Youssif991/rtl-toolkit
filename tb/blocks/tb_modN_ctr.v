`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/04/2026 02:33:38
// Design Name: Mod-N Counter Testbench
// Module Name: tb_modN_ctr
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for `modN_ctr` using a golden
//              reference model to verify counting behavior including
//              wraparound and reset behavior.
// 
// Dependencies: modN_ctr (src/blocks/modN_ctr.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_modN_ctr;

  // Parameters
  localparam N = 10;  // Modulus of the counter
  localparam WIDTH = $clog2(N);  // Width of the counter based on N

  // Inputs
  reg clk;
  reg rstn;

  // Outputs
  wire [WIDTH-1:0] count;

  // Golden reference model
  reg [WIDTH-1:0] expected_count;
  integer errors = 0;

  // Instantiate the modN_ctr module
  modN_ctr #(
      .N(N),
      .WIDTH(WIDTH)
  ) dut (
      .clk  (clk),
      .rstn (rstn),
      .count(count)
  );

  // Clock generation
  initial begin : Clock_Generation
    clk = 0;
    forever #10 clk = ~clk;  // 20ns period
  end

  // Golden reference model — mirrors the expected mod-N counting behavior
  always @(posedge clk or negedge rstn) begin : Reference_Model
    if (!rstn) expected_count <= 0;
    else if (expected_count == N - 1) expected_count <= 0;
    else expected_count <= expected_count + 1;
  end

  // Self-checker — compares DUT against reference model
  always @(negedge clk) begin : Checker
    if (rstn && (count !== expected_count)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: dut_count=%0d expected_count=%0d", $time, count, expected_count);
    end
  end

  // Testbench procedure
  initial begin : Testbench_Procedure
    rstn = 0;

    #15 rstn = 1;  // release reset mid-cycle, avoids landing exactly on a clock edge

    // Run long enough to see multiple full wraparounds of the counter
    repeat (N * 3) @(posedge clk);  // wait for 3 full cycles of the counter

    #20;

    if (errors == 0) $display("TEST PASSED - all checks matched");
    else $display("TEST FAILED - %0d mismatches found", errors);

    $finish;
  end

  initial begin
    $dumpfile("tb_modN_ctr.vcd");
    $dumpvars(0, tb_modN_ctr);
  end

  // Live monitor
  initial begin : Monitor_Outputs
    $monitor("Time=%0t | rstn=%b | dut_count=%0d expected_count=%0d", $time, rstn, count,
             expected_count);
  end

endmodule
