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

    parameter DATA_WIDTH = 16;
    parameter TWIDDLE_WIDTH = 16;
    parameter CYCLE = 10;

    // Clock & Reset
    reg clk = 0;
    reg rst;

    always #(CYCLE/2) clk = ~clk;

    // Input & Output Wires
    wire signed [DATA_WIDTH-1:0] data_in_real [7:0];
    wire signed [DATA_WIDTH-1:0] data_in_imag [7:0];
    wire signed [DATA_WIDTH:0] data_out_real [7:0];
    wire signed [DATA_WIDTH:0] data_out_imag [7:0];

    // 產生 Reset
    initial begin
        rst = 1;
        #(CYCLE * 2);
        rst = 0;
    end

    // Dump waveform (optional)
    initial begin
        `ifdef RTL
            $fsdbDumpfile("fft.fsdb");
            $fsdbDumpvars(0, "+mda");
        `endif
    end

    

    // PATTERN Instance
    PATTERN u_PATTERN (
        .clk(clk),
        .rst(rst),
        .data_in_real(data_in_real),
        .data_in_imag(data_in_imag),
        .data_out_real(data_out_real),
        .data_out_imag(data_out_imag)
    );

    // DUT Instance
    butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) u_DESIGN (
        .clk(clk),
        .rst(rst),
        .data_in_real(data_in_real),
        .data_in_imag(data_in_imag),
        .data_out_real(data_out_real),
        .data_out_imag(data_out_imag)
    );

endmodule
