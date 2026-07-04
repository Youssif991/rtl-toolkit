`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Youssef
// 
// Create Date: 06/26/2026 02:33:35 AM
// Design Name: 2-to-1 Multiplexer
// Module Name: mux_2x1
// Tool Versions: Vivado 2025.2
// Description: Selects between D0 and D1 based on select `S`. Outputs
//              Y = S ? D1 : D0. Combinational single-bit mux.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mux_2x1 (
    input  D0,
    input  D1,
    input  S,
    output Y
);

  wire not_S;
  wire out_G2;
  wire out_G3;

  /*First implementation 

    notgate G1 (
    .A(S),
    .B(not_S)
    );
    
    andgate G2 (
    .A(D0),
    .B(not_S),
    .C(out_G2)
    );
    
    andgate G3 (
    .A(D1),
    .B(S),
    .C(out_G3)
    );
    
    orgate G4 (
    .A(out_G2),
    .B(out_G3),
    .C(Y)
    );
    
    */
  //Second implementation (easier one imo)

  /*
  assign not_S = ~S;
  assign out_G2 = D0 & not_S;
  assign out_G3 = D1 & S;
  
  assign Y = out_G2 | out_G3 ;
    */

  //Third implementation (Data flow)

  assign Y = S ? D1 : D0;

endmodule
