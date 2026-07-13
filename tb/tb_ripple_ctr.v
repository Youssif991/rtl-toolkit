`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/05/2026 15:20:29
// Design Name: Ripple counter test bench
// Module Name: tb_ripple_ctr
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `ripple_ctr` module. Uses a
//              golden reference model (binary up-counter) compared against
//              the DUT on negedge clk. Covers reset and multiple full-range
//              counting cycles.
//
// Dependencies: ripple_ctr (src/blocks/ripple_ctr.v)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_ripple_ctr;

    // Parameters
    localparam N = 4;

    // DUT interface
    reg                 clk;  // Clock
    reg                 rstn;  // Active-low asynchronous reset
    wire    [N - 1 : 0] out;  // Counter output

    // Test infrastructure
    integer             errors = 0;  // Mismatch counter
    reg     [N - 1 : 0] expected_out;  // Golden reference output

    // Module instantiation
    ripple_ctr #(
        .N(N)
    ) dut (
        .clk (clk),
        .rstn(rstn),
        .out (out)
    );

    // Golden reference
    // Models a simple binary up-counter: increments on each posedge,
    // clears to 0 on async reset.
    always @(posedge clk or negedge rstn) begin : reference
        if (!rstn) expected_out <= 0;
        else expected_out <= expected_out + 1;
    end

    // Checker — compare at negedge, after posedge capture has settled
    always @(negedge clk) begin : check
        if (rstn && (out !== expected_out)) begin
            errors = errors + 1;
            $display("FAIL at time %0t : dut_out=%b expected_out=%b", $time, out, expected_out);
        end
    end

    // Clock generation: free-running 20 ns period (50 MHz)
    initial begin : clock
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test procedure
    initial begin : test
        // Assert reset, then release mid-cycle
        rstn = 0;

        #12 rstn = 1;  // release the reset

        // Run long enough to observe multiple full-range counting cycles
        repeat ((1 << N) * 3) @(posedge clk);

        // Allow last transaction to settle, then report
        #20;

        if (errors == 0) $display(" TEST PASSED — all checks matched");
        else $display(" TEST FAILED — %0d mismatches found", errors);

        $finish;
    end

    // Live monitor: prints signal values on every change
    initial begin : monitor
        $monitor("Time=%0t | rstn=%b | dut_out=%b | expected_out=%b", $time, rstn, out,
                 expected_out);
    end

    // VCD dump for waveform debugging
    initial begin
        $dumpfile("tb_ripple_ctr.vcd");
        $dumpvars(0, tb_ripple_ctr);
    end

endmodule
