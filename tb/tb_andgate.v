`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 06/26/2026 02:13:34 AM
// Design Name: AND Gate Testbench
// Module Name: tb_andgate
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `andgate` module. Uses a
//              golden reference model (A & B) compared against the DUT on
//              every input change. Enumerates all input combinations.
//
// Dependencies: andgate (src/gates/andgate.v)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_andgate;

    // DUT interface
    reg     A;  // Input A
    reg     B;  // Input B
    wire    C;  // Output: A & B

    // Test infrastructure
    reg     expected_C;  // Golden reference output
    integer errors = 0;  // Mismatch counter

    // Module instantiation
    andgate dut (
        .A_i(A),
        .B_i(B),
        .C_o(C)
    );

    // Golden reference: compute the expected AND output
    always @(*) begin : reference
        expected_C = A & B;
    end

    // Checker
    always @(*) begin : check
        #1;
        if (C !== expected_C) begin
            errors = errors + 1;
            $display("FAIL at time %0t: A=%b B=%b | dut=%b expected=%b", $time, A, B, C,
                     expected_C);
        end
    end

    // Test procedure: enumerate all input combinations
    initial begin : test
        A = 0;
        B = 0;
        #10;
        A = 0;
        B = 1;
        #10;
        A = 1;
        B = 0;
        #10;
        A = 1;
        B = 1;
        #10;
        #10;
        if (errors == 0) $display(" TEST PASSED — all checks matched");
        else $display(" TEST FAILED — %0d mismatches found", errors);
        $finish;
    end

    // Live monitor: prints signal values on every change
    initial begin : monitor
        $monitor("Time=%0t | A=%b B=%b | dut_out=%b expected=%b", $time, A, B, C, expected_C);
    end

    // VCD dump for waveform debugging
    initial begin
        $dumpfile("tb_andgate.vcd");
        $dumpvars(0, tb_andgate);
    end

endmodule
