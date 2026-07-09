`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 02:13:34 AM
// Design Name: AND Gate Testbench
// Module Name: tb_andgate
// Tool Versions: Vivado 2025.2
// Description: Simple testbench enumerating input combinations for
//              `andgate` and printing the resulting output `C`.
// 
// Dependencies: andgate (src/gates/andgate.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_andgate;

  // DUT interface
  reg  A;  // Input A
  reg  B;  // Input B
  wire C;  // Output: A & B

  // Module instantiation
  andgate dut (
      .A(A),
      .B(B),
      .C(C)
  );

  // Test procedure: enumerate all input combinations
  initial begin : test
    A = 0; B = 0; #10;
    A = 0; B = 1; #10;
    A = 1; B = 0; #10;
    A = 1; B = 1; #10;
    $finish;
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_andgate.vcd");
    $dumpvars(0, tb_andgate);
  end

endmodule
