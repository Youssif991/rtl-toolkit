`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/06/2026 14:52:54
// Design Name: Seven Segment Display
// Module Name: seven_seg
// Tool Versions: Vivado 2025.2
// Description: Seven Segement display which converts the BCD number to its equivalent number on a seven segement display.
// It can either active high or active low based on the active_low parameter
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module seven_seg #(
    parameter active_low = 0  // parameter to toggle between active high or active low

) (
    input  [3 : 0] in,
    output [6 : 0] out
);
  reg [6 : 0] out_active_high;
  always @(*) begin : seven_segment_cases
    case (in)

      4'h0: out_active_high = 7'b1111110;  // display 0
      4'h1: out_active_high = 7'b0110000;  // display 1
      4'h2: out_active_high = 7'b1101101;  // display 2
      4'h3: out_active_high = 7'b1111001;  // display 3
      4'h4: out_active_high = 7'b0110011;  // display 4
      4'h5: out_active_high = 7'b1011011;  // display 5
      4'h6: out_active_high = 7'b1011111;  // display 6
      4'h7: out_active_high = 7'b1110000;  // display 7
      4'h8: out_active_high = 7'b1111111;  // display 8
      4'h9: out_active_high = 7'b1111010;  // display 9
      default:
      out_active_high = 7'b0000000;  // the default display as long as there is no BCD input

    endcase
  end

  assign out = active_low ? ~out_active_high : out_active_high; // output is based on the polarity parameter (active high or active low)

endmodule
