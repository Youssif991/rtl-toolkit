`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/02/2026 23:29:04
// Design Name: 
// Module Name: jk_ff
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

module jk_ff (
    input j, // Set input
    input k, // Reset input
    input clk, // Clock input
    input rstn, // Active low reset
    output reg q, // Output Q
    output reg q_bar // Output Q bar
);

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin : Async_Reset// Asynchronous reset
      q <= 1'b0;
      q_bar <= 1'b1;
    end else begin
      case ({
        j, k
      }) // Concatenate J and K inputs to form a 2-bit value
        2'b00: begin : Maintain
          // Mantain current state
          q <= q;
          q_bar <= q_bar;
        end
        2'b01: begin : Reset
          // Reset state (Q = 0)
          q <= 1'b0;
          q_bar <= 1'b1;
        end
        2'b10: begin : Set
          // Set state (Q = 1)
          q <= 1'b1;
          q_bar <= 1'b0;
        end
        2'b11: begin : Toggle
          // Toggle state
          q <= ~q;
          q_bar <= ~q_bar;
        end
      endcase
    end
  end

endmodule
