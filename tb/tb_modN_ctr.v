`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/04/2026 02:33:38
// Design Name: Mod-N Counter Testbench
// Module Name: tb_modN_ctr
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for `modN_ctr` using a golden
//              reference model to verify counting behavior including
//              wraparound and reset behavior.
//
// Dependencies: modN_ctr (src/blocks/modN_ctr.v)
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

    // DUT interface
    reg                     clk;  // Clock
    reg                     rstn;  // Active-low asynchronous reset
    wire    [WIDTH - 1 : 0] count;  // Counter output

    // Test infrastructure
    reg     [WIDTH - 1 : 0] expected_count;  // Golden reference output
    integer                 errors = 0;  // Mismatch counter

    // Module instantiation
    modN_ctr #(
        .N(N),
        .WIDTH(WIDTH)
    ) dut (
        .clk  (clk),
        .rstn (rstn),
        .count(count)
    );

    // Clock generation: free-running 20 ns period (50 MHz)
    initial begin : clock
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Golden reference — mirrors the expected mod-N counting behavior
    always @(posedge clk or negedge rstn) begin : reference
        if (!rstn) expected_count <= 0;
        else if (expected_count == N - 1) expected_count <= 0;
        else expected_count <= expected_count + 1;
    end

    // Checker — compares DUT against reference on negedge
    always @(negedge clk) begin : check
        if (rstn && (count !== expected_count)) begin
            errors = errors + 1;
            $display("FAIL at time %0t: dut_count=%0d expected_count=%0d", $time, count,
                     expected_count);
        end
    end

    // Test procedure
    initial begin : test
        // Assert reset, then release mid-cycle
        rstn = 0;

        #15 rstn = 1;  // release reset mid-cycle

        // Run long enough to see multiple full wraparounds
        repeat (N * 3) @(posedge clk);

        // Allow last transaction to settle, then report
        #20;

        if (errors == 0) $display(" TEST PASSED — all checks matched");
        else $display(" TEST FAILED — %0d mismatches found", errors);

        $finish;
    end

    // Live monitor: prints signal values on every change
    initial begin : monitor
        $monitor("Time=%0t | rstn=%b | dut_count=%0d expected_count=%0d", $time, rstn, count,
                 expected_count);
    end

    // VCD dump for waveform debugging
    initial begin
        $dumpfile("tb_modN_ctr.vcd");
        $dumpvars(0, tb_modN_ctr);
    end

endmodule
