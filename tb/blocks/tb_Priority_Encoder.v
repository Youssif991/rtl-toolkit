`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/01/2026 23:09:05
// Design Name: 
// Module Name: tb_Priority_Encoder
// Tool Versions: Vivado 2025.2
// Description: Insert description here
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_Priority_Encoder;

  // Paramters
  localparam inputs = 4;
  localparam bus = 8;

  // Inputs
  reg [inputs * bus - 1 : 0] in;

  // Output
  wire [bus - 1 : 0] out;

  integer i;  // Loop variable
  // Instantiate the Design Under Test (DUT)
  Priority_Encoder #(
      .inputs(inputs),
      .bus(bus)
  ) dut (
      .in (in),
      .out(out)
  );

  initial begin

    $monitor("Time: %0t | Input Vector: %h | Selected Output: %h", $time, in, out);
    
    // Case 1: All channels are completely empty (Output should be 0)
    in = 32'h00_00_00_00;
    #10;

    // Case 2: Only Channel 0 has data (Output should be 8'hAA)
    in = 32'h00_00_00_AA;
    #10;

    // Case 3: Only Channel 2 has data (Output should be 8'hBB)
    in = 32'h00_BB_00_00;
    #10;

    // Case 4: PRIORITY TEST! Both Channel 1 and Channel 3 are active.
    in = 32'hDD_00_CC_00;
    #10;

    // Case 5: Fill everything with random data to check stability
    in = $random;
    #10;

    $finish;

  end

endmodule
