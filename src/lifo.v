`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 2026-07-13
// Design Name: LIFO (Last-In-First-Out) Stack
// Module Name: lifo
// Tool Versions: Vivado 2025.2
// Description: LIFO (last-in-first-out) stack with configurable data width
//              and depth. Supports push and pop operations with full/empty
//              flag generation. Uses a single pointer (stack pointer) that
//              increments on push and decrements on pop.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module lifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8
) (
    input  wire                  clk_i,
    input  wire                  rst_n_i,
    input  wire                  push_i,
    input  wire                  pop_i,
    input  wire [DATA_WIDTH-1:0] data_i,
    output wire [DATA_WIDTH-1:0] data_o,
    output wire                  full_o,
    output wire                  empty_o
);

    // Internal address width derived from DEPTH
    localparam LOG2_DEPTH = ($clog2(DEPTH) > 0) ? $clog2(DEPTH) : 1;
    // Extra bit so the pointer can represent DEPTH for full detection
    localparam PTR_WIDTH = LOG2_DEPTH + 1;

    // Stack memory
    reg [DATA_WIDTH-1:0] stack[0:DEPTH-1];

    // Stack pointer (registered): points to the next free slot.
    // After reset, stack_ptr_q = 0 (empty stack).
    // On push: write to stack[stack_ptr_q[LOG2_DEPTH-1:0]], then increment.
    // On pop:  decrement first, then read from stack[stack_ptr_d[LOG2_DEPTH-1:0]].
    reg [PTR_WIDTH-1:0] stack_ptr_q;
    reg [PTR_WIDTH-1:0] stack_ptr_d;

    // Full/empty flags (registered)
    reg full_q;
    reg empty_q;
    // Full/empty flags (next-state, combinational)
    wire full_d;
    wire empty_d;

    // Registered read data output
    reg [DATA_WIDTH-1:0] data_out_q;

    // Push and Pop control signals
    wire do_push = push_i && !full_q;
    wire do_pop = pop_i && !empty_q;

    // Combinational: compute next stack pointer and flags
    always @(*) begin
        // Default: hold current value
        stack_ptr_d = stack_ptr_q;

        if (do_push && do_pop) begin
            stack_ptr_d = stack_ptr_q;  // hold the data
        end else if (do_push) begin
            stack_ptr_d = stack_ptr_q + 1;
        end else if (do_pop) begin
            stack_ptr_d = stack_ptr_q - 1;
        end
    end

    // Full when stack pointer has reached DEPTH (no free slots left)
    assign full_d  = (stack_ptr_d == $unsigned(DEPTH));

    // Empty when stack pointer is at 0 (no items in stack)
    assign empty_d = (stack_ptr_d == 0);

    // Sequential: update pointer and flags on clock edge
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            stack_ptr_q <= 0;
            full_q      <= 1'b0;
            empty_q     <= 1'b1;
        end else begin
            stack_ptr_q <= stack_ptr_d;
            full_q      <= full_d;
            empty_q     <= empty_d;
        end
    end

    // Memory write: push data onto the stack (uses current pointer before increment)
    always @(posedge clk_i) begin
        if (push_i && !full_q) begin
            stack[stack_ptr_q[LOG2_DEPTH-1:0]] <= data_i;
        end
    end

    // Memory read: pop data from the stack (uses next pointer after decrement)
    // Also resets data_out_q to clear X after startup.
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            data_out_q <= 0;
        end else if (pop_i && !empty_q) begin
            data_out_q <= stack[stack_ptr_d[LOG2_DEPTH-1:0]];
        end
    end

    // Output assignments
    assign data_o  = data_out_q;
    assign full_o  = full_q;
    assign empty_o = empty_q;

endmodule
