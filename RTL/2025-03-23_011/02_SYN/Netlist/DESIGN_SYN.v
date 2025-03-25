/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Tue Mar 25 16:49:30 2025
/////////////////////////////////////////////////////////////


module DESIGN ( i_data, o_encoded, o_valid );
  input [7:0] i_data;
  output [3:0] o_encoded;
  output o_valid;
  wire   n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22;

  TIE1 U18 ( .O(n12) );
  INV1S U19 ( .I(n12), .O(o_encoded[3]) );
  ND2S U20 ( .I1(n20), .I2(n19), .O(o_encoded[2]) );
  NR2 U21 ( .I1(i_data[7]), .I2(i_data[6]), .O(n20) );
  NR2 U22 ( .I1(i_data[5]), .I2(i_data[4]), .O(n19) );
  NR2 U23 ( .I1(i_data[1]), .I2(i_data[0]), .O(n13) );
  NR2 U24 ( .I1(i_data[3]), .I2(i_data[2]), .O(n22) );
  OR3B2S U25 ( .I1(o_encoded[2]), .B1(n13), .B2(n22), .O(o_valid) );
  INV1S U26 ( .I(i_data[4]), .O(n14) );
  ND2S U27 ( .I1(n14), .I2(i_data[1]), .O(n15) );
  MOAI1S U28 ( .A1(n15), .A2(i_data[2]), .B1(n14), .B2(i_data[3]), .O(n16) );
  NR2 U29 ( .I1(i_data[5]), .I2(n16), .O(n18) );
  INV1S U30 ( .I(i_data[7]), .O(n17) );
  OAI12HS U31 ( .B1(i_data[6]), .B2(n18), .A1(n17), .O(o_encoded[0]) );
  INV1S U32 ( .I(n19), .O(n21) );
  OAI12HS U33 ( .B1(n22), .B2(n21), .A1(n20), .O(o_encoded[1]) );
endmodule

