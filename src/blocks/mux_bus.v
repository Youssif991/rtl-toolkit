`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/29/2026 05:14:00 PM
// Design Name: 
// Module Name: mux_bus
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

module mux_bus #(
parameter bus = 4,
parameter selection = $clog2 (bus)
)(
    input [bus - 1:0] in,
    input [selection - 1:0] s,
    output [bus - 1:0] out
    );
    
    
endmodule
