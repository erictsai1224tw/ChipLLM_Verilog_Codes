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

parameter DATA_WIDTH = 8;

  logic [DATA_WIDTH-1:0] i_data;
  logic [clog2(DATA_WIDTH)-1:0] o_encoded;
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


    
DESIGN #(
    .DATA_WIDTH(DATA_WIDTH)
  ) u_DESIGN (
    .i_data(i_data),
    .o_encoded(o_encoded),
    .o_valid(o_valid)
  );

  // Clock generation (not strictly necessary for combinational logic, but good practice)
  logic clk = 0;
  always #5 clk = ~clk; // 10 time unit period

  // Test vectors
  initial begin
    // Initialize inputs
    i_data = 0;

    // Test cases
    $display("Running tests for DATA_WIDTH = %0d", DATA_WIDTH);
    $monitor("Time=%0t, i_data=%b, o_encoded=%0d, o_valid=%b", $time, i_data, o_encoded, o_valid);

    #1 i_data = 8'b00000000;  // No '1's
    #1 i_data = 8'b00000001;  // LSB is '1'
    #1 i_data = 8'b00000010;  // 2nd bit is '1'
    #1 i_data = 8'b00000100;  // 3rd bit is '1'
    #1 i_data = 8'b00001000;  // 4th bit is '1'
    #1 i_data = 8'b00010000;  // 5th bit is '1'
    #1 i_data = 8'b00100000;  // 6th bit is '1'
    #1 i_data = 8'b01000000;  // 7th bit is '1'
    #1 i_data = 8'b10000000;  // MSB is '1'
    #1 i_data = 8'b11111111;  // All '1's
    #1 i_data = 8'b00001001;  // Multiple '1's - verify highest priority is chosen
    #1 i_data = 8'b10010001;  // More multiple '1's
    #1 i_data = 8'b10101010;  // Alternating
    #1 i_data = 8'b01010101;  // Alternating inverse

    //Test with DATA_WIDTH = 16
    $display("Changing DATA_WIDTH to 16");
    $set_parameter("priority_encoder_tb.u_DESIGN.DATA_WIDTH", 16);
    #1 i_data = 16'b0000000000000000;
    #1 i_data = 16'b1000000000000000; //MSB

    #1 $finish;
  end

  // Calculate log2 of DATA_WIDTH for encoding width
  function integer clog2;
    input integer depth;
    integer i;
    begin
      i = 0;
      while (depth > (1 << i)) begin
        i = i + 1;
      end
      clog2 = i;
    end
  endfunction

endmodule


