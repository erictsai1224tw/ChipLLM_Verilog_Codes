/**************************************************************************/
// Copyright (c) 2024, Si2 Lab
// MODULE: TESTBED
// FILE NAME: TESTBED.v
// VERSRION: 1.0
// DATE: Sep, 2024
// AUTHOR: Jui-Huang Tsai
// CODE TYPE: RTL or Behavioral Level (Verilog)
// DESCRIPTION: 2024 Autumn IC Lab / Midterm Project
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/
`timescale 1ns/10ps

`include "PATTERN.v"
`ifdef RTL
    `include "DESIGN.v"
`endif
`ifdef GATE
    `include "DESIGN_SYN.v"
`endif

module TESTBED;

parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 64;
parameter NUM_MASTERS = 2;
parameter NUM_SLAVES = 2;

// Clock and Reset
logic clk;
logic rst;

// Master signals
logic [NUM_MASTERS-1:0][ADDR_WIDTH-1:0] awaddr_m;
logic [NUM_MASTERS-1:0][DATA_WIDTH-1:0] wdata_m;
logic [NUM_MASTERS-1:0][DATA_WIDTH/8-1:0] wstrb_m;
logic [NUM_MASTERS-1:0] awvalid_m;
logic [NUM_MASTERS-1:0] awready_m;
logic [NUM_MASTERS-1:0] wvalid_m;
logic [NUM_MASTERS-1:0] wready_m;
logic [NUM_MASTERS-1:0] bready_m;
logic [NUM_MASTERS-1:0] bvalid_m;
logic [NUM_MASTERS-1:0][2:0] bresp_m;

// Slave signals
logic [NUM_SLAVES-1:0][ADDR_WIDTH-1:0] awaddr_s;
logic [NUM_SLAVES-1:0][DATA_WIDTH-1:0] wdata_s;
logic [NUM_SLAVES-1:0][DATA_WIDTH/8-1:0] wstrb_s;
logic [NUM_SLAVES-1:0] awvalid_s;
logic [NUM_SLAVES-1:0] awready_s;
logic [NUM_SLAVES-1:0] wvalid_s;
logic [NUM_SLAVES-1:0] wready_s;
logic [NUM_SLAVES-1:0] bready_s;
logic [NUM_SLAVES-1:0] bvalid_s;
logic [NUM_SLAVES-1:0][2:0] bresp_s;


initial begin
    `ifdef RTL
        $fsdbDumpfile("DESIGN.fsdb");
        $fsdbDumpvars(0,"+mda");
    `endif
    `ifdef GATE
        $sdf_annotate("DESIGN_SYN.sdf", u_ISP);
        $fsdbDumpfile("DESIGN_SYN.fsdb");
        $fsdbDumpvars(0,"+mda"); 
    `endif
end


    
PATTERN u_PATTERN(
 .clk(clk),
 .rst(rst),
 .awaddr_m(awaddr_m),
 .wdata_m(wdata_m),
 .wstrb_m(wstrb_m),
 .awvalid_m(awvalid_m),
 .awready_m(awready_m),
 .wvalid_m(wvalid_m),
 .wready_m(wready_m),
 .bready_m(bready_m),
 .bvalid_m(bvalid_m),
 .bresp_m(bresp_m)
);

DESIGN u_priority_encoder(
 .clk(clk),
 .rst(rst),
 .awaddr_m(awaddr_m),
 .wdata_m(wdata_m),
 .wstrb_m(wstrb_m),
 .awvalid_m(awvalid_m),
 .awready_m(awready_m),
 .wvalid_m(wvalid_m),
 .wready_m(wready_m),
 .bready_m(bready_m),
 .bvalid_m(bvalid_m),
 .bresp_m(bresp_m)
);

endmodule
