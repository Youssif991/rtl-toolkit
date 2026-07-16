`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
//
// Create Date: 2026-07-13
// Design Name: LIFO Stack Testbench
// Module Name: tb_lifo
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the lifo module.
//              Covers push/pop sequences, full/empty flag generation,
//              LIFO ordering, wrap-around, and simultaneous push-pop.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_lifo;

    // Parameters
    localparam DATA_WIDTH = 8;
    localparam DEPTH = 8;
    localparam LOG2_DEPTH = ($clog2(DEPTH) > 0) ? $clog2(DEPTH) : 1;

    // DUT interface
    reg                      clk_i;
    reg                      rst_n_i;
    reg                      push_i;
    reg                      pop_i;
    reg     [DATA_WIDTH-1:0] data_i;
    wire    [DATA_WIDTH-1:0] data_o;
    wire                     full_o;
    wire                     empty_o;

    // Test infrastructure
    integer                  i;
    integer                  errors = 0;
    reg                      check_enable = 0;
    reg     [DATA_WIDTH-1:0] ref_stack        [0:DEPTH-1];
    integer                  ref_count;
    wire                     ref_can_push;
    wire                     ref_can_pop;
    reg                      expected_full;
    reg                      expected_empty;
    reg     [DATA_WIDTH-1:0] expected_data_o;

    assign ref_can_push = (ref_count < $unsigned(DEPTH));
    assign ref_can_pop  = (ref_count > 0);

    // Module instantiation
    lifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH     (DEPTH)
    ) dut (
        .clk_i  (clk_i),
        .rst_n_i(rst_n_i),
        .push_i (push_i),
        .pop_i  (pop_i),
        .data_i (data_i),
        .data_o (data_o),
        .full_o (full_o),
        .empty_o(empty_o)
    );

    // Golden reference: update state on posedge
    // Uses ref_count (number of items) instead of pointers to independently
    // model the LIFO behavior:
    //   - Push: store data, increment count
    //   - Pop:  retrieve top data, decrement count
    //   - Full:  ref_count == DEPTH
    //   - Empty: ref_count == 0
    always @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            ref_count       <= 0;
            expected_data_o <= 0;
            expected_full   <= 1'b0;
            expected_empty  <= 1'b1;
        end else begin
            // Push: write to current position, then increment count
            if (push_i && ref_can_push) begin
                ref_stack[ref_count[LOG2_DEPTH-1:0]] <= data_i;
            end

            // Pop: read from correct position, then decrement count
            //   - pop only:  read from (ref_count - 1) — last pushed item
            //   - pop+push:  read from ref_count — newly pushed item (now top)
            if (pop_i && ref_can_pop) begin
                if (push_i && ref_can_push) begin
                    // Simultaneous: pop reads the data just pushed
                    expected_data_o <= ref_stack[ref_count];
                end else begin
                    // Pop only: pop reads the last item
                    expected_data_o <= ref_stack[ref_count-1];
                end
            end

            // Single non-blocking assignment: net of pushes and pops
            ref_count <= ref_count + (push_i && ref_can_push) - (pop_i && ref_can_pop);

            // Look-ahead flags: predict next state after this cycle's ops
            expected_full  <= (ref_count + (push_i && ref_can_push) -
                                         (pop_i  && ref_can_pop) == $unsigned(
                DEPTH
            ));
            expected_empty <= (ref_count - (pop_i && ref_can_pop) + (push_i && ref_can_push) == 0);
        end
    end

    // Checker — compares DUT against reference on negedge
    always @(negedge clk_i) begin : check
        check_enable <= 1;
        if (check_enable) begin
            if (data_o !== expected_data_o) begin
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
        rst_n_i = 0;
        data_i  = 0;
        push_i  = 0;
        pop_i   = 0;

        @(negedge clk_i);
        @(negedge clk_i);
        rst_n_i = 1;
        @(negedge clk_i);

        // Directed test 1: push DEPTH items, then verify full flag
        for (i = 0; i < DEPTH; i = i + 1) begin
            data_i = 8'hA0 + i;
            push_i = 1;
            @(negedge clk_i);
        end
        push_i = 0;
        @(negedge clk_i);

        // Directed test 2: pop all items, verify LIFO ordering
        for (i = 0; i < DEPTH; i = i + 1) begin
            pop_i = 1;
            @(negedge clk_i);
        end
        pop_i = 0;
        @(negedge clk_i);

        // Directed test 3: push then pop in alternating cycles
        push_i = 1;
        data_i = 8'h10;
        @(negedge clk_i);
        push_i = 0;
        pop_i  = 1;
        @(negedge clk_i);
        pop_i = 0;
        @(negedge clk_i);

        // Directed test 4: simultaneous push and pop
        push_i = 1;
        pop_i  = 1;
        data_i = 8'h55;
        @(negedge clk_i);
        pop_i = 0;
        @(negedge clk_i);
        push_i = 0;
        @(negedge clk_i);

        // Directed test 5: wrap-around — push DEPTH+1 then pop all
        for (i = 0; i < DEPTH + 1; i = i + 1) begin
            data_i = 8'hC0 + i;
            push_i = 1;
            @(negedge clk_i);
        end
        push_i = 0;
        for (i = 0; i < DEPTH; i = i + 1) begin
            pop_i = 1;
            @(negedge clk_i);
        end
        pop_i = 0;
        @(negedge clk_i);

        // Random stimulus
        for (i = 0; i < 100; i = i + 1) begin
            data_i = $random;
            push_i = $random;
            pop_i  = $random;
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
        $monitor("Time=%0t | rst=%b push=%b pop=%b data_in=%h data_out=%h full=%b empty=%b", $time,
                 rst_n_i, push_i, pop_i, data_i, data_o, full_o, empty_o);
    end

    // VCD dump
    initial begin
        $dumpfile("tb_lifo.vcd");
        $dumpvars(0, tb_lifo);
    end

endmodule
