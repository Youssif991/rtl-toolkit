`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 02:57:03 AM
// Design Name: 
// Module Name: tb_mux_2x1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_mux_2x1;

  reg  D0;
  reg  D1;
  reg  S;
  wire Y;

  mux_2x1 dut (
      .D0(D0),
      .D1(D1),
      .S (S),
      .Y (Y)
  );

  initial begin

    D0 = 0;
    D1 = 0;
    S  = 0;
    #10 D0 = 0;
    D1 = 0;
    S  = 1;
    #10 D0 = 0;
    D1 = 1;
    S  = 0;
    #10 D0 = 0;
    D1 = 1;
    S  = 1;
    #10 D0 = 1;
    D1 = 0;
    S  = 0;
    #10 D0 = 1;
    D1 = 0;
    S  = 1;
    #10 D0 = 1;
    D1 = 1;
    S  = 0;
    #10 D0 = 1;
    D1 = 1;
    S  = 1;
    #10 $finish;
  end

endmodule
