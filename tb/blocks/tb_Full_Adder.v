`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 06:39:41 PM
// Design Name: Full Adder Testbench
// Module Name: tb_Full_Adder
// Tool Versions: Vivado 2025.2
// Description: Exhaustive testbench for `Full_Adder`; iterates through
//              all A, B, Cin combinations and displays Sum and Cout.
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
  reg  A;     // Input A
  reg  B;     // Input B
  reg  Cin;   // Carry in
  wire Sum;   // Sum output
  wire Cout;  // Carry out
  integer i;  // Loop counter

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

    $monitor("Time: %0t | A: %b | B: %b | Cin: %b | Sum: %b | Cout: %b",
             $time, A, B, Cin, Sum, Cout);

    for (i = 0; i < 8; i = i + 1) begin
      {A, B, Cin} = i;
      #10;
    end

    $finish;
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_Full_Adder.vcd");
    $dumpvars(0, tb_Full_Adder);
  end

endmodule
