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
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_andgate;

  reg  A;
  reg  B;
  wire C;

  andgate dut (
      .A(A),
      .B(B),
      .C(C)
  );

  initial begin

    A = 0;
    B = 0;
    #10 A = 0;
    B = 1;
    #10 A = 1;
    B = 0;
    #10 A = 1;
    B = 1;
    #10 $finish;
  end
  initial begin
    $dumpfile("tb_andgate.vcd");
    $dumpvars(0, tb_andgate);
  end
endmodule
