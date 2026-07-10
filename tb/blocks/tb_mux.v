`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/29/2026 04:18:45 PM
// Design Name: Indexed Multiplexer Testbench
// Module Name: tb_mux
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `mux` module. Uses a
//              golden reference model (in[s]) and a self-checker to
//              verify correctness across all input/select combinations.
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

  // Test infrastructure
  integer i;                           // Loop counter
  reg expected_out;                    // Golden reference output
  integer errors = 0;                  // Mismatch counter

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
  // The golden reference (expected_out = in[s]) and self-checker run
  // inline within this loop for each test vector.
  initial begin : test
    // Initialize inputs
    in = 0;
    s  = 0;

    for (i = 0; i < (1 << (width + selection)); i = i + 1) begin
      {in, s} = i;
      #10;

      // Golden reference: out = in[s]
      expected_out = in[s];

      // Self-check
      if (out !== expected_out) begin
        errors = errors + 1;
        $display("FAIL at time %0t: in=%b s=%b | dut=%b expected=%b", $time, in, s, out, expected_out);
      end
    end

    #10;

    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);

    $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin : monitor
    $monitor("Time=%0t | in=%b s=%b | dut_out=%b expected=%b", $time, in, s, out, expected_out);
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_mux.vcd");
    $dumpvars(0, tb_mux);
  end

endmodule
