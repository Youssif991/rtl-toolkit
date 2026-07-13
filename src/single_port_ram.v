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
    input  wire                  clk,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire                  write_enable,
    input  wire                  chip_select,
    input  wire                  output_enable,
    output wire [DATA_WIDTH-1:0] data_out
);

    // Internal address width derived from DEPTH — only this many bits
    // of the addr bus actually index the memory array.
    localparam LOG2_DEPTH = ($clog2(DEPTH) > 0) ? $clog2(DEPTH) : 1;

    reg [DATA_WIDTH-1:0] mem          [0:DEPTH-1];
    reg [DATA_WIDTH-1:0] data_out_reg;

    // Registered write and read: write takes priority when both
    // chip_select and write_enable are asserted.
    always @(posedge clk) begin
        if (chip_select) begin
            if (write_enable) begin
                mem[addr[LOG2_DEPTH-1:0]] <= data_in;
            end else begin
                data_out_reg <= mem[addr[LOG2_DEPTH-1:0]];
            end
        end
    end

    // Tri-state output bus: data_out_reg drives the bus only when
    // chip_select and output_enable are active during a read cycle.
    assign data_out = (chip_select & output_enable & !write_enable)
                      ? data_out_reg
                      : {DATA_WIDTH{1'bz}};

endmodule
