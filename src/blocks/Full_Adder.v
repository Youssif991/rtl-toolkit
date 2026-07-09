`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 04:22:48 PM
// Design Name: 1-bit Full Adder
// Module Name: Full_Adder
// Tool Versions: Vivado 2025.2
// Description: Performs single-bit addition with carry-in and carry-out.
//              Outputs Sum and Cout for inputs A, B, and Cin.
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
  // Second implementation: use Verilog's built-in arithmetic.
  // {Cout, Sum} acts as a 2-bit result of the addition.
  assign {Cout, Sum} = A + B + Cin;
endmodule
