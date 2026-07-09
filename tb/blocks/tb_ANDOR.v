`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 03:01:03 AM
// Design Name: ANDOR Testbench
// Module Name: tb_ANDOR
// Tool Versions: Vivado 2025.2
// Description: Stimulates the ANDOR module through all input combinations
//              and prints the resulting output `F`. Simple vector test.
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
  reg  A;  // Input A
  reg  B;  // Input B
  reg  C;  // Input C
  wire F;  // Output: C | (A & B)

  // Module instantiation
  ANDOR dut (
      .A(A),
      .B(B),
      .C(C),
      .F(F)
  );

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
    $finish;
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_ANDOR.vcd");
    $dumpvars(0, tb_ANDOR);
  end

endmodule
