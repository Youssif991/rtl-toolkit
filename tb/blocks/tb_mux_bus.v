`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/01/2026 20:06:08
// Design Name: 
// Module Name: tb_mux_bus
// Tool Versions: Vivado 2025.2
// Description:
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
  reg [bus*inputs - 1:0] in;
  reg [selection - 1:0] s;
  wire [bus - 1:0] out;
  integer input_value;
  integer sel_value;
  integer total_input_values;

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
  initial begin
    // Initialize inputs
    in = 0;
    s  = 0;

    total_input_values = 1 << (bus * inputs);

    $monitor("Time: %0t | Selection: %b | Input: %b | Output: %b", $time, s, in, out); // Monitor the signals

    // Apply test vectors for all possible input combinations and selection values
    for (input_value = 0; input_value < total_input_values; input_value = input_value + 1) begin
      in = input_value;
      for (sel_value = 0; sel_value < inputs; sel_value = sel_value + 1) begin
        s = sel_value;
        #10;  // Wait for 10 time units
      end
    end

    $finish;  // End simulation

  end

endmodule
