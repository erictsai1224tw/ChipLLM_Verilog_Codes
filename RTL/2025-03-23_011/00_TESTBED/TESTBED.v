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


    
// PATTERN u_PATTERN(
//     // Inputs
//     .i_data(out_data),
//     // Outputs
//     .o_encoded(o_encoded),
//     .o_valid(o_valid)
// );

DESIGN  #(
    .WIDTH(WIDTH)
)  u_DESIGN(
    // Inputs
    .i_data(out_data),
    // Outputs
    .o_encoded(o_encoded),
    .o_valid(o_valid)
);

logic clk;
always #5 clk = ~clk;  // 10ns period

  initial begin
    clk = 0;

    // Test Cases

    // 1. No input asserted
    i_data = 0;
    #10;
    $display("Test 1: No input - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
    assert (o_encoded == 0 && o_valid == 0) else $error("Test 1 Failed!");

    // 2. Single input asserted (LSB)
    i_data = 1;
    #10;
    $display("Test 2: LSB asserted - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
    assert (o_encoded == 0 && o_valid == 1) else $error("Test 2 Failed!");

    // 3. Single input asserted (MSB)
    i_data = 1 << (WIDTH - 1);
    #10;
    $display("Test 3: MSB asserted - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
    assert (o_encoded == WIDTH - 1 && o_valid == 1) else $error("Test 3 Failed!");

    // 4. Multiple inputs asserted
    i_data = 'b10101010;
    #10;
    $display("Test 4: Multiple inputs - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
    assert (o_encoded == 7 && o_valid == 1) else $error("Test 4 Failed!");

    // 5. All inputs asserted
    i_data = ~0; // All 1s
    #10;
    $display("Test 5: All inputs asserted - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
    assert (o_encoded == WIDTH - 1 && o_valid == 1) else $error("Test 5 Failed!");

    // 6. Change the WIDTH parameter
    $display("Changing WIDTH to 4");
    defparam u_DESIGN.WIDTH = 4;
    #10;

    // 7. Test with new WIDTH = 4. Single input asserted (MSB)
    i_data = 1 << 3;
    #10;
    $display("Test 7: MSB asserted (WIDTH=4) - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
    assert (o_encoded == 3 && o_valid == 1) else $error("Test 7 Failed!");

    // 8. Test with new WIDTH = 4. Multiple inputs asserted
    i_data = 'b1010;
    #10;
    $display("Test 8: Multiple inputs (WIDTH=4) - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
    assert (o_encoded == 3 && o_valid == 1) else $error("Test 8 Failed!");

    $display("Simulation Finish");
    $finish;
  end

endmodule
