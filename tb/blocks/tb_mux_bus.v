`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/01/2026 20:06:08
// Design Name: Bus Multiplexer Testbench
// Module Name: tb_mux_bus
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for `mux_bus`. Iterates patterns
//              and selection values, verifying that `out` matches the
//              selected sub-bus. Reports mismatches.
// 
// Dependencies: mux_bus (src/blocks/mux_bus.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_mux_bus;

  // Parameters
  localparam bus = 4;
  localparam inputs = 4;
  localparam selection = $clog2(inputs);

  // DUT interface
  reg     [bus * inputs - 1 : 0] in;  // Concatenated input buses
  reg     [selection - 1 : 0] s;       // Bus select
  wire    [bus - 1 : 0] out;           // Selected bus output

  // Test infrastructure
  integer pattern;    // 4-bit pattern to test per iteration
  integer sel_value;  // Which input bus to select
  integer errors = 0; // Mismatch counter

  // Module instantiation
  mux_bus #(
      .bus(bus),
      .inputs(inputs),
      .selection(selection)
  ) uut (
      .in (in),
      .s  (s),
      .out(out)
  );

  // Test procedure: iterate patterns and selection values
  initial begin : test
    in = 0;
    s  = 0;

    $monitor("Time: %0t | Selection: %b | Input: %b | Output: %b", $time, s, in, out);

    for (pattern = 0; pattern < 16; pattern = pattern + 1) begin
      in = {4{pattern[3:0]}};  // same 4-bit pattern in all 4 slots

      for (sel_value = 0; sel_value < inputs; sel_value = sel_value + 1) begin
        s = sel_value;
        #10;

        // Self-check: out should always equal the selected 4-bit pattern
        if (out !== pattern[3:0]) begin
          errors = errors + 1;
          $display("FAIL at time %0t: s=%0d pattern=%0d | out=%b expected=%b",
                   $time, sel_value, pattern, out, pattern[3:0]);
        end
      end
    end

    #10;

    if (errors == 0) $display("TEST PASSED — all checks matched");
    else $display("TEST FAILED — %0d mismatches found", errors);

    $finish;
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_mux_bus.vcd");
    $dumpvars(0, tb_mux_bus);
  end

endmodule
