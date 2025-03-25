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
parameter HASH_ALGORITHM = "SHA256";
parameter KEY_SIZE = 2048;
parameter CERTIFICATE_SIZE = 1024;
parameter BOOTLOADER_SIZE = 64 * 1024; //64KB
parameter OS_SIZE = 16 * 1024 * 1024; //16MB

logic clk;
logic rst;
logic start;
logic [BOOTLOADER_SIZE*8-1:0] bootloader_data;
logic [OS_SIZE*8-1:0] os_data;
logic boot_successful;
logic boot_failed;


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
    .start(start),
    .bootloader_data(bootloader_data),
    .os_data(os_data),
    .boot_successful(boot_successful),
    .boot_failed(boot_failed)
);

DESIGN u_DESIGN(
    .clk(clk),
    .rst(rst),
    .start(start),
    .bootloader_data(bootloader_data),
    .os_data(os_data),
    .boot_successful(boot_successful),
    .boot_failed(boot_failed)
);

endmodule
