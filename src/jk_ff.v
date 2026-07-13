`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/02/2026 23:29:04
// Design Name: JK Flip-Flop (edge-triggered)
// Module Name: jk_ff
// Tool Versions: Vivado 2025.2
// Description: Edge-triggered JK flip-flop with asynchronous active-low
//              reset. Outputs `q` and `q_bar`; supports set, reset,
//              hold and toggle behaviour on clock edges.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module jk_ff (
    input      clk_i,
    input      rst_n_i,
    input      j_i,
    input      k_i,
    output reg q_o,
    output reg q_bar_o
);

    // Sequential logic: JK truth table on rising clock edge
    //   {j_i, k_i}  |  Behavior
    //   ------------+--------------------------
    //   2'b00       |  Hold (q unchanged)
    //   2'b01       |  Reset  (q = 0)
    //   2'b10       |  Set    (q = 1)
    //   2'b11       |  Toggle (q = ~q)
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            q_o     <= 1'b0;  // Asynchronous active-low reset
            q_bar_o <= 1'b1;
        end else begin
            // Decode JK input pair to select next state
            case ({
                j_i, k_i
            })
                2'b00: begin
                    // Maintain current state
                end
                2'b01: begin
                    q_o    <= 1'b0;
                    q_bar_o <= 1'b1;
                end
                2'b10: begin
                    q_o    <= 1'b1;
                    q_bar_o <= 1'b0;
                end
                2'b11: begin
                    q_o    <= ~q_o;
                    q_bar_o <= ~q_bar_o;
                end
                default: begin
                    // Maintain current state
                end
            endcase
        end
    end

endmodule
