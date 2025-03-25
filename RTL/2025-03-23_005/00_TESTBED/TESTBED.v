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

// module TESTBED;

// parameter WIDTH = 8;

// logic [WIDTH-1:0] i_data;
// logic [$clog2(WIDTH)-1:0] o_encoded;
// logic o_valid;


// initial begin
//     `ifdef RTL
//         $fsdbDumpfile("DESIGN.fsdb");
//         $fsdbDumpvars(0,"+mda");
//     `endif
//     `ifdef GATE
//         $sdf_annotate("DESIGN_SYN.sdf", u_DESIGN);
//         $fsdbDumpfile("DESIGN_SYN.fsdb");
//         $fsdbDumpvars(0,"+mda"); 
//     `endif
// end


    
// PATTERN u_PATTERN(
//     // Inputs
//     .i_data(out_data),
//     // Outputs
//     .o_encoded(o_encoded),
//     .o_valid(o_valid)
// );

// DESIGN u_DESIGN(
//     // Inputs
//     .i_data(out_data),
//     // Outputs
//     .o_encoded(o_encoded),
//     .o_valid(o_valid)
// );

// endmodule

module TESTBED;

    // Parameters
    parameter CYCLE = 10;

    // Clock & Reset
    logic clk = 0;
    logic rst;
    always #(CYCLE/2) clk = ~clk;

    // DUT I/O signals
    logic enable;
    logic [127:0] data_in, key_in;
    logic operation_mode;
    logic [127:0] data_out;
    logic valid_out;
    logic busy;

    // Dump waveforms
    initial begin
        `ifdef RTL
            $fsdbDumpfile("DESIGN.fsdb");
            $fsdbDumpvars(0, "+mda");
        `endif
        `ifdef GATE
            $sdf_annotate("DESIGN_SYN.sdf", u_DESIGN);
            $fsdbDumpfile("DESIGN_SYN.fsdb");
            $fsdbDumpvars(0, "+mda");
        `endif
    end

    // Reset sequence
    initial begin
        rst = 1;
        #(CYCLE * 2);
        rst = 0;
    end

    // Instantiate Design
    DESIGN u_DESIGN (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .data_in(data_in),
        .key_in(key_in),
        .operation_mode(operation_mode),
        .data_out(data_out),
        .valid_out(valid_out),
        .busy(busy)
    );

    // Instantiate Pattern Generator
    PATTERN u_PATTERN (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .data_in(data_in),
        .key_in(key_in),
        .operation_mode(operation_mode),
        .data_out(data_out),
        .valid_out(valid_out),
        .busy(busy)
    );

endmodule

