/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Tue Mar 25 17:03:35 2025
/////////////////////////////////////////////////////////////


module DESIGN ( in, out, valid );
  input [7:0] in;
  output [2:0] out;
  output valid;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18;

  ND2S U16 ( .I1(n17), .I2(n10), .O(out[2]) );
  TIE1 U17 ( .O(n15) );
  NR2 U18 ( .I1(in[7]), .I2(in[6]), .O(n17) );
  NR2 U19 ( .I1(in[5]), .I2(in[4]), .O(n10) );
  NR2 U20 ( .I1(in[1]), .I2(in[0]), .O(n11) );
  INV1S U21 ( .I(out[2]), .O(n12) );
  NR2 U22 ( .I1(in[3]), .I2(in[2]), .O(n18) );
  ND3S U23 ( .I1(n11), .I2(n12), .I3(n18), .O(valid) );
  ND2S U24 ( .I1(n12), .I2(in[1]), .O(n13) );
  MOAI1S U25 ( .A1(n13), .A2(in[2]), .B1(n12), .B2(in[3]), .O(n14) );
  NR2 U26 ( .I1(in[5]), .I2(n14), .O(n16) );
  MOAI1S U27 ( .A1(in[6]), .A2(n16), .B1(n15), .B2(in[7]), .O(out[0]) );
  OAI12HS U28 ( .B1(n18), .B2(out[2]), .A1(n17), .O(out[1]) );
endmodule

