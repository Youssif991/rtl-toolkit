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
  localparam left  = 0;
  localparam right = 1;

  // DUT interface
  reg d;                    // Serial data input
  reg rstn;                 // Active-low asynchronous reset
  reg dir;                  // Shift direction (left=0, right=1)
  reg clk;                  // Clock
  reg en;                   // Enable
  wire [N - 1 : 0] out;     // Parallel output

  // Test infrastructure
  integer i;                     // Loop counter
  integer errors = 0;            // Mismatch counter
  reg [N - 1 : 0] expected_out;  // Golden reference output

  // Module instantiation
  shift_reg #(
      .N(N)
  ) dut (
      .d   (d),
      .rstn(rstn),
      .dir (dir),
      .clk (clk),
      .en  (en),
      .out (out)
  );

  // Golden reference
  // Models a serial-in, parallel-out shift register. When `en` is high,
  // shifts `expected_out` one position per clock cycle in the direction
  // specified by `dir`, and loads `d` into the vacated bit position.
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

  // Checker — compare at negedge, after posedge capture has settled
  always @(negedge clk) begin : check
    if (rstn && (out !== expected_out)) begin
      errors = errors + 1;
      $display("FAIL at time %0t: dir=%b en=%b d=%b | dut_out=%b expected_out=%b",
               $time, dir, en, d, out, expected_out);
    end
  end

  // Clock generation: free-running 20 ns period (50 MHz)
  initial begin : clock
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Test procedure
  initial begin : test
    // Drive all inputs low and assert reset
    rstn = 0;
    en   = 0;
    dir  = left;
    d    = 0;

    #12 rstn = 1;  // release the reset

    // --- Directed test 1: shift left pattern (1 0 1 1) ---
    dir = left;
    en  = 1;
    @(negedge clk); d = 1;
    @(negedge clk); d = 1;
    @(negedge clk); d = 0;
    @(negedge clk); d = 1;

    // --- Hold: disable enable, data should not shift ---
    en = 0;
    @(negedge clk); d = 1;
    @(negedge clk); d = 0;

    // --- Directed test 2: shift right pattern (1 1 0 1) ---
    en  = 1;
    dir = right;
    @(negedge clk); d = 1;
    @(negedge clk); d = 1;
    @(negedge clk); d = 0;
    @(negedge clk); d = 1;

    // --- Random stimulus ---
    // Stress-test the shift register with 20 random control values.
    for (i = 0; i < 20; i = i + 1) begin
      @(negedge clk);
      d   = $random;
      en  = $random;
      dir = $random;
    end

    // Allow last transaction to settle, then report
    #20;

    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);

    $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin : monitor
    $monitor("Time=%0t | rstn=%b en=%b dir=%b d=%b | dut_out=%b expected_out=%b",
             $time, rstn, en, dir, d, out, expected_out);
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_shift_reg.vcd");
    $dumpvars(0, tb_shift_reg);
  end

endmodule
