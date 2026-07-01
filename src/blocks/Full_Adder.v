`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 04:22:48 PM
// Design Name: 
// Module Name: Full_Adder
// Tool Versions: Vivado 2025.2
// Description: Insert description here
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Full_Adder (
    input  A,
    input  B,
    input  Cin,
    output Sum,
    output Cout
);
  /*
    wire AB_xor;
    wire AB_and;
    wire AB_Cin;
    
    assign AB_xor = A ^ B;
    assign AB_and = A & B;
    assign AB_Cin = Cin & AB_xor;
    
    assign Sum = AB_xor ^ Cin;
    assign Cout = AB_Cin | AB_and;
    */
  //Second Implementations
  assign {Cout, Sum} = A + B + Cin;
endmodule
