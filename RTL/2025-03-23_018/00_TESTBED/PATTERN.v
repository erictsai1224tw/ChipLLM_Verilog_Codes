`define CYCLE_TIME 10.0

// `include "../00_TESTBED/pseudo_DRAM.v"

module PATTERN(
    output i_data,
    input o_encoded,
    input o_valid
);

  // Parameters
  parameter WIDTH = 8;

  // Signals
  logic [WIDTH-1:0] i_data;
  logic [$clog2(WIDTH)-1:0] o_encoded;
  logic o_valid;

  // Instantiate the priority encoder
//   priority_encoder #(
//     .WIDTH(WIDTH)
//   ) uut (
//     .i_data(i_data),
//     .o_encoded(o_encoded),
//     .o_valid(o_valid)
//   );

  initial begin
    // Initialize signals
    i_data = 0;

    // Test Cases

    // Test Case 1: All inputs are 0
    i_data = 0;
    #10;
    $display("Test Case 1: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
    assert (o_valid == 0) else $error("Test Case 1 Failed: o_valid");
    assert (o_encoded == 0) else $error("Test Case 1 Failed: o_encoded");

    // Test Case 2: Single input high (highest priority)
    i_data = 2**(WIDTH-1);  // Highest priority input (MSB)
    #10;
    $display("Test Case 2: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
    assert (o_valid == 1) else $error("Test Case 2 Failed: o_valid");
    assert (o_encoded == WIDTH-1) else $error("Test Case 2 Failed: o_encoded");


    // Test Case 3: Single input high (lowest priority)
    i_data = 1;  // Lowest priority input (LSB)
    #10;
    $display("Test Case 3: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
    assert (o_valid == 1) else $error("Test Case 3 Failed: o_valid");
    assert (o_encoded == 0) else $error("Test Case 3 Failed: o_encoded");

    // Test Case 4: Multiple inputs high (highest priority should be selected)
    i_data = (2**(WIDTH-1)) + 1;  // MSB and LSB are high
    #10;
    $display("Test Case 4: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
    assert (o_valid == 1) else $error("Test Case 4 Failed: o_valid");
    assert (o_encoded == WIDTH-1) else $error("Test Case 4 Failed: o_encoded");

   // Test Case 5: Random input
    i_data = 16'h0A5A;
    #10;
    $display("Test Case 5: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
    assert (o_valid == 1) else $error("Test Case 5 Failed: o_valid");
    assert (o_encoded == 11) else $error("Test Case 5 Failed: o_encoded");

    // Test Case 6: Random input (with different width)
    i_data = 8'h81;
    #10;
    $display("Test Case 6: i_data = %b, o_encoded = %d, o_valid = %b", i_data, o_encoded, o_valid);
    assert (o_valid == 1) else $error("Test Case 6 Failed: o_valid");
    assert (o_encoded == 7) else $error("Test Case 6 Failed: o_encoded");

    // Add more test cases as needed

    $finish;
  end

endmodule
