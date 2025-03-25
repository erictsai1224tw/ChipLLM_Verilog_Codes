`define CYCLE_TIME 10.0

// `include "../00_TESTBED/pseudo_DRAM.v"

// module PATTERN(
//     output i_data,
//     input o_encoded,
//     input o_valid
// );

//   // Parameters
//   parameter WIDTH = 8;

//   // Signals
//   logic [WIDTH-1:0] i_data;
//   logic [$clog2(WIDTH)-1:0] o_encoded;
//   logic o_valid;

//   // Instantiate the priority encoder
// //   priority_encoder #(
// //     .WIDTH(WIDTH)
// //   ) uut (
// //     .i_data(i_data),
// //     .o_encoded(o_encoded),
// //     .o_valid(o_valid)
// //   );

//   initial begin
//     // Initialize signals
//     i_data = 0;

//     // Test Cases

//     // Test Case 1: All inputs are 0
//     i_data = 0;
//     #10;
//     $display("Test Case 1: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
//     assert (o_valid == 0) else $error("Test Case 1 Failed: o_valid");
//     assert (o_encoded == 0) else $error("Test Case 1 Failed: o_encoded");

//     // Test Case 2: Single input high (highest priority)
//     i_data = 2**(WIDTH-1);  // Highest priority input (MSB)
//     #10;
//     $display("Test Case 2: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
//     assert (o_valid == 1) else $error("Test Case 2 Failed: o_valid");
//     assert (o_encoded == WIDTH-1) else $error("Test Case 2 Failed: o_encoded");


//     // Test Case 3: Single input high (lowest priority)
//     i_data = 1;  // Lowest priority input (LSB)
//     #10;
//     $display("Test Case 3: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
//     assert (o_valid == 1) else $error("Test Case 3 Failed: o_valid");
//     assert (o_encoded == 0) else $error("Test Case 3 Failed: o_encoded");

//     // Test Case 4: Multiple inputs high (highest priority should be selected)
//     i_data = (2**(WIDTH-1)) + 1;  // MSB and LSB are high
//     #10;
//     $display("Test Case 4: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
//     assert (o_valid == 1) else $error("Test Case 4 Failed: o_valid");
//     assert (o_encoded == WIDTH-1) else $error("Test Case 4 Failed: o_encoded");

//    // Test Case 5: Random input
//     i_data = 16'h0A5A;
//     #10;
//     $display("Test Case 5: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
//     assert (o_valid == 1) else $error("Test Case 5 Failed: o_valid");
//     assert (o_encoded == 11) else $error("Test Case 5 Failed: o_encoded");

//     // Test Case 6: Random input (with different width)
//     i_data = 8'h81;
//     #10;
//     $display("Test Case 6: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
//     assert (o_valid == 1) else $error("Test Case 6 Failed: o_valid");
//     assert (o_encoded == 7) else $error("Test Case 6 Failed: o_encoded");

//     // Add more test cases as needed

//     $finish;
//   end

// endmodule


module PATTERN(
  output  i_data,  // Input data vector
  input  o_encoded, // Encoded output (log2(WIDTH) bits)
  input o_valid             // Indicates that a valid input is present
);

  // Parameters
  parameter WIDTH = 8;

  // Signals
  logic [WIDTH-1:0] i_data;
  logic [$clog2(WIDTH):0] o_encoded;
  logic o_valid;

  // Instantiate the priority encoder
  // priority_encoder #(
  //   .WIDTH(WIDTH)
  // ) u_priority_encoder (
  //   .i_data(i_data),
  //   .o_encoded(o_encoded),
  //   .o_valid(o_valid)
  // );

  // Clock (not strictly needed for combinational logic, but good practice)
  // logic clk;
  // always #5 clk = ~clk;  // 10ns period

  // initial begin
  //   clk = 0;

  //   // Test Cases

  //   // 1. No input asserted
  //   i_data = 0;
  //   #10;
  //   $display("Test 1: No input - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
  //   assert (o_encoded == 0 && o_valid == 0) else $error("Test 1 Failed!");

  //   // 2. Single input asserted (LSB)
  //   i_data = 1;
  //   #10;
  //   $display("Test 2: LSB asserted - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
  //   assert (o_encoded == 0 && o_valid == 1) else $error("Test 2 Failed!");

  //   // 3. Single input asserted (MSB)
  //   i_data = 1 << (WIDTH - 1);
  //   #10;
  //   $display("Test 3: MSB asserted - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
  //   assert (o_encoded == WIDTH - 1 && o_valid == 1) else $error("Test 3 Failed!");

  //   // 4. Multiple inputs asserted
  //   i_data = 'b10101010;
  //   #10;
  //   $display("Test 4: Multiple inputs - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
  //   assert (o_encoded == 7 && o_valid == 1) else $error("Test 4 Failed!");

  //   // 5. All inputs asserted
  //   i_data = ~0; // All 1s
  //   #10;
  //   $display("Test 5: All inputs asserted - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
  //   assert (o_encoded == WIDTH - 1 && o_valid == 1) else $error("Test 5 Failed!");

  //   // 6. Change the WIDTH parameter
  //   $display("Changing WIDTH to 4");
  //   defparam u_DESIGN.WIDTH = 4;
  //   #10;

  //   // 7. Test with new WIDTH = 4. Single input asserted (MSB)
  //   i_data = 1 << 3;
  //   #10;
  //   $display("Test 7: MSB asserted (WIDTH=4) - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
  //   assert (o_encoded == 3 && o_valid == 1) else $error("Test 7 Failed!");

  //   // 8. Test with new WIDTH = 4. Multiple inputs asserted
  //   i_data = 'b1010;
  //   #10;
  //   $display("Test 8: Multiple inputs (WIDTH=4) - i_data=%b, o_encoded=%d, o_valid=%b", i_data, o_encoded, o_valid);
  //   assert (o_encoded == 3 && o_valid == 1) else $error("Test 8 Failed!");


  //   $finish;
  // end

endmodule
