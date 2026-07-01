`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 04:05:23 PM
// Design Name: 
// Module Name: mux
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


module mux #(
    parameter width = 4,
    parameter selection = $clog2 (width)
)(
    input [width - 1 : 0] in,
    input [selection - 1 : 0] s,
    output out
    );
    
    assign out = in[s];
endmodule
