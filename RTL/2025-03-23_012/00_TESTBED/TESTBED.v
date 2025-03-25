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

parameter WIDTH = 8;

  logic [WIDTH-1:0] test_in;
  logic [$clog2(WIDTH)-1:0] test_out;
  logic test_valid;


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

  DESIGN #(
    .WIDTH(WIDTH)
  ) u_DESIGN (
    .in(test_in),
    .out(test_out),
    .valid(test_valid)
  );

  initial begin
    // Test Case 1: No input asserted
    test_in = 0;
    #10;
    $display("Test Case 1: in=%b, out=%d, valid=%b", test_in, test_out, test_valid);
    assert (test_out == 0 && test_valid == 0) else $error("Test Case 1 Failed!");

    // Test Case 2: Single input asserted (MSB)
    test_in = (1 << (WIDTH-1));
    #10;
    $display("Test Case 2: in=%b, out=%d, valid=%b", test_in, test_out, test_valid);
    assert (test_out == WIDTH-1 && test_valid == 1) else $error("Test Case 2 Failed!");

    // Test Case 3: Single input asserted (LSB)
    test_in = 1;
    #10;
    $display("Test Case 3: in=%b, out=%d, valid=%b", test_in, test_out, test_valid);
    assert (test_out == 0 && test_valid == 1) else $error("Test Case 3 Failed!");

    // Test Case 4: Multiple inputs asserted (MSB has priority)
    test_in = (1 << (WIDTH-1)) | 1;
    #10;
    $display("Test Case 4: in=%b, out=%d, valid=%b", test_in, test_out, test_valid);
    assert (test_out == WIDTH-1 && test_valid == 1) else $error("Test Case 4 Failed!");

    // Test Case 5: Multiple inputs asserted (Middle has priority)
    test_in = (1 << (WIDTH/2)) | 1;
    #10;
    $display("Test Case 5: in=%b, out=%d, valid=%b", test_in, test_out, test_valid);
    assert (test_out == WIDTH/2 && test_valid == 1) else $error("Test Case 5 Failed!");

     // Test Case 6: All inputs asserted
    test_in = ~0;
    #10;
    $display("Test Case 6: in=%b, out=%d, valid=%b", test_in, test_out, test_valid);
    assert (test_out == WIDTH-1 && test_valid == 1) else $error("Test Case 6 Failed!");

    $display("good");
    $finish;
  end



endmodule


