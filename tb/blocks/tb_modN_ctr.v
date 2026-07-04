`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/04/2026 02:33:38
// Design Name: 
// Module Name: tb_modN_ctr
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

module tb_modN_ctr;

  // Parameters
  localparam N = 10;  // Modulus of the counter
  localparam WIDTH = $clog2(N);  // Width of the counter based on N

  // Inputs
  reg clk;
  reg rstn;

  // Outputs
  wire [WIDTH-1:0] count;

  // Instantiate the modN_ctr module
  modN_ctr #(
      .N(N),
      .WIDTH(WIDTH)
  ) dut (
      .clk  (clk),
      .rstn (rstn),
      .count(count)
  );

  // Clock generation
  always begin : Clock_Generation
    #10 clk = ~clk;  // 10ns clock period
  end

  // Testbench procedure
  initial begin : Testbench_Procedure
    // Initialize inputs
    rstn = 0;
    clk = 0;

    // Apply reset

    #10 rstn = 1;  // Release reset after 10ns

    #450 $finish;  // End simulation after 450ns
  end

  initial begin : Monitor_Outputs
    $monitor("Time=%0t | rstn=%b out=%0d", $time, rstn, count);
  end

endmodule
