`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 07/06/2026 16:09:11
// Design Name: Seven Segment display test bench
// Module Name: tb_seven_seg
// Tool Versions: Vivado 2025.2
// Description: Self-checking testbench for the `seven_seg` decoder. Uses a
//              golden reference model (duplicated case logic) to verify the
//              segment pattern for all 10 BCD digits plus random inputs.
// 
// Dependencies: seven_seg (src/blocks/seven_seg.v)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_seven_seg;

  // Parameter
  localparam active_low = 0;
  // Inputs
  reg [3 : 0] in;

  // Outputs
  wire [6 : 0] out;

  // Test variables
  integer i;
  integer errors = 0;
  reg [6 : 0] expected_out;

  // Module instantation
  seven_seg #(
      .active_low(active_low)
  ) dut (
      .in (in),
      .out(out)
  );

  // Golden reference
  always @(*) begin : reference
    reg [6 : 0] out_active_high;

    case (in)

      4'h0: out_active_high = 7'b1111110;  // display 0
      4'h1: out_active_high = 7'b0110000;  // display 1
      4'h2: out_active_high = 7'b1101101;  // display 2
      4'h3: out_active_high = 7'b1111001;  // display 3
      4'h4: out_active_high = 7'b0110011;  // display 4
      4'h5: out_active_high = 7'b1011011;  // display 5
      4'h6: out_active_high = 7'b1011111;  // display 6
      4'h7: out_active_high = 7'b1110000;  // display 7
      4'h8: out_active_high = 7'b1111111;  // display 8
      4'h9: out_active_high = 7'b1111010;  // display 9
      default:
      out_active_high = 7'b0000000;  // the default display as long as there is no BCD input

    endcase

    assign expected_out = active_low ? ~out_active_high : out_active_high;

  end

  // Check the dut against the golden reference
  always @(*) begin : check_model
    #1;
    if (out !== expected_out) begin
      errors = errors + 1;
      $display("FAIL at time %0t : dut_out=%b expected_out=%b", $time, out, expected_out);
    end
  end

  //  Test procdeure
  initial begin : test

    // Initializing inputs
    in = 0;

    for (i = 0; i < 10; i = i + 1) begin : input_cases  // assigning all possible input combintations
      #10 in = i;
    end

    for (i = 0; i < 20; i = i + 1) begin : random_cases  // stress test to test random inputs
      #10 in = $random;
    end

    #20;

    if (errors == 0) begin : report_pass
      $display(" TEST PASSED — all checks matched");
    end else begin : report_fail
      $display(" TEST FAILED — %0d mismatches found", errors);
    end

    $finish;

  end

  // Monitoring the output
  initial begin : live_monitor
    $monitor("Time=%0t | dut_out=%b | expected_out=%b", $time, out, expected_out);
  end

  // VCD dump
  initial begin
    $dumpfile("tb_seven_seg.vcd");
    $dumpvars(0, tb_seven_seg);
  end



endmodule
