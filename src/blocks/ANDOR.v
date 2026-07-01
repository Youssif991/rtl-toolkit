`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 02:19:24 AM
// Design Name: 
// Module Name: ANDOR
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


module ANDOR (
    input  A,
    input  B,
    input  C,
    output F
);

  wire AB;
  assign AB = A & B;
  assign F  = C & AB;

endmodule
