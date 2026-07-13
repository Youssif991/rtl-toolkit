`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/01/2026 21:46:45
// Design Name: Priority Encoder (bus-based)
// Module Name: Priority_Encoder
// Tool Versions: Vivado 2025.2
// Description: Scans concatenated input buses and assigns the output
//              to a non-zero input bus. Later input buses override earlier
//              ones in the current implementation (index-based priority).
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module Priority_Encoder #(
    parameter BUS_WIDTH  = 8,
    parameter NUM_INPUTS = 4
) (
    input [BUS_WIDTH * NUM_INPUTS - 1 : 0] in_i,
    output reg [BUS_WIDTH - 1 : 0] out_o
);

    integer i;

    // Combinational priority scan: the highest-index non-zero input bus wins.
    // Later iterations override earlier ones, giving higher indices priority.
    always @(*) begin
        out_o = 0;

        // Iterate over all input buses from index 0 to NUM_INPUTS-1.
        for (i = 0; i < NUM_INPUTS; i = i + 1) begin
            // If this input bus is non-zero, assign it to the output.
            if (in_i[i*BUS_WIDTH+:BUS_WIDTH] != 0) begin
                out_o = in_i[i*BUS_WIDTH+:BUS_WIDTH];
            end
        end
    end

endmodule
