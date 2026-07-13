`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/04/2026 02:15:44
// Design Name: Mod-N Counter
// Module Name: modN_ctr
// Tool Versions: Vivado 2025.2
// Description: Parametrizable modulo-N up-counter with asynchronous
//              active-low reset. Counter width is calculated from N.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module modN_ctr #(
    parameter N = 10,  // Modulus of the counter
    parameter WIDTH = $clog2(N)  // Width of the counter based on N (Ceiling of log2(N))
) (
    input clk,  // Clock input
    input rstn,  // Active low reset
    output reg [WIDTH-1:0] count  // Counter output
);

  always @(posedge clk or negedge rstn) begin : Counter_Logic
    if (!rstn) begin : Async_Reset  // Asynchronous reset
      count <= 0;
    end else begin
      if (count == N - 1) begin : Wrap_Around  // Wrap around when count reaches N-1
        count <= 0;
      end else begin : Increment  // Increment the counter
        count <= count + 1;
      end
    end
  end

endmodule
