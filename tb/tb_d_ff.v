`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/05/2026 13:43:55
// Design Name: D FlipFlop Test Bench
// Module Name: tb_d_ff
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `d_ff` module. Uses a golden
//              reference model (posedge-triggered D flip-flop with async reset)
//              compared against the DUT on negedge clk. Covers directed reset/
//              capture cases plus randomized stimulus.
//
// Dependencies: d_ff (src/blocks/d_ff.v)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_d_ff;

    // DUT interface
    reg     d;  // Data input
    reg     clk;  // Clock
    reg     rstn;  // Active-low asynchronous reset
    wire    q;  // Output
    wire    q_bar;  // Complementary output

    // Test infrastructure
    integer i;  // Loop counter
    integer errors = 0;  // Mismatch counter
    reg     expected_q;  // Golden reference output

    // Module instantiation
    d_ff dut (
        .d   (d),
        .clk (clk),
        .rstn(rstn),
        .q   (q),
        .q_bar(q_bar)
    );

    // Clock generation: free-running 20 ns period (50 MHz)
    initial begin : clock
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Golden reference
    // On rising clock edge, captures `d` into `expected_q`; on negated
    // reset, clears the output. Mirrors the DUT's behavior exactly.
    always @(posedge clk or negedge rstn) begin : reference
        if (!rstn) expected_q <= 1'b0;
        else expected_q <= d;
    end

    // Checker — compare at negedge, after posedge capture has settled
    always @(negedge clk) begin : check
        if (rstn && (q !== expected_q)) begin
            errors = errors + 1;
            $display("FAIL at time %0t: d=%b | dut_q=%b expected_q=%b", $time, d, q, expected_q);
        end
    end

    // Test procedure
    initial begin : test
        // Drive all inputs low and assert reset
        d    = 0;
        rstn = 0;

        @(negedge clk);
        d = 1;  // input should not propagate while reset is active

        // --- Directed test 1: release reset, capture 0 then 1 ---
        @(negedge clk);
        rstn = 1;  // release the reset

        @(negedge clk);
        d = 0;  // capture 0

        @(negedge clk);
        d = 1;  // capture 1

        // --- Random stimulus ---
        // Stress-test the flip-flop with 20 random data values.
        for (i = 0; i < 20; i = i + 1) begin
            @(negedge clk);
            d = $random;
        end

        // Allow last transaction to settle, then report
        #20;

        if (errors == 0) $display(" TEST PASSED — all checks matched");
        else $display(" TEST FAILED — %0d mismatches found", errors);

        $finish;
    end

    // Live monitor: prints signal values on every change
    initial begin : monitor
        $monitor("Time=%0t | rstn=%b d=%b | dut_q=%b expected_q=%b", $time, rstn, d, q, expected_q);
    end

    // VCD dump for waveform debugging
    initial begin
        $dumpfile("tb_d_ff.vcd");
        $dumpvars(0, tb_d_ff);
    end

endmodule
