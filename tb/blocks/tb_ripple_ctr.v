`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/05/2026 15:20:29
// Design Name: Ripple counter test bench
// Module Name: tb_ripple_ctr
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

module tb_ripple_ctr;

  // Parameters
  localparam N = 4;

  // Inputs
  reg clk;
  reg rstn;

  // Outputs
  wire [N - 1 : 0] out;

  // Test variables
  integer errors = 0;
  reg [N - 1 : 0] expected_out;

  // Module instantation
  ripple_ctr #(
      .N(N)
  ) dut (
      .clk (clk),
      .rstn(rstn),
      .out (out)
  );

  // Golden reference
  always @(posedge clk or negedge rstn) begin
    if (!rstn) expected_out <= 0;
    else expected_out <= expected_out + 1;
  end

  // Check the dut against the golden reference
  always @(negedge clk) begin : check_model  // check at negedge, after posedge settled
    if (rstn && (out !== expected_out)) begin
      errors = errors + 1;
      $display("FAIL at time %0t : dut_out=%b expected_out=%b", $time, out, expected_out);
    end
  end

  // Clock generation
  initial begin : Clock
    clk = 0;
    forever #10 clk = ~clk;  // 20 ns period clock
  end

  // Test procedure
  initial begin : Test

    // Initialize inputs
    rstn = 0;


    #12 rstn = 1;  // release the reset

    repeat ((1 << N) * 3) @(posedge clk);

    #20;

    if (errors == 0) begin : report_pass
      $display(" TEST PASSED — all checks matched");
    end else begin : report_fail
      $display(" TEST FAILED — %0d mismatches found", errors);
    end

    $finish;

  end

  // Monitoring the output
  initial begin : live_monitor
    $monitor("Time=%0t | rstn=%b | dut_out=%b | expected_out=%b", $time, rstn, out, expected_out);
  end

  // VCD dump
  initial begin
    $dumpfile("tb_ripple_ctr.vcd");
    $dumpvars(0, tb_ripple_ctr);
  end


endmodule
