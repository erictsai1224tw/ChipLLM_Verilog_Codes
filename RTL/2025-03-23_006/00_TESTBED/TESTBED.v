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

    // Clock and Reset
    logic clk = 0;
    logic rst_n;

    always #(CYCLE/2) clk = ~clk;

    initial begin
        rst_n = 0;
        #(CYCLE * 2);
        rst_n = 1;
    end

    // PHY Interface
    logic rx_data_valid;
    logic [7:0] rx_data;
    logic tx_en;
    logic [7:0] tx_data;

    // Host Interface
    logic host_tx_req;
    logic [7:0] host_tx_data;
    logic host_rx_rdy;
    logic [7:0] host_rx_data;

    // Dump waveform
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

    // Instantiate DESIGN (MAC Controller)
    DESIGN u_DESIGN (
        .clk(clk),
        .rst_n(rst_n),
        .rx_data_valid(rx_data_valid),
        .rx_data(rx_data),
        .tx_en(tx_en),
        .tx_data(tx_data),
        .host_tx_req(host_tx_req),
        .host_tx_data(host_tx_data),
        .host_rx_rdy(host_rx_rdy),
        .host_rx_data(host_rx_data)
    );

    // Instantiate PATTERN
    PATTERN u_PATTERN (
        .clk(clk),
        .rst_n(rst_n),
        .rx_data_valid(rx_data_valid),
        .rx_data(rx_data),
        .tx_en(tx_en),
        .tx_data(tx_data),
        .host_tx_req(host_tx_req),
        .host_tx_data(host_tx_data),
        .host_rx_rdy(host_rx_rdy),
        .host_rx_data(host_rx_data)
    );

endmodule
