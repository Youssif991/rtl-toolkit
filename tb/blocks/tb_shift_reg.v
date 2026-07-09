`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/08/2026 23:21:44
// Design Name: Shift Register testbench
// Module Name: tb_shift_reg
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `shift_reg` module. Uses a
//              golden reference model (software shift-left/right) compared
//              against the DUT on negedge clk. Covers directed left/right
//              shift patterns, hold (en=0), and randomized stimulus.
// 
// Dependencies: shift_reg (src/blocks/shift_reg.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_shift_reg;

  // Parameters
  localparam N = 4;
  localparam left = 0;
  localparam right = 1;

  // Inputs
  reg d;
  reg rstn;
  reg dir;
  reg clk;
  reg en;

  // Outputs
  wire [N - 1 : 0] out;

  // Test Variables
  integer i;
  integer errors = 0;
  reg [N - 1 : 0] expected_out;

  // Module instantation
  shift_reg #(
      .N(N)
  ) dut (
      .d(d),
      .rstn(rstn),
      .dir(dir),
      .clk(clk),
      .en(en),
      .out(out)
  );

  // Test procedure
  always @(posedge clk or negedge rstn) begin : reference
    if (!rstn) expected_out <= 0;
    else begin
      if (en) begin
        case (dir)

          right: begin
            expected_out <= expected_out >> 1;
            expected_out[N-1] <= d;
          end

          left: begin
            expected_out <= expected_out << 1;
            expected_out[0] <= d;
          end
          default: expected_out <= expected_out;
        endcase
      end
    end
  end

  // Checker — negedge, after the posedge capture has settled
  always @(negedge clk) begin : Checker
    if (rstn && (out !== expected_out)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: dir=%b en=%b d=%b | dut_out=%b expected_out=%b", $time, dir, en,
               d, out, expected_out);
    end
  end

  // Clock generation
  initial begin : clock
    clk = 0;
    forever #10 clk = ~clk;  // 20 ns period clock
  end

  // Test procedure
  initial begin : test
    // initalize inputs
    rstn = 0;
    en = 0;
    dir = left;
    d = 0;

    #12 rstn = 1;  // relase the reset

    dir = left;
    en  = 1;
    // Test a known pattern in shift left case (1 0 1 1)
    @(negedge clk);
    d = 1;
    @(negedge clk);
    d = 1;
    @(negedge clk);
    d = 0;
    @(negedge clk);
    d  = 1;

    // Hold by disabling the enable
    en = 0;
    @(negedge clk);
    d = 1;
    @(negedge clk);
    d   = 0;

    // Test a known pattern in shift right case (1 1 0 1)
    en  = 1;
    dir = right;
    @(negedge clk);
    d = 1;
    @(negedge clk);
    d = 1;
    @(negedge clk);
    d = 0;
    @(negedge clk);
    d = 1;

    // Applying random tests
    for (i = 0; i < 20; i = i + 1) begin : random_tests
      @(negedge clk);
      d   = $random;
      en  = $random;
      dir = $random;
    end

    #20;

    if (errors == 0) begin : report_pass
      $display(" TEST PASSED — all checks matched");
    end else begin : report_fail
      $display(" TEST FAILED — %0d mismatches found", errors);
    end

    $finish;

  end

  // Live monitor 
  initial begin : live_monitor
    $monitor("Time=%0t | rstn=%b en=%b dir=%b d=%b | dut_out=%b expected_out=%b", $time, rstn, en,
             dir, d, out, expected_out);
  end

  // Vcd dump
  initial begin
    $dumpfile("tb_shift_reg.vcd");
    $dumpvars(0, tb_shift_reg);
  end


endmodule
