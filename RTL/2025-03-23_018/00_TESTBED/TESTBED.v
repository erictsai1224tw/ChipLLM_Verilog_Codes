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

logic [WIDTH-1:0] i_data;
logic [$clog2(WIDTH)-1:0] o_encoded;
logic o_valid;


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
    // Inputs
    .i_data(out_data),
    // Outputs
    .o_encoded(o_encoded),
    .o_valid(o_valid)
);

DESIGN u_DESIGN(
    // Inputs
    .i_data(out_data),
    // Outputs
    .o_encoded(o_encoded),
    .o_valid(o_valid)
);

endmodule
