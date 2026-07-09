`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/29/2026 04:18:45 PM
// Design Name: Indexed Multiplexer Testbench
// Module Name: tb_mux
// Tool Versions: Vivado 2025.2
// Description: Exhaustively tests the `mux` module by iterating input
//              vectors and selection indices, monitoring `out` for each.
// 
// Dependencies: mux (src/blocks/mux.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_mux;

  // Parameters
  localparam width = 4;
  localparam selection = $clog2(width);

  // DUT interface
  reg [width - 1 : 0] in;             // Input vector
  reg [selection - 1 : 0] s;          // Select index
  wire out;                            // Output: in[s]
  integer i;                           // Loop counter

  // Module instantiation
  mux #(
      .width(width),
      .selection(selection)
  ) dut (
      .in (in),
      .s  (s),
      .out(out)
  );

  // Test procedure: exhaustively iterate all (in, s) combinations
  initial begin : test
    in = 0;
    s  = 0;

    $monitor("in=%0b s=%0b out=%0b", in, s, out);

    for (i = 0; i < (1 << (width + selection)); i = i + 1) begin
      {in, s} = i;
      #10;
    end

    $finish;
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_mux.vcd");
    $dumpvars(0, tb_mux);
  end

endmodule
