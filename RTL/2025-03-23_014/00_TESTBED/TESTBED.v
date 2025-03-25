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

// `include "PATTERN.v"
`ifdef RTL
    `include "DESIGN.v"
`endif
`ifdef GATE
    `include "DESIGN_SYN.v"
`endif

module TESTBED;

parameter KEY_SIZE = 2048;
  parameter ECC_CURVE = "P-256";

  // Signals
  logic clk;
  logic rst_n;
  logic enable;
  logic [7:0] command;
  logic [KEY_SIZE-1:0] data_in;
  logic [KEY_SIZE-1:0] data_out;
  logic busy;
  logic error;


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


    
DESIGN #(
      .KEY_SIZE(KEY_SIZE),
      .ECC_CURVE(ECC_CURVE)
  ) u_DESIGN (
      .clk(clk),
      .rst_n(rst_n),
      .enable(enable),
      .command(command),
      .data_in(data_in),
      .data_out(data_out),
      .busy(busy),
      .error(error)
  );

//   // Clock generation

  always #5 clk = ~clk;

  // Test sequence
  initial begin
    clk = 0;
    rst_n = 0;
    enable = 0;
    command = 0;
    data_in = 0;

    // Reset sequence
    #10;
    rst_n = 1;

    // Test case 1: Key Generation
    #10;
    enable = 1;
    command = 8'h01; // Generate Key
    #20;
    enable = 0;
    #10;
    $display("Key Generated: %h", u_DESIGN.key);
    if(u_DESIGN.key == 0) $error("Key generation failed");

    // Test case 2: Encryption
    #10;
    enable = 1;
    command = 8'h02; // Encrypt
    data_in = 2048'h1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef; // Test Data
    #20;
    enable = 0;
    #10;
    $display("Encrypted Data: %h", data_out);

    // Test case 3: Decryption
    #10;
    enable = 1;
    command = 8'h03; // Decrypt
    data_in = data_out; // Encrypted data from previous test
    #20;
    enable = 0;
    #10;
    $display("Decrypted Data: %h", data_out);

    // Test case 4: Invalid Command
    #10;
    enable = 1;
    command = 8'h04; // Invalid Command
    #10;
    enable = 0;
    if (error) $display("Error detected for invalid command - PASSED");
    else $error("Error not detected for invalid command - FAILED");

    // Test case 5: Disable during processing
    #10;
    enable = 1;
    command = 8'h02;
    data_in = 2048'h1234;
    #5;
    enable = 0;
    #20;
    $display("Encryption with disabled enable completed. Output: %h", data_out);


    // Finish simulation
    #10;
    $finish;
  end

endmodule
