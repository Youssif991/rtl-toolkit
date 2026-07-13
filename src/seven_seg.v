`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/06/2026 14:52:54
// Design Name: Seven Segment Display
// Module Name: seven_seg
// Tool Versions: Vivado 2025.2
// Description: BCD-to-7-segment decoder. Maps a 4-bit BCD input (`in`) to a
//              7-bit segment pattern (`out`) for driving a common-cathode or
//              common-anode 7-segment display. The `ActiveLow` parameter
//              selects polarity: 0 for active-high segments, 1 for active-low.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module seven_seg #(
    parameter ACTIVE_LOW = 0
) (
    input  [3 : 0] in_i,
    output [6 : 0] out_o
);

    reg [6 : 0] out_active_high;

    always @(*) begin
        // Map the 4-bit BCD input to an active-high 7-segment pattern.
        case (in_i)
            4'h0: out_active_high = 7'b1111110;  // Digit 0: segments a,b,c,d,e,f
            4'h1: out_active_high = 7'b0110000;  // Digit 1: segments b,c
            4'h2: out_active_high = 7'b1101101;  // Digit 2: segments a,b,d,e,g
            4'h3: out_active_high = 7'b1111001;  // Digit 3: segments a,b,c,d,g
            4'h4: out_active_high = 7'b0110011;  // Digit 4: segments b,c,f,g
            4'h5: out_active_high = 7'b1011011;  // Digit 5: segments a,c,d,f,g
            4'h6: out_active_high = 7'b1011111;  // Digit 6: segments a,c,d,e,f,g
            4'h7: out_active_high = 7'b1110000;  // Digit 7: segments a,b,c
            4'h8: out_active_high = 7'b1111111;  // Digit 8: all segments on
            4'h9: out_active_high = 7'b1111010;  // Digit 9: segments a,b,c,d,f,g
            default: out_active_high = 7'b0000000;  // All segments off (invalid BCD)
        endcase
    end

    // Apply polarity: invert when ActiveLow is set (for common-anode displays).
    assign out_o = ACTIVE_LOW ? ~out_active_high : out_active_high;

endmodule
