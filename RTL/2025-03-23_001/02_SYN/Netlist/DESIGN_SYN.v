/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Tue Mar 25 15:54:17 2025
/////////////////////////////////////////////////////////////


module DESIGN ( i_data, o_encoded, o_valid );
  input [7:0] i_data;
  output [2:0] o_encoded;
  output o_valid;
  wire   n9, n10, n11, n12, n13, n14, n15, n16, n17;

  ND2S U15 ( .I1(n9), .I2(n16), .O(o_encoded[2]) );
  NR2 U16 ( .I1(i_data[4]), .I2(i_data[5]), .O(n9) );
  NR2 U17 ( .I1(i_data[7]), .I2(i_data[6]), .O(n16) );
  NR2 U18 ( .I1(i_data[0]), .I2(o_encoded[2]), .O(n10) );
  NR2 U19 ( .I1(i_data[3]), .I2(i_data[2]), .O(n17) );
  INV1S U20 ( .I(i_data[1]), .O(n11) );
  ND3S U21 ( .I1(n10), .I2(n17), .I3(n11), .O(o_valid) );
  NR2 U22 ( .I1(i_data[2]), .I2(n11), .O(n12) );
  NR2 U23 ( .I1(i_data[3]), .I2(n12), .O(n14) );
  INV1S U24 ( .I(i_data[6]), .O(n13) );
  MOAI1S U25 ( .A1(n14), .A2(o_encoded[2]), .B1(i_data[5]), .B2(n13), .O(n15)
         );
  OR2S U26 ( .I1(i_data[7]), .I2(n15), .O(o_encoded[0]) );
  OAI12HS U27 ( .B1(n17), .B2(o_encoded[2]), .A1(n16), .O(o_encoded[1]) );
endmodule

