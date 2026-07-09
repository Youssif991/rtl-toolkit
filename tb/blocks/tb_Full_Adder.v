`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 06:39:41 PM
// Design Name: Full Adder Testbench
// Module Name: tb_Full_Adder
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `Full_Adder` module. Uses a
//              golden reference model (A + B + Cin) and a self-checker to
//              verify Sum and Cout across all 8 input combinations.
// 
// Dependencies: Full_Adder (src/blocks/Full_Adder.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_Full_Adder;

  // DUT interface
  reg  A;              // Input A
  reg  B;              // Input B
  reg  Cin;            // Carry in
  wire Sum;            // Sum output
  wire Cout;           // Carry out

  // Test infrastructure
  integer i;           // Loop counter
  reg expected_Sum;    // Golden reference Sum
  reg expected_Cout;   // Golden reference Cout
  integer errors = 0;  // Mismatch counter

  // Module instantiation
  Full_Adder dut (
      .A(A),
      .B(B),
      .Cin(Cin),
      .Sum(Sum),
      .Cout(Cout)
  );

  // Test procedure: exhaustively iterate all 8 input combinations
  initial begin : test
    A   = 0;
    B   = 0;
    Cin = 0;

    $monitor("Time: %0t | A: %b B: %b Cin: %b | Sum: %b Cout: %b | expected: %b%b",
             $time, A, B, Cin, Sum, Cout, expected_Sum, expected_Cout);

    for (i = 0; i < 8; i = i + 1) begin
      {A, B, Cin} = i;
      #10;

      // Self-check
      {expected_Cout, expected_Sum} = A + B + Cin;
      if (Sum !== expected_Sum || Cout !== expected_Cout) begin
        errors = errors + 1;
        $display("FAIL at time %0t: A=%b B=%b Cin=%b | dut Sum=%b Cout=%b | expected Sum=%b Cout=%b",
                 $time, A, B, Cin, Sum, Cout, expected_Sum, expected_Cout);
      end
    end

    #10;
    if (errors == 0) $display("TEST PASSED — all checks matched");
    else $display("TEST FAILED — %0d mismatches found", errors);
    $finish;
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_Full_Adder.vcd");
    $dumpvars(0, tb_Full_Adder);
  end

endmodule
