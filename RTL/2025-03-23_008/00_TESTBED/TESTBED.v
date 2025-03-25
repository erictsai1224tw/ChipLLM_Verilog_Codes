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

parameter WIDTH = 8;
parameter DATA_LANE_COUNT = 4;
parameter DATA_WIDTH = 8;

logic clk;
logic rst;
logic enable;
logic [DATA_LANE_COUNT-1:0] d_p;
logic [DATA_LANE_COUNT-1:0] d_n;
logic clk_p;
logic clk_n;
logic [DATA_WIDTH*DATA_LANE_COUNT-1:0] data_out;
logic data_valid;
logic frame_start;
logic frame_end;
logic error_flag;


initial begin
    `ifdef RTL
        $fsdbDumpfile("DESIGN.fsdb");
        $fsdbDumpvars(0,"+mda");
    `endif
    `ifdef GATE
        $sdf_annotate("DESIGN_SYN.sdf", u_DESIGN);
        $fsdbDumpfile("DESIGN_SYN.fsdb");
        $fsdbDumpvars(0,"+mda"); 
    `endif
end


    
PATTERN #(.DATA_LANE_COUNT(DATA_LANE_COUNT),
            .DATA_WIDTH(DATA_WIDTH)) u_PATTERN(
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .d_p(d_p),
    .d_n(d_n),
    .clk_p(clk_p),
    .clk_n(clk_n),
    .data_out(data_out),
    .data_valid(data_valid),
    .frame_start(frame_start),
    .frame_end(frame_end),
    .error_flag(error_flag)
);

DESIGN #(.DATA_LANE_COUNT(DATA_LANE_COUNT),
    .DATA_WIDTH(DATA_WIDTH)) u_DESIGN(
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .d_p(d_p),
    .d_n(d_n),
    .clk_p(clk_p),
    .clk_n(clk_n),
    .data_out(data_out),
    .data_valid(data_valid),
    .frame_start(frame_start),
    .frame_end(frame_end),
    .error_flag(error_flag)
);

endmodule
