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
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_mux_bus;

  // Define the parameters for the mux_bus module
  localparam bus = 4;
  localparam inputs = 4;
  localparam selection = $clog2(inputs);

  // Define the signals for the testbench
  reg     [bus*inputs-1:0] in;
  reg     [ selection-1:0] s;
  wire    [       bus-1:0] out;

  integer                  pattern;  // one 4-bit pattern to test per iteration (0-15)
  integer                  sel_value;  // which input bus to select (0-3)
  integer                  errors = 0;

  // Instantiate the mux_bus module
  mux_bus #(
      .bus(bus),
      .inputs(inputs),
      .selection(selection)
  ) uut (
      .in (in),
      .s  (s),
      .out(out)
  );

  // Testbench procedure
  initial begin : testbench
    in = 0;
    s  = 0;

    $monitor("Time: %0t | Selection: %b | Input: %b | Output: %b", $time, s, in, out);

    // Test patterns for each input bus
    for (pattern = 0; pattern < 16; pattern = pattern + 1) begin : test_pattern
      in = {4{pattern[3:0]}};  // same 4-bit pattern in all 4 slots

      for (sel_value = 0; sel_value < inputs; sel_value = sel_value + 1) begin
        s = sel_value;
        #10;

        // self-check: out should always equal the selected 4-bit pattern
        if (out !== pattern[3:0]) begin   : mismatch
          errors = errors + 1;
          $display("FAIL at time %0t: s=%0d pattern=%0d | out=%b expected=%b", $time, sel_value,
                   pattern, out, pattern[3:0]);
        end
      end
    end

    #10;

    if (errors == 0) begin : pass
      $display("TEST PASSED — all checks matched");
    end else begin : fail
      $display("TEST FAILED — %0d mismatches found", errors);
    end

    $finish;
  end

endmodule
