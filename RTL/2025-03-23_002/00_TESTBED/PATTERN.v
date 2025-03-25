`define CYCLE_TIME 10.0

// `include "../00_TESTBED/pseudo_DRAM.v"
module PATTERN(
  input o_grant,
  input o_valid,
  output i_req
);

  parameter WIDTH = 8;

  logic [WIDTH-1:0] i_req;
  logic [$clog2(WIDTH)-1:0] o_grant;
  logic o_valid;

  initial begin
    // Initialize signals
    i_req = 0;

    // Test Cases
    $display("Running test cases...");

    // Test case 1: No request asserted
    i_req = 0;
    #10;
    $display("Test Case 1: i_req = %b, o_grant = %d, o_valid = %b", i_req, o_grant, o_valid);
    assert (o_grant == 0 && o_valid == 0) else $error("Test Case 1 failed!");

    // Test case 2: Single request asserted (MSB)
    i_req = 8'b10000000;
    #10;
    $display("Test Case 2: i_req = %b, o_grant = %d, o_valid = %b", i_req, o_grant, o_valid);
    assert (o_grant == 7 && o_valid == 1) else $error("Test Case 2 failed!");

    // Test case 3: Single request asserted (LSB)
    i_req = 8'b00000001;
    #10;
    $display("Test Case 3: i_req = %b, o_grant = %d, o_valid = %b", i_req, o_grant, o_valid);
    assert (o_grant == 0 && o_valid == 1) else $error("Test Case 3 failed!");

    // Test case 4: Multiple requests asserted (highest priority should win)
    i_req = 8'b10010101;
    #10;
    $display("Test Case 4: i_req = %b, o_grant = %d, o_valid = %b", i_req, o_grant, o_valid);
    assert (o_grant == 7 && o_valid == 1) else $error("Test Case 4 failed!");

    // Test case 5: All requests asserted
    i_req = 8'b11111111;
    #10;
    $display("Test Case 5: i_req = %b, o_grant = %d, o_valid = %b", i_req, o_grant, o_valid);
    assert (o_grant == 7 && o_valid == 1) else $error("Test Case 5 failed!");

    // Test case 6: Change in request while another request is still present.
    i_req = 8'b01000000;
    #10;
    $display("Test Case 6: i_req = %b, o_grant = %d, o_valid = %b", i_req, o_grant, o_valid);
    assert (o_grant == 6 && o_valid == 1) else $error("Test Case 6 (setup) failed!");
    i_req = 8'b10000000;
    #10;
    $display("Test Case 6 (Transition): i_req = %b, o_grant = %d, o_valid = %b", i_req, o_grant, o_valid);
    assert (o_grant == 7 && o_valid == 1) else $error("Test Case 6 (Transition) failed!");

    // Test case 7:  A different bit width
    // i_req = 4'b0010;
    // WIDTH = 4;  // Re-assigning this does nothing; parameter is fixed at instantiation.
                  //  This would require a separate instantiation of the priority encoder for this width.
                  //  For example:
                  // priority_encoder #(.WIDTH(4)) uut2 (
                  //  .i_req(i_req[3:0]),  // Note the slicing here.
                  // .o_grant(o_grant_4bit),
                  // .o_valid(o_valid_4bit)
                  //);
                  // However, for simplicity and clarity, this example re-uses the existing module
                  // and slices the MSBs.  This is *not* proper testing, but is simplified.
    // #10;
    // $display("Test Case 7 (WIDTH=4): i_req = %b, o_grant = %d, o_valid = %b", i_req[3:0], o_grant, o_valid);
    // assert (o_grant == 1 && o_valid == 1) else $error("Test Case 7 failed!");


    $display("Testbench finished.");
    $finish;
  end

endmodule