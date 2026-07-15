`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 2026-07-13
// Design Name: Synchronous FIFO
// Module Name: sync_fifo
// Tool Versions: Vivado 2025.2
// Description: Synchronous FIFO with configurable data width and depth.
//              Uses a dual-port RAM and read/write pointers with full/empty
//              flag generation. Full/empty distinguished by an extra pointer
//              bit (wrap-bit technique) rather than depending on write_enable.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module sync_fifo #(
  parameter DEPTH      = 8,
  parameter DATA_WIDTH = 8
) (
  input  wire                  clk_i,
  input  wire                  rst_n_i,
  input  wire [DATA_WIDTH-1:0] data_i,
  input  wire                  read_enable_i,
  input  wire                  write_enable_i,
  output wire [DATA_WIDTH-1:0] data_o,
  output wire                  full_o,
  output wire                  empty_o
);

  // Internal address width derived from DEPTH
  localparam LOG2_DEPTH = ($clog2(DEPTH) > 0) ? $clog2(DEPTH) : 1;
  // Extra bit to distinguish full from empty when pointers are otherwise equal
  localparam PTR_WIDTH = LOG2_DEPTH + 1;

  // Read/write pointers (registered)
  reg [PTR_WIDTH-1:0] read_ptr_q;
  reg [PTR_WIDTH-1:0] write_ptr_q;
  // Read/write pointers (next-state, combinational)
  reg [PTR_WIDTH-1:0] read_ptr_d;
  reg [PTR_WIDTH-1:0] write_ptr_d;

  // Registered read data output
  reg [DATA_WIDTH-1:0] data_out_q;

  // Full/empty flags (registered)
  reg  full_q;
  reg  empty_q;
  // Full/empty flags (next-state, combinational)
  wire full_d;
  wire empty_d;

  // Memory array
  reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  // Combinational: pointer increment and status flag generation
  always @(*) begin
    // Default: hold current values
    write_ptr_d = write_ptr_q;
    read_ptr_d  = read_ptr_q;

    // Increment write pointer when writing and FIFO is not full
    if (write_enable_i && !full_q) begin
      write_ptr_d = write_ptr_q + 1;
    end

    // Increment read pointer when reading and FIFO is not empty
    if (read_enable_i && !empty_q) begin
      read_ptr_d = read_ptr_q + 1;
    end
  end

  // Full when write pointer's wrap-bit differs from read pointer's
  // (all lower bits equal — write has caught up to read)
  assign full_d  = (write_ptr_d[PTR_WIDTH-1] != read_ptr_d[PTR_WIDTH-1]) &&
                   (write_ptr_d[PTR_WIDTH-2:0] == read_ptr_d[PTR_WIDTH-2:0]);

  // Empty when all pointer bits (including wrap) are equal
  assign empty_d = (write_ptr_d == read_ptr_d);

  // Sequential: update pointers and flags on clock edge
  always @(posedge clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
      full_q      <= 1'b0;
      empty_q     <= 1'b1;
      write_ptr_q <= 0;
      read_ptr_q  <= 0;
    end else begin
      write_ptr_q <= write_ptr_d;
      read_ptr_q  <= read_ptr_d;
      full_q      <= full_d;
      empty_q     <= empty_d;
    end
  end

  // Memory write: occurs on rising clock when write is enabled and FIFO not full
  always @(posedge clk_i) begin
    if (write_enable_i && !full_q) begin
      mem[write_ptr_q[LOG2_DEPTH-1:0]] <= data_i;
    end
  end

  // Memory read: registered output, updates when read is enabled and FIFO not empty
  always @(posedge clk_i) begin
    if (read_enable_i && !empty_q) begin
      data_out_q <= mem[read_ptr_q[LOG2_DEPTH-1:0]];
    end
  end

  // Output assignments
  assign data_o = data_out_q;
  assign full_o = full_q;
  assign empty_o = empty_q;

endmodule
