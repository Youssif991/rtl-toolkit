`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/05/2026 19:26:03
// Design Name: Johnson Counter Test Bench
// Module Name: tb_johnson_ctr
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

module tb_johnson_ctr;

  // Parameters
  localparam N = 4;

  // Inputs
  reg clk;
  reg rstn;

  // Outputs
  wire [N - 1 : 0] out;

  // Test variables
  integer i;
  integer errors = 0;
  integer diff_count;
  reg [N - 1 : 0] prev_out;
  reg have_prev;

  // Module instantation
  johnson_ctr #(
      .N(N)
  ) dut (
      .clk (clk),
      .rstn(rstn),
      .out (out)
  );

 // Golden reference
  always @(posedge clk) begin : Reference
    if (rstn) begin
      if (have_prev) begin
        diff_count = 0;
        for (i = 0; i < N; i = i + 1) begin
          if (out[i] !== prev_out[i]) diff_count = diff_count + 1;
        end

        if (diff_count != 1) begin
          errors = errors + 1;
          $display("FAIL at time %0t: expected exactly 1 bit to change, got %0d", $time, diff_count);
        end
      end

      prev_out  = out;     
      have_prev = 1'b1;    

    end else begin
      have_prev = 1'b0;   
    end
  end

  // Clock generation
  initial begin : Clock
    clk = 0;
    forever #10 clk = ~clk;  // 20 ns period clock
  end

  // Test procedure
  initial begin : Test

    // Initialize the inputs
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
    $monitor("Time=%0t | rstn=%b | dut_out=%b", $time, rstn, out);
  end

  // VCD dump
  initial begin
    $dumpfile("tb_johnson_ctr.vcd");
    $dumpvars(0, tb_johnson_ctr);
  end

endmodule
