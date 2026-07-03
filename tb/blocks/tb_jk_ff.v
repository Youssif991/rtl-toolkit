`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/03/2026 17:14:08
// Design Name: 
// Module Name: tb_jk_ff
// Tool Versions: Vivado 2025.2
// Description: Testbench for JK flip-flop module where each input combination is tested and compared against a reference model. Random stimulus is also applied to stress test the design.
// The inputs are fed in the negative edge of the clock to ensure that the outputs are stable and can be compared against the reference model. The testbench reports any mismatches found during simulation.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_jk_ff;


  // Inputs
  reg j;
  reg k;
  reg clk;
  reg rstn;


  // Outputs
  wire q;
  wire q_bar;

  // Reference model variables
  reg expected_q;  // Reference model output for comparison
  integer errors = 0;  // Counter for mismatches between DUT and reference model

  // Loop variable for random stimulus generation
  integer i;

  jk_ff dut (  // instantiate the DUT (Design Under Test)
      .j(j),
      .k(k),
      .clk(clk),
      .rstn(rstn),
      .q(q),
      .q_bar(q_bar)
  );

  // Clock
  initial begin : clk_gen
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reference model — golden behavior
  always @(posedge clk or negedge rstn) begin : ref_model
    if (!rstn) expected_q <= 0;
    else begin
      case ({
        j, k
      })
        2'b00: expected_q <= expected_q;
        2'b01: expected_q <= 0;
        2'b10: expected_q <= 1;
        2'b11: expected_q <= ~expected_q;
      endcase
    end
  end

  always @(negedge clk) begin : check_model  // check at negedge, after posedge settled
    if (rstn && (q !== expected_q)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: j=%b k=%b | dut_q=%b expected_q=%b", $time, j, k, q, expected_q);
    end
  end

  // Stimulus — directed tests first
  initial begin : stimulus
    j = 0;
    k = 0;
    rstn = 0;
    #10 rstn = 1;

    @(negedge clk);
    j = 0;
    k = 0;  // hold
    @(negedge clk);
    j = 0;
    k = 1;  // reset
    @(negedge clk);
    j = 1;
    k = 0;  // set
    @(negedge clk);
    j = 1;
    k = 1;  // toggle
    @(negedge clk);  // toggle again

    // Random stimulus — stress test
    for (i = 0; i < 20; i = i + 1) begin : random_stimulus
      @(negedge clk);
      j = $random;
      k = $random;
    end

    #20;

    // Final report
    if (errors == 0) begin : report_pass
      $display(" TEST PASSED — all checks matched");
    end else begin : report_fail
      $display(" TEST FAILED — %0d mismatches found", errors);
    end

    $finish;
  end

  // Live monitor 
  initial begin : live_monitor
    $monitor("Time=%0t | rstn=%b j=%b k=%b | dut_q=%b expected_q=%b", $time, rstn, j, k, q,
             expected_q);
  end

endmodule
