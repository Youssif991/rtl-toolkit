`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/03/2026 17:14:08
// Design Name: JK Flip-Flop Testbench
// Module Name: tb_jk_ff
// Tool Versions: Vivado 2025.2
// Description: Testbench for `jk_ff` that verifies set/reset/hold/toggle
//              behaviors. Uses a golden reference model and directed plus
//              random stimulus; reports mismatches found during simulation.
// Dependencies: jk_ff (src/blocks/jk_ff.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_jk_ff;

  // DUT interface
  reg j;     // Set input
  reg k;     // Reset input
  reg clk;   // Clock
  reg rstn;  // Active-low asynchronous reset
  wire q;     // Output
  wire q_bar; // Complementary output

  // Test infrastructure
  reg expected_q;       // Golden reference output
  integer errors = 0;   // Mismatch counter
  integer i;            // Loop counter

  // Module instantiation
  jk_ff dut (
      .j(j),
      .k(k),
      .clk(clk),
      .rstn(rstn),
      .q(q),
      .q_bar(q_bar)
  );

  // Clock generation: free-running 10 ns period (100 MHz)
  initial begin : clock
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Golden reference
  always @(posedge clk or negedge rstn) begin : reference
    if (!rstn) expected_q <= 0;
    else begin
      case ({j, k})
        2'b00: expected_q <= expected_q;  // hold
        2'b01: expected_q <= 0;            // reset
        2'b10: expected_q <= 1;            // set
        2'b11: expected_q <= ~expected_q;   // toggle
      endcase
    end
  end

  // Checker — compare at negedge, after posedge capture has settled
  always @(negedge clk) begin : check
    if (rstn && (q !== expected_q)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: j=%b k=%b | dut_q=%b expected_q=%b", $time, j, k, q, expected_q);
    end
  end

  // Test procedure
  initial begin : test
    j = 0;
    k = 0;
    rstn = 0;
    #10 rstn = 1;

    @(negedge clk);
    j = 0; k = 0;  // hold
    @(negedge clk);
    j = 0; k = 1;  // reset
    @(negedge clk);
    j = 1; k = 0;  // set
    @(negedge clk);
    j = 1; k = 1;  // toggle
    @(negedge clk);
                     // toggle again

    // Random stimulus — stress test
    for (i = 0; i < 20; i = i + 1) begin
      @(negedge clk);
      j = $random;
      k = $random;
    end

    #20;

    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);

    $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin : monitor
    $monitor("Time=%0t | rstn=%b j=%b k=%b | dut_q=%b expected_q=%b",
             $time, rstn, j, k, q, expected_q);
  end

endmodule
