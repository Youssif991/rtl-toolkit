`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 06:39:41 PM
// Design Name: 
// Module Name: tb_Full_Adder
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


module tb_Full_Adder;

reg A;
reg B;
reg Cin;
wire Sum;
wire Cout;

Full_Adder dut (
.A(A),
.B(B),
.Cin(Cin),
.Sum(Sum),
.Cout(Cout)
);

initial begin 
#10     A = 0;      B = 0;      Cin = 0;
#10     A = 0;      B = 0;      Cin = 1;
#10     A = 0;      B = 1;      Cin = 0;
#10     A = 0;      B = 1;      Cin = 1;
#10     A = 1;      B = 0;      Cin = 0;
#10     A = 1;      B = 0;      Cin = 1;
#10     A = 1;      B = 1;      Cin = 0;
#10     A = 1;      B = 1;      Cin = 1;
end

endmodule
