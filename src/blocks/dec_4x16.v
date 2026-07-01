`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 02:07:49 AM
// Design Name: 
// Module Name: dec_4x16
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


module dec_4x16 (
    input [3:0] in,
    input en,
    output [15:0] out
);

  assign out = en ? 16'b1 << in : 0;

endmodule
