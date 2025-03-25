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

logic clk;
logic rst;
logic [31:0] instruction_mem_data_in;
logic [31:0] data_mem_addr;
logic [31:0] data_mem_data_in;
logic [31:0] data_mem_data_out;
logic data_mem_write_enable;


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


    
PATTERN u_PATTERN(
    .clk(clk),
    .rst(rst),
    .instruction_mem_data_in(instruction_mem_data_in),
    .data_mem_addr(data_mem_addr),
    .data_mem_data_in(data_mem_data_in),
    .data_mem_data_out(data_mem_data_out),
    .data_mem_write_enable(data_mem_write_enable)
);

DESIGN u_DESIGN(
    .clk(clk),
    .rst(rst),
    .instruction_mem_data_in(instruction_mem_data_in),
    .data_mem_addr(data_mem_addr),
    .data_mem_data_in(data_mem_data_in),
    .data_mem_data_out(data_mem_data_out),
    .data_mem_write_enable(data_mem_write_enable)
);

endmodule
