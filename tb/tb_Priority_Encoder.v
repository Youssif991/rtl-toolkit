`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 07/01/2026 23:09:05
// Design Name: Priority Encoder Testbench
// Module Name: tb_Priority_Encoder
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `Priority_Encoder` module.
//              Uses a golden reference model that mirrors the scan-and-pick
//              priority logic. Covers empty, single-channel, multi-channel
//              priority, and random stimulus cases.
//
// Dependencies: Priority_Encoder (src/blocks/Priority_Encoder.v)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_Priority_Encoder;

    // Parameters
    localparam inputs = 4;
    localparam bus = 8;

    // DUT interface
    reg     [inputs * bus - 1 : 0] in;  // Concatenated input buses
    wire    [         bus - 1 : 0] out;  // Selected output bus

    // Test infrastructure
    integer                        i;  // Loop counter
    reg     [         bus - 1 : 0] expected_out;  // Golden reference output
    integer                        errors = 0;  // Mismatch counter

    // Module instantiation
    Priority_Encoder #(
        .inputs(inputs),
        .bus(bus)
    ) dut (
        .in (in),
        .out(out)
    );

    // Golden reference: scan input buses and pick the last non-zero one
    // Mirrors the DUT's priority encoding logic for independent comparison.
    always @(*) begin : reference
        expected_out = 0;
        for (i = 0; i < inputs; i = i + 1) begin
            if (in[i*bus+:bus] != 0) expected_out = in[i*bus+:bus];
        end
    end

    // Test procedure: directed cases + random stimulus
    initial begin : test
        // --- Directed test 1: all channels empty (output should be 0) ---
        in = 32'h00_00_00_00;
        #10;
        if (out !== expected_out) begin
            errors = errors + 1;
            $display("FAIL case 1");
        end

        // --- Directed test 2: only Channel 0 has data (output = 8'hAA) ---
        in = 32'h00_00_00_AA;
        #10;
        if (out !== expected_out) begin
            errors = errors + 1;
            $display("FAIL case 2");
        end

        // --- Directed test 3: only Channel 2 has data (output = 8'hBB) ---
        in = 32'h00_BB_00_00;
        #10;
        if (out !== expected_out) begin
            errors = errors + 1;
            $display("FAIL case 3");
        end

        // --- Directed test 4: Channel 1 and Channel 3 active (later wins) ---
        in = 32'hDD_00_CC_00;
        #10;
        if (out !== expected_out) begin
            errors = errors + 1;
            $display("FAIL case 4");
        end

        // --- Directed test 5: random data to check stability ---
        in = $random;
        #10;
        if (out !== expected_out) begin
            errors = errors + 1;
            $display("FAIL case 5");
        end

        // Allow last transaction to settle, then report
        #10;

        if (errors == 0) $display(" TEST PASSED — all checks matched");
        else $display(" TEST FAILED — %0d mismatches found", errors);

        $finish;
    end

    // Live monitor: prints signal values on every change
    initial begin : monitor
        $monitor("Time=%0t | in=%h | dut_out=%h expected_out=%h", $time, in, out, expected_out);
    end

    // VCD dump for waveform debugging
    initial begin
        $dumpfile("tb_Priority_Encoder.vcd");
        $dumpvars(0, tb_Priority_Encoder);
    end

endmodule
