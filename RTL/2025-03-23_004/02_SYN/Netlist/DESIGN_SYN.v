/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Tue Mar 25 16:29:24 2025
/////////////////////////////////////////////////////////////


module DESIGN ( clk, rst, instruction_mem_data_in, data_mem_addr, 
        data_mem_data_in, data_mem_data_out, data_mem_write_enable );
  input [31:0] instruction_mem_data_in;
  output [31:0] data_mem_addr;
  input [31:0] data_mem_data_in;
  output [31:0] data_mem_data_out;
  input clk, rst;
  output data_mem_write_enable;
  wire   n67;

  TIE1 U4 ( .O(n67) );
  INV1S U5 ( .I(n67), .O(data_mem_data_out[0]) );
  INV1S U6 ( .I(n67), .O(data_mem_data_out[1]) );
  INV1S U7 ( .I(n67), .O(data_mem_data_out[2]) );
  INV1S U8 ( .I(n67), .O(data_mem_data_out[3]) );
  INV1S U9 ( .I(n67), .O(data_mem_data_out[4]) );
  INV1S U10 ( .I(n67), .O(data_mem_data_out[5]) );
  INV1S U11 ( .I(n67), .O(data_mem_data_out[6]) );
  INV1S U12 ( .I(n67), .O(data_mem_data_out[7]) );
  INV1S U13 ( .I(n67), .O(data_mem_data_out[8]) );
  INV1S U14 ( .I(n67), .O(data_mem_data_out[9]) );
  INV1S U15 ( .I(n67), .O(data_mem_data_out[10]) );
  INV1S U16 ( .I(n67), .O(data_mem_data_out[11]) );
  INV1S U17 ( .I(n67), .O(data_mem_data_out[12]) );
  INV1S U18 ( .I(n67), .O(data_mem_data_out[13]) );
  INV1S U19 ( .I(n67), .O(data_mem_data_out[14]) );
  INV1S U20 ( .I(n67), .O(data_mem_data_out[15]) );
  INV1S U21 ( .I(n67), .O(data_mem_data_out[16]) );
  INV1S U22 ( .I(n67), .O(data_mem_data_out[17]) );
  INV1S U23 ( .I(n67), .O(data_mem_data_out[18]) );
  INV1S U24 ( .I(n67), .O(data_mem_data_out[19]) );
  INV1S U25 ( .I(n67), .O(data_mem_data_out[20]) );
  INV1S U26 ( .I(n67), .O(data_mem_data_out[21]) );
  INV1S U27 ( .I(n67), .O(data_mem_data_out[22]) );
  INV1S U28 ( .I(n67), .O(data_mem_data_out[23]) );
  INV1S U29 ( .I(n67), .O(data_mem_data_out[24]) );
  INV1S U30 ( .I(n67), .O(data_mem_data_out[25]) );
  INV1S U31 ( .I(n67), .O(data_mem_data_out[26]) );
  INV1S U32 ( .I(n67), .O(data_mem_data_out[27]) );
  INV1S U33 ( .I(n67), .O(data_mem_data_out[28]) );
  INV1S U34 ( .I(n67), .O(data_mem_data_out[29]) );
  INV1S U35 ( .I(n67), .O(data_mem_data_out[30]) );
  INV1S U36 ( .I(n67), .O(data_mem_data_out[31]) );
  INV1S U37 ( .I(n67), .O(data_mem_addr[0]) );
  INV1S U38 ( .I(n67), .O(data_mem_addr[1]) );
  INV1S U39 ( .I(n67), .O(data_mem_addr[2]) );
  INV1S U40 ( .I(n67), .O(data_mem_addr[3]) );
  INV1S U41 ( .I(n67), .O(data_mem_addr[4]) );
  INV1S U42 ( .I(n67), .O(data_mem_addr[5]) );
  INV1S U43 ( .I(n67), .O(data_mem_addr[6]) );
  INV1S U44 ( .I(n67), .O(data_mem_addr[7]) );
  INV1S U45 ( .I(n67), .O(data_mem_addr[8]) );
  INV1S U46 ( .I(n67), .O(data_mem_addr[9]) );
  INV1S U47 ( .I(n67), .O(data_mem_addr[10]) );
  INV1S U48 ( .I(n67), .O(data_mem_addr[11]) );
  INV1S U49 ( .I(n67), .O(data_mem_addr[12]) );
  INV1S U50 ( .I(n67), .O(data_mem_addr[13]) );
  INV1S U51 ( .I(n67), .O(data_mem_addr[14]) );
  INV1S U52 ( .I(n67), .O(data_mem_addr[15]) );
  INV1S U53 ( .I(n67), .O(data_mem_addr[16]) );
  INV1S U54 ( .I(n67), .O(data_mem_addr[17]) );
  INV1S U55 ( .I(n67), .O(data_mem_addr[18]) );
  INV1S U56 ( .I(n67), .O(data_mem_addr[19]) );
  INV1S U57 ( .I(n67), .O(data_mem_addr[20]) );
  INV1S U58 ( .I(n67), .O(data_mem_addr[21]) );
  INV1S U59 ( .I(n67), .O(data_mem_addr[22]) );
  INV1S U60 ( .I(n67), .O(data_mem_addr[23]) );
  INV1S U61 ( .I(n67), .O(data_mem_addr[24]) );
  INV1S U62 ( .I(n67), .O(data_mem_addr[25]) );
  INV1S U63 ( .I(n67), .O(data_mem_addr[26]) );
  INV1S U64 ( .I(n67), .O(data_mem_addr[27]) );
  INV1S U65 ( .I(n67), .O(data_mem_addr[28]) );
  INV1S U66 ( .I(n67), .O(data_mem_addr[29]) );
  INV1S U67 ( .I(n67), .O(data_mem_addr[30]) );
  INV1S U68 ( .I(n67), .O(data_mem_addr[31]) );
endmodule

