`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/05/2026 19:26:03
// Design Name: Johnson Counter Test Bench
// Module Name: tb_johnson_ctr
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `johnson_ctr` module. Verifies
//              that exactly one output bit changes per clock cycle (the
//              defining property of Johnson/twisted-ring counters) by comparing
//              each new value against the previous one.
// 
// Dependencies: johnson_ctr (src/blocks/johnson_ctr.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_johnson_ctr;

  // Parameters
  localparam N = 4;

  // DUT interface
  reg clk;               // Clock
  reg rstn;              // Active-low asynchronous reset
  wire [N - 1 : 0] out;  // Johnson counter output

  // Test infrastructure
  integer i;                      // Loop counter
  integer errors = 0;             // Mismatch counter
  integer diff_count;             // Number of bits that changed
  reg [N - 1 : 0] prev_out;       // Previous output value
  reg have_prev;                  // Whether a previous value exists

  // Module instantiation
  johnson_ctr #(
      .N(N)
  ) dut (
      .clk (clk),
      .rstn(rstn),
      .out (out)
  );

  // Golden reference: verify exactly one bit changes per cycle
  always @(posedge clk) begin : reference
    if (rstn) begin
      if (have_prev) begin
        diff_count = 0;
        for (i = 0; i < N; i = i + 1) begin
          if (out[i] !== prev_out[i]) diff_count = diff_count + 1;
        end

        if (diff_count != 1) begin
          errors = errors + 1;
          $display("FAIL at time %0t: expected exactly 1 bit to change, got %0d", $time,
                   diff_count);
        end
      end

      prev_out  = out;
      have_prev = 1'b1;

    end else begin
      have_prev = 1'b0;
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

    #12 rstn = 1;  // release the reset

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
    $dumpfile("tb_johnson_ctr.vcd");
    $dumpvars(0, tb_johnson_ctr);
  end

endmodule
