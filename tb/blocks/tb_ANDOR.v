`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 03:01:03 AM
// Design Name: ANDOR Testbench
// Module Name: tb_ANDOR
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `ANDOR` module. Uses a
//              golden reference model (C | (A & B)) compared against the
//              DUT on every input change. Enumerates all combinations.
// 
// Dependencies: ANDOR (src/blocks/ANDOR.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_ANDOR;

  // DUT interface
  reg  A;            // Input A
  reg  B;            // Input B
  reg  C;            // Input C
  wire F;            // Output: C | (A & B)

  // Test infrastructure
  reg expected_F;    // Golden reference output
  integer errors = 0;  // Mismatch counter

  // Module instantiation
  ANDOR dut (
      .A(A),
      .B(B),
      .C(C),
      .F(F)
  );

  // Golden reference: compute F = C | (A & B)
  always @(*) begin : reference
    expected_F = C | (A & B);
  end

  // Checker
  always @(*) begin : check
    #1;
    if (F !== expected_F) begin
      errors = errors + 1;
      $display("FAIL at time %0t: A=%b B=%b C=%b | dut=%b expected=%b", $time, A, B, C, F, expected_F);
    end
  end

  // Test procedure: enumerate all input combinations
  initial begin : test
    A = 0; B = 0; C = 0; #10;
    A = 0; B = 0; C = 1; #10;
    A = 0; B = 1; C = 0; #10;
    A = 0; B = 1; C = 1; #10;
    A = 1; B = 0; C = 0; #10;
    A = 1; B = 0; C = 1; #10;
    A = 1; B = 1; C = 0; #10;
    A = 1; B = 1; C = 1; #10;
    #10;
    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);
    $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin : monitor
    $monitor("Time=%0t | A=%b B=%b C=%b | dut_out=%b expected=%b", $time, A, B, C, F, expected_F);
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_ANDOR.vcd");
    $dumpvars(0, tb_ANDOR);
  end

endmodule
