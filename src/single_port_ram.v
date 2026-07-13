`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 2026-07-13 3:34:49
// Design Name: Single Port RAM
// Module Name: single_port_ram
// Tool Versions: Vivado 2025.2
// Description: Single-port synchronous RAM with registered read output and
//              tri-state data bus control. Supports configurable data width
//              and depth. Write takes priority when chip_select and
//              write_enable are both active. The addr port width is set by
//              ADDR_WIDTH; only the lower $clog2(DEPTH) bits are used to
//              index the memory array.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - 2026-07-13 - Fixed unsized 'hz, combined into single
//                               always block, added LOG2_DEPTH for safe
//                               addressing, filled description
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module single_port_ram #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16,
    parameter ADDR_WIDTH = 8
) (
    input  wire                  clk_i,
    input  wire [ADDR_WIDTH-1:0] addr_i,
    input  wire [DATA_WIDTH-1:0] data_in_i,
    input  wire                  write_enable_i,
    input  wire                  chip_select_i,
    input  wire                  output_enable_i,
    output wire [DATA_WIDTH-1:0] data_out_o
);

    // Internal address width derived from DEPTH — only this many bits
    // of the addr bus actually index the memory array.
    localparam LOG2_DEPTH = ($clog2(DEPTH) > 0) ? $clog2(DEPTH) : 1;

    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem        [0:DEPTH-1];
    // Registered read data output
    reg [DATA_WIDTH-1:0] data_out_q;

    // Registered read/write block: write takes priority — when both CS and
    // WE are active, data_in_i is written to the addressed location.  When CS
    // is active but WE is not, the addressed word is sampled into data_out_q
    // for the next clock cycle.
    always @(posedge clk_i) begin
        if (chip_select_i) begin
            if (write_enable_i) begin
                // Write: data_in_i is stored at the selected address
                mem[addr_i[LOG2_DEPTH-1:0]] <= data_in_i;
            end else begin
                // Read: sampled output is driven onto data_out_q on next cycle
                data_out_q <= mem[addr_i[LOG2_DEPTH-1:0]];
            end
        end
    end

    // Tri-state output: drive data_out_q onto the bus only during a read
    // cycle (CS and OE active, WE inactive); otherwise float the bus.
    assign data_out_o = (chip_select_i & output_enable_i & !write_enable_i)
                     ? data_out_q
                     : {DATA_WIDTH{1'bz}};

endmodule
