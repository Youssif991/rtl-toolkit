`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/26/2026 02:57:03 AM
// Design Name: 2-to-1 Multiplexer Testbench
// Module Name: tb_mux_2x1
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `mux_2x1` module. Uses a
//              golden reference model (S ? D1 : D0) compared against the
//              DUT on every input change. Enumerates all combinations.
//
// Dependencies: mux_2x1 (src/blocks/mux_2x1.v)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_mux_2x1;

    // DUT interface
    reg     D0;  // Input 0
    reg     D1;  // Input 1
    reg     S;  // Select
    wire    Y;  // Output: S ? D1 : D0

    // Test infrastructure
    reg     expected_Y;  // Golden reference output
    integer errors = 0;  // Mismatch counter

    // Module instantiation
    mux_2x1 dut (
        .D0_i(D0),
        .D1_i(D1),
        .S_i (S),
        .Y_o (Y)
    );

    // Golden reference
    // Computes the expected output as Y = S ? D1 : D0.
    always @(*) begin : reference
        expected_Y = S ? D1 : D0;
    end

    // Checker — compare after combo logic settles
    always @(*) begin : check
        #1;
        if (Y !== expected_Y) begin
            errors = errors + 1;
            $display("FAIL at time %0t: D0=%b D1=%b S=%b | dut=%b expected=%b", $time, D0, D1, S,
                     Y, expected_Y);
        end
    end

    // Test procedure: enumerate all 8 input combinations
    initial begin : test
        D0 = 0;
        D1 = 0;
        S  = 0;
        #10;
        D0 = 0;
        D1 = 0;
        S  = 1;
        #10;
        D0 = 0;
        D1 = 1;
        S  = 0;
        #10;
        D0 = 0;
        D1 = 1;
        S  = 1;
        #10;
        D0 = 1;
        D1 = 0;
        S  = 0;
        #10;
        D0 = 1;
        D1 = 0;
        S  = 1;
        #10;
        D0 = 1;
        D1 = 1;
        S  = 0;
        #10;
        D0 = 1;
        D1 = 1;
        S  = 1;
        #10;

        #10;

        if (errors == 0) $display(" TEST PASSED — all checks matched");
        else $display(" TEST FAILED — %0d mismatches found", errors);

        $finish;
    end

    // Live monitor: prints signal values on every change
    initial begin : monitor
        $monitor("Time=%0t | D0=%b D1=%b S=%b | dut_out=%b expected=%b", $time, D0, D1, S, Y,
                 expected_Y);
    end

    // VCD dump for waveform debugging
    initial begin
        $dumpfile("tb_mux_2x1.vcd");
        $dumpvars(0, tb_mux_2x1);
    end

endmodule
