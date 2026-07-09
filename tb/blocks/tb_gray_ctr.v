`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/08/2026 19:37:00
// Design Name: Gray Counter test bench
// Module Name: tb_gray_ctr
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `gray_ctr` module. Verifies
//              that exactly one output bit changes per clock cycle (the
//              defining property of Gray-code counting) by comparing each
//              new value against the previous one.
// 
// Dependencies: gray_ctr (src/blocks/gray_ctr.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_gray_ctr;

  // Parameters
  localparam N = 4;

  // DUT interface
  reg clk;               // Clock
  reg rstn;              // Active-low asynchronous reset
  wire [N - 1 : 0] out;  // Gray-code output

  // Test infrastructure
  integer i;                      // Loop counter
  integer errors = 0;             // Mismatch counter
  integer diff_count;             // Number of bits that changed
  reg [N - 1 : 0] prev_out;       // Previous output value
  reg have_prev;                  // Whether a previous value exists

  // Module instantiation
  gray_ctr #(
      .N(N)
  ) dut (
      .clk (clk),
      .rstn(rstn),
      .out (out)
  );

  // Golden reference: verify exactly one bit changes per cycle
  always @(posedge clk or negedge rstn) begin : reference
    if (rstn) begin
      if (have_prev) begin
        diff_count = 0;
        for (i = 0; i < N - 1; i = i + 1) begin
          if (out[i] !== prev_out[i]) diff_count = diff_count + 1;

          if (diff_count != 1) begin
            errors = errors + 1;
            $display("FAIL at time %0t: expected exactly 1 bit to change, got %0d", $time,
                     diff_count);
          end

          prev_out  = out;
          have_prev = 1'b1;
        end
      end else begin
        have_prev = 1'b0;
      end
    end
  end

  // Clock generation: free-running 20 ns period (50 MHz)
  initial begin : clock
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Test procedure
  initial begin : test
    rstn = 0;

    #12 rstn = 1;  // release reset mid-cycle

    repeat ((1 << N) * 3) @(posedge clk);

    #20;

    if (errors == 0) $display(" TEST PASSED — all checks matched");
    else $display(" TEST FAILED — %0d mismatches found", errors);

    $finish;
  end

  // Live monitor: prints signal values on every change
  initial begin : monitor
    $monitor("Time=%0t | rstn=%b | dut_out=%b", $time, rstn, out);
  end

  // VCD dump for waveform debugging
  initial begin
    $dumpfile("tb_gray_ctr.vcd");
    $dumpvars(0, tb_gray_ctr);
  end

endmodule
