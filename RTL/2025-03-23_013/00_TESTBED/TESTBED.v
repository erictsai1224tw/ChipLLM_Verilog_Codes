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

  logic [WIDTH-1:0]  test_in;
  logic [$clog2(WIDTH)-1:0] test_out;
  logic              test_valid;


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
      .WIDTH(WIDTH)
  ) u_DESIGN (
      .in(test_in),
      .out(test_out),
      .valid(test_valid)
  );

  initial begin
    // Test case 1: All zeros
    test_in = 0;
    #10;
    $display("Input: %b, Output: %d, Valid: %b", test_in, test_out, test_valid);
    assert(test_out == 0 && test_valid == 0) else $error("Test Case 1 Failed!");

    // Test case 2: Single bit set (MSB)
    test_in = 8'b10000000;
    #10;
    $display("Input: %b, Output: %d, Valid: %b", test_in, test_out, test_valid);
    assert(test_out == 7 && test_valid == 1) else $error("Test Case 2 Failed!");

    // Test case 3: Single bit set (LSB)
    test_in = 8'b00000001;
    #10;
    $display("Input: %b, Output: %d, Valid: %b", test_in, test_out, test_valid);
    assert(test_out == 0 && test_valid == 1) else $error("Test Case 3 Failed!");

    // Test case 4: Multiple bits set
    test_in = 8'b11010100;
    #10;
    $display("Input: %b, Output: %d, Valid: %b", test_in, test_out, test_valid);
    assert(test_out == 7 && test_valid == 1) else $error("Test Case 4 Failed!");

    // Test case 5: Consecutive bits set
    test_in = 8'b00011100;
    #10;
    $display("Input: %b, Output: %d, Valid: %b", test_in, test_out, test_valid);
    assert(test_out == 5 && test_valid == 1) else $error("Test Case 5 Failed!");

    // Test case 6: Another set of multiple bits
    test_in = 8'b01010101;
    #10;
    $display("Input: %b, Output: %d, Valid: %b", test_in, test_out, test_valid);
    assert(test_out == 6 && test_valid == 1) else $error("Test Case 6 Failed!");

    // Test case 7: Different WIDTH (4 bits)
    #10;
    $display("Testing with WIDTH = 4 (Example of Parameterization)");
    priority_encoder #(
        .WIDTH(4)
    ) uut4 (
        .in(test_in[3:0]),
        .out(test_out),
        .valid(test_valid)
    );
    test_in[3:0] = 4'b1010;
    #10;
    $display("Input (4 bits): %b, Output: %d, Valid: %b", test_in[3:0], test_out, test_valid);
    assert(test_out == 3 && test_valid == 1) else $error("Test Case 7 Failed!");

    $finish;
  end

endmodule
