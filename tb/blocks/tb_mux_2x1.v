`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 02:57:03 AM
// Design Name: 2-to-1 Multiplexer Testbench
// Module Name: tb_mux_2x1
// Tool Versions: Vivado 2025.2
// Description: Applies all combinations of D0, D1 and S to verify
//              the behavior of `mux_2x1` and prints results.
// 
// Dependencies: mux_2x1 (src/blocks/mux_2x1.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_mux_2x1;

  // DUT interface
  reg  D0;  // Input 0
  reg  D1;  // Input 1
  reg  S;   // Select
  wire Y;   // Output: S ? D1 : D0

  // Module instantiation
  mux_2x1 dut (
      .D0(D0),
      .D1(D1),
      .S (S),
      .Y (Y)
  );

  // Test procedure: enumerate all input combinations
  initial begin : test
    D0 = 0; D1 = 0; S = 0; #10;
    D0 = 0; D1 = 0; S = 1; #10;
    D0 = 0; D1 = 1; S = 0; #10;
    D0 = 0; D1 = 1; S = 1; #10;
    D0 = 1; D1 = 0; S = 0; #10;
    D0 = 1; D1 = 0; S = 1; #10;
    D0 = 1; D1 = 1; S = 0; #10;
    D0 = 1; D1 = 1; S = 1; #10;
    $finish;
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_mux_2x1.vcd");
    $dumpvars(0, tb_mux_2x1);
  end

endmodule
