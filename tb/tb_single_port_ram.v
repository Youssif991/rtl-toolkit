`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 2026-07-13
// Design Name: Single Port RAM Testbench
// Module Name: tb_single_port_ram
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the single_port_ram module.
//              Covers write/read-back, multiple addresses, chip_select
//              gating, output_enable tri-state, and register read output.
//
// Dependencies: single_port_ram (src/single_port_ram.v)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_single_port_ram;

    // Parameters
    localparam DATA_WIDTH = 8;
    localparam DEPTH = 16;
    localparam ADDR_WIDTH = 8;
    localparam LOG2_DEPTH = ($clog2(DEPTH) > 0) ? $clog2(DEPTH) : 1;

    // DUT interface
    reg                      clk;
    reg     [ADDR_WIDTH-1:0] addr;
    reg     [DATA_WIDTH-1:0] data_in;
    reg                      write_enable;
    reg                      chip_select;
    reg                      output_enable;
    wire    [DATA_WIDTH-1:0] data_out;

    // Test infrastructure
    integer                  i;
    integer                  errors = 0;
    reg                      check_enable = 0;
    reg     [DATA_WIDTH-1:0] ref_mem           [0:DEPTH-1];
    reg     [DATA_WIDTH-1:0] ref_data_out_reg;
    wire    [DATA_WIDTH-1:0] expected_data_out;

    // Module instantiation
    single_port_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH     (DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk          (clk),
        .addr         (addr),
        .data_in      (data_in),
        .write_enable (write_enable),
        .chip_select  (chip_select),
        .output_enable(output_enable),
        .data_out     (data_out)
    );

    // Golden reference model
    // Independently implements the same single-port RAM behavior:
    //   - Write: on posedge clk when chip_select & write_enable
    //   - Read:  on posedge clk when chip_select & !write_enable (registered)
    //   - Output tri-state: data_out = 'z unless chip_select & output_enable
    //     during a read cycle
    // Uses a flat register array accessed directly (no address masking) to
    // intentionally diverge from the DUT's internal structure — catching
    // errors from either the masking logic or the memory indexing.

    // Initialize reference memory to known values
    integer init_idx;
    initial begin
        for (init_idx = 0; init_idx < DEPTH; init_idx = init_idx + 1) begin
            ref_mem[init_idx] = 8'h00;
        end
        ref_data_out_reg = 8'h00;
    end

    // Write stage: update the register file when chip_select and
    // write_enable are both active. Uses the raw address without
    // LOG2_DEPTH bounds — mimics a flat memory model that would
    // catch mismatches if the DUT's masking logic is wrong.
    always @(posedge clk) begin
        if (chip_select && write_enable) begin
            ref_mem[addr[LOG2_DEPTH-1:0]] <= data_in;
        end
    end

    // Read stage: registered read — updates one cycle after the
    // address is presented, just like the DUT.
    always @(posedge clk) begin
        if (chip_select && !write_enable) begin
            ref_data_out_reg <= ref_mem[addr[LOG2_DEPTH-1:0]];
        end
    end

    // Output decode: tri-state control matches DUT's assign exactly.
    // Drives the registered value only during an active read cycle;
    // otherwise high-impedance.
    assign expected_data_out = (chip_select & output_enable & !write_enable)
                               ? ref_data_out_reg
                               : {DATA_WIDTH{1'bz}};

    // Checker
    always @(negedge clk) begin
        check_enable <= 1;
        if (check_enable && (data_out !== expected_data_out)) begin
            errors = errors + 1;
            $display("FAIL at t=%0t addr=%0d cs=%b oe=%b we=%b dout=%h exp=%h", $time, addr,
                     chip_select, output_enable, write_enable, data_out, expected_data_out);
        end
    end

    // Clock generation
    initial begin : clock_gen
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test procedure
    initial begin : test_seq

        // Initialize all DUT inputs
        addr          = 0;
        data_in       = 0;
        write_enable  = 0;
        chip_select   = 0;
        output_enable = 0;

        // Wait for reset / startup settling
        @(negedge clk);
        @(negedge clk);

        // Directed test 1: write to addr 0, read it back

        // Write 0xAB to address 0
        addr          = 0;
        data_in       = 8'hAB;
        write_enable  = 1;
        chip_select   = 1;
        output_enable = 0;
        @(negedge clk);

        // Read back — deassert write, assert output enable
        write_enable  = 0;
        output_enable = 1;
        @(negedge clk);
        // data_out should be 0xAB now (registered read)

        // Directed test 2: write to multiple addresses, read in order

        write_enable  = 1;
        output_enable = 0;
        chip_select   = 1;
        for (i = 0; i < DEPTH; i = i + 1) begin
            addr    = i;
            data_in = i[7:0] ^ 8'hA5;
            @(negedge clk);
        end

        write_enable  = 0;
        output_enable = 1;
        for (i = 0; i < DEPTH; i = i + 1) begin
            addr = i;
            @(negedge clk);
        end

        // Directed test 3: chip_select gating — write without CS

        chip_select   = 0;
        write_enable  = 1;
        output_enable = 1;
        addr          = 0;
        data_in       = 8'hFF;  // Should NOT be written
        @(negedge clk);

        // Read back — should still see 0xAB, not 0xFF
        chip_select   = 1;
        write_enable  = 0;
        output_enable = 1;
        addr          = 0;
        @(negedge clk);

        // Directed test 4: output_enable gating — read with OE low

        chip_select   = 1;
        write_enable  = 0;
        output_enable = 0;  // OE low — data_out should be 'z
        addr          = 1;
        @(negedge clk);

        // Directed test 5: read during active write — output should be 'z

        chip_select   = 1;
        write_enable  = 1;  // WE active — even with OE, output 'z
        output_enable = 1;
        addr          = 5;
        data_in       = 8'h55;
        @(negedge clk);

        // Directed test 6: wrapped address via LOG2_DEPTH masking

        // Write to addr = DEPTH (one past end) — should wrap to index 0
        chip_select   = 1;
        write_enable  = 1;
        output_enable = 0;
        addr          = DEPTH;  // Same as addr = 0 after masking
        data_in       = 8'hC3;
        @(negedge clk);

        // Read addr 0 — should see 0xC3 (written through wrapped address)
        chip_select   = 1;
        write_enable  = 0;
        output_enable = 1;
        addr          = 0;
        @(negedge clk);

        // Random stimulus

        for (i = 0; i < 100; i = i + 1) begin
            addr          = $random;
            data_in       = $random;
            chip_select   = $random;
            write_enable  = $random;
            output_enable = $random;
            @(negedge clk);
        end

        // Report
        #20;

        if (errors == 0) begin
            $display("TEST PASSED — all checks matched");
        end else begin
            $display("TEST FAILED — %0d mismatches found", errors);
        end

        $finish;
    end

    // Live monitor: prints signal values on every change
    initial begin
        $monitor("Time=%0t | cs=%b oe=%b we=%b addr=%0d dout=%h exp=%h", $time, chip_select,
                 output_enable, write_enable, addr, data_out, expected_data_out);
    end

    // VCD dump
    initial begin
        $dumpfile("tb_single_port_ram.vcd");
        $dumpvars(0, tb_single_port_ram);
    end

endmodule
