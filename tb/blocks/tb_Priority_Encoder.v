`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/01/2026 23:09:05
// Design Name: Priority Encoder Testbench
// Module Name: tb_Priority_Encoder
// Tool Versions: Vivado 2025.2
// Description: Provides directed and random stimulus to the
//              `Priority_Encoder` to verify selection and priority
//              behavior under various input conditions.
// 
// Dependencies: Priority_Encoder (src/blocks/Priority_Encoder.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_Priority_Encoder;

  // Parameters
  localparam inputs = 4;
  localparam bus = 8;

  // DUT interface
  reg [inputs * bus - 1 : 0] in;  // Concatenated input buses
  wire [bus - 1 : 0] out;          // Selected output bus

  // Test infrastructure
  integer i;                       // Loop counter

  // Module instantiation
  Priority_Encoder #(
      .inputs(inputs),
      .bus(bus)
  ) dut (
      .in (in),
      .out(out)
  );

  // Test procedure: directed cases + random stimulus
  initial begin : test
    $monitor("Time: %0t | Input Vector: %h | Selected Output: %h", $time, in, out);

    // Case 1: All channels empty (output should be 0)
    in = 32'h00_00_00_00; #10;

    // Case 2: Only Channel 0 has data (output should be 8'hAA)
    in = 32'h00_00_00_AA; #10;

    // Case 3: Only Channel 2 has data (output should be 8'hBB)
    in = 32'h00_BB_00_00; #10;

    // Case 4: Both Channel 1 and Channel 3 active — later channel wins
    in = 32'hDD_00_CC_00; #10;

    // Case 5: Random data to check stability
    in = $random; #10;

    $finish;
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_Priority_Encoder.vcd");
    $dumpvars(0, tb_Priority_Encoder);
  end

endmodule
