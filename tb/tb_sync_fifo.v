`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 2026-07-13
// Design Name: Synchronous FIFO Testbench
// Module Name: tb_sync_fifo
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the sync_fifo module.
//              Covers write/read sequences, full/empty flag generation,
//              wrap-around, and simultaneous read-write behavior.
//
// Dependencies: sync_fifo (src/sync_fifo.v)
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_sync_fifo;

    // Parameters
    localparam DEPTH = 8;
    localparam DATA_WIDTH = 8;

    // Inputs
    reg                      clk_i;
    reg                      rst_n_i;
    reg     [DATA_WIDTH-1:0] data_i;
    reg                      read_enable_i;
    reg                      write_enable_i;

    // Outputs
    wire    [DATA_WIDTH-1:0] data_o;
    wire                     full_o;
    wire                     empty_o;

    // Test infrastructure
    integer                  i;
    integer                  errors = 0;
    reg                      check_enable = 0;
    reg                      got_read = 0;
    reg     [DATA_WIDTH-1:0] ref_mem          [0:DEPTH-1];
    reg     [DATA_WIDTH-1:0] expected_data_o;
    reg                      expected_full;
    reg                      expected_empty;
    integer                  ref_count;
    integer                  wr_idx;
    integer                  rd_idx;
    integer                  ref_inc;
    integer                  ref_dec;

    // Module instantiation
    sync_fifo #(
        .DEPTH     (DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk_i         (clk_i),
        .rst_n_i       (rst_n_i),
        .data_i        (data_i),
        .read_enable_i (read_enable_i),
        .write_enable_i(write_enable_i),
        .data_o        (data_o),
        .full_o        (full_o),
        .empty_o       (empty_o)
    );

    // Golden reference model
    // Uses a counter-based approach (ref_count) rather than pointers to
    // independently model the FIFO behavior:
    //   - Write: increment count, store data in circular buffer
    //   - Read:  decrement count, output oldest buffered data
    //   - Full:  ref_count == DEPTH
    //   - Empty: ref_count == 0
    //
    // This intentionally diverges from the DUT's wrap-bit pointer technique
    // to catch mismatches in either implementation.

    // Initialize reference model
    initial begin
        ref_count       = 0;
        wr_idx          = 0;
        rd_idx          = 0;
        expected_data_o = 0;
    end

    // Reference: sample inputs on posedge and update model state
    always @(posedge clk_i) begin
        if (!rst_n_i) begin
            ref_count       <= 0;
            wr_idx          <= 0;
            rd_idx          <= 0;
            expected_data_o <= 0;
            expected_full   <= 1'b0;
            expected_empty  <= 1'b1;
        end else begin
            if (write_enable_i && (ref_count < DEPTH)) begin
                ref_mem[wr_idx] <= data_i;
                wr_idx <= (wr_idx + 1) % DEPTH;
            end

            if (read_enable_i && (ref_count > 0)) begin
                expected_data_o <= ref_mem[rd_idx];
                rd_idx <= (rd_idx + 1) % DEPTH;
            end

            // Single non-blocking assignment: net of writes and reads
            ref_count <= ref_count + (write_enable_i && (ref_count < DEPTH)) -
                                     (read_enable_i  && (ref_count > 0));

            // Compute next-state flags using ref_count before this cycle's ops
            ref_inc = (write_enable_i && (ref_count < DEPTH));
            ref_dec = (read_enable_i && (ref_count > 0));

            expected_full  <= (ref_count + ref_inc - ref_dec == DEPTH);
            expected_empty <= (ref_count - ref_dec + ref_inc == 0);
        end
    end

    // Track when first read completes so data_o is valid for comparison
    always @(posedge clk_i) begin
        if (!rst_n_i) begin
            got_read <= 0;
        end else if (read_enable_i && (ref_count > 0)) begin
            got_read <= 1;
        end
    end

    // Checker — compares DUT outputs against reference on negedge
    always @(negedge clk_i) begin : check
        check_enable <= 1;
        if (check_enable) begin
            if (got_read && (data_o !== expected_data_o)) begin
                errors = errors + 1;
                $display("FAIL at t=%0t: data_o=%h expected=%h", $time, data_o, expected_data_o);
            end
            if (full_o !== expected_full) begin
                errors = errors + 1;
                $display("FAIL at t=%0t: full_o=%b expected=%b", $time, full_o, expected_full);
            end
            if (empty_o !== expected_empty) begin
                errors = errors + 1;
                $display("FAIL at t=%0t: empty_o=%b expected=%b", $time, empty_o, expected_empty);
            end
        end
    end

    // Clock generation
    initial begin : clock_gen
        clk_i = 0;
        forever #10 clk_i = ~clk_i;
    end

    // Test procedure
    initial begin : test_seq
        // Initialize inputs
        rst_n_i        = 0;
        data_i         = 0;
        read_enable_i  = 0;
        write_enable_i = 0;

        @(negedge clk_i);
        @(negedge clk_i);
        rst_n_i = 1;
        @(negedge clk_i);

        // Directed test 1: write all slots, full flag asserts
        for (i = 0; i < DEPTH; i = i + 1) begin
            data_i         = i + 8'h10;
            write_enable_i = 1;
            @(negedge clk_i);
        end
        write_enable_i = 0;
        @(negedge clk_i);

        // Directed test 2: read all slots, empty flag asserts
        for (i = 0; i < DEPTH; i = i + 1) begin
            read_enable_i = 1;
            @(negedge clk_i);
        end
        read_enable_i = 0;
        @(negedge clk_i);

        // Directed test 3: simultaneous write and read
        write_enable_i = 1;
        read_enable_i  = 1;
        data_i         = 8'hA5;
        for (i = 0; i < DEPTH; i = i + 1) begin
            data_i = data_i + 1;
            @(negedge clk_i);
        end
        write_enable_i = 0;
        read_enable_i  = 0;
        @(negedge clk_i);

        // Directed test 4: wrap-around — write DEPTH+1 items
        for (i = 0; i < DEPTH + 1; i = i + 1) begin
            data_i         = 8'hC0 + i;
            write_enable_i = 1;
            @(negedge clk_i);
        end
        write_enable_i = 0;
        @(negedge clk_i);

        // Random stimulus
        for (i = 0; i < 100; i = i + 1) begin
            data_i         = $random;
            write_enable_i = $random;
            read_enable_i  = $random;
            @(negedge clk_i);
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

    // Live monitor
    initial begin : monitor
        $monitor("Time=%0t | wr=%b rd=%b data_in=%h data_out=%h full=%b empty=%b", $time,
                 write_enable_i, read_enable_i, data_i, data_o, full_o, empty_o);
    end

    // VCD dump
    initial begin
        $dumpfile("tb_sync_fifo.vcd");
        $dumpvars(0, tb_sync_fifo);
    end

endmodule
