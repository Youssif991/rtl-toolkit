`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 02:52:53 AM
// Design Name: OR Gate Testbench
// Module Name: tb_orgate
// Tool Versions: Vivado 2025.2
// Description: Simple testbench enumerating input combinations for
//              `orgate` and printing the resulting output `C`.
// 
// Dependencies: orgate (src/gates/orgate.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_orgate;

  reg  A;
  reg  B;
  wire C;

  orgate dut (
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
    $dumpfile("tb_orgate.vcd");
    $dumpvars(0, tb_orgate);
  end

endmodule
