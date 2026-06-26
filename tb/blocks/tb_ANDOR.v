`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2026 03:01:03 AM
// Design Name: 
// Module Name: tb_ANDOR
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


module tb_ANDOR;

reg        A;        
reg        B;          
reg        C;        
wire       F;       

ANDOR dut (
.A(A),
.B(B),
.C(C),
.F(F)
);

initial begin

#10 A = 0; B = 0; C = 0;
#10 A = 0; B = 0; C = 1;
#10 A = 0; B = 1; C = 0;
#10 A = 0; B = 1; C = 1;
#10 A = 1; B = 0; C = 0;
#10 A = 1; B = 0; C = 1;
#10 A = 1; B = 1; C = 0;
#10 A = 1; B = 1; C = 1;

end

endmodule
