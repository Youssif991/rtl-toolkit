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
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_Full_Adder;

  reg A;
  reg B;
  reg Cin;
  wire Sum;
  wire Cout;
  integer i;

  Full_Adder dut (
      .A(A),
      .B(B),
      .Cin(Cin),
      .Sum(Sum),
      .Cout(Cout)
  );

  initial begin

    A   = 0;
    B   = 0;
    Cin = 0;

    $monitor("Time: %0t | A: %b | B: %b | Cin: %b | Sum: %b | Cout: %b", $time, A, B, Cin, Sum, Cout);

    for (i = 0; i < 8; i = i + 1) begin
      {A, B, Cin} = i;
      #10;
    end

  end

endmodule
