`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 04:18:45 PM
// Design Name: 
// Module Name: tb_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_mux;

  localparam width = 4;
  localparam selection = $clog2(width);

  reg [width - 1:0] in;
  reg [selection - 1 : 0] s;
  wire out;
  integer i;

  mux #(
      .width(width),
      .selection(selection)
  ) dut (
      .in (in),
      .s  (s),
      .out(out)
  );

  initial begin

    in = 0;
    s  = 0;



    $monitor("in=%0b s=%0b out=%0b", in, s, out);

    for (i = 0; i < (1 << (width + selection)); i = i + 1) begin
      {in, s} = i;
      #10;
    end

    $finish;

  end


endmodule
