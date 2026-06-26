`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 02:52:53 AM
// Design Name: 
// Module Name: tb_orgate
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


module tb_orgate;

reg      A;
reg      B;
wire     C;

orgate dut(
.A(A),
.B(B),
.C(C)
);

initial begin

    A = 0; B =0;
#10 A = 0; B =1;
#10 A = 1; B =0;
#10 A = 1; B =1;
#10 $finish;

end
endmodule
