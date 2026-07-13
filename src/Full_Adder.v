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
    input  A_i,
    input  B_i,
    input  Cin_i,
    output Sum_o,
    output Cout_o
);

    // Concatenate carry-out and sum into a 2-bit result: {Cout, Sum} = A + B + Cin.
    assign {Cout_o, Sum_o} = A_i + B_i + Cin_i;

endmodule
