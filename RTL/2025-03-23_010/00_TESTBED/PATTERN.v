`define CYCLE_TIME 10.0

// `include "../00_TESTBED/pseudo_DRAM.v"

module PATTERN(
  output reg clk,
  output reg rst,
  output reg start,
  output reg [64*1024*8-1:0] bootloader_data,
  output reg [16*1024*1024*8-1:0] os_data,
  input boot_successful,
  input boot_failed
);

  // Parameters (match the module parameters)
  parameter HASH_ALGORITHM = "SHA256";
  parameter KEY_SIZE = 2048;
  parameter CERTIFICATE_SIZE = 1024;
  parameter BOOTLOADER_SIZE = 64 * 1024; //64KB
  parameter OS_SIZE = 16 * 1024 * 1024; //16MB

  // Signals

  // Instantiate the secure_boot_module


  // Clock generation
  always #5 clk = ~clk;

  // Test sequence
  initial begin
    clk = 0;
    rst = 1;
    start = 0;

    // Reset
    #10 rst = 0;

    // Test Case 1: Successful Boot
    #10 start = 1;
    bootloader_data = $random; // Simulate valid bootloader data. In reality we would use a pre-generated valid bootloader
    os_data         = $random; // Simulate valid OS data.  In reality we would use a pre-generated valid OS
    #10 start = 0;
    #100; // Wait for Verification to complete.  Increase if necessary.

    if (boot_successful) $display("Test Case 1: Successful Boot - PASSED");
    else $display("Test Case 1: Successful Boot - FAILED");

    // Test Case 2: Failed Boot - Incorrect Bootloader Data
    #10 rst = 1;
    #10 rst = 0;
    #10 start = 1;
    bootloader_data = ~bootloader_data;  // Simulate corrupted bootloader
    os_data         = $random;
    #10 start = 0;
    #100; // Wait for verification

    if (boot_failed) $display("Test Case 2: Failed Boot (Corrupted Bootloader) - PASSED");
    else $display("Test Case 2: Failed Boot (Corrupted Bootloader) - FAILED");

    // Test Case 3: Failed Boot - Incorrect OS Data
    #10 rst = 1;
    #10 rst = 0;
    #10 start = 1;
    bootloader_data = $random;
    os_data = ~os_data; // Simulate corrupted OS data
    #10 start = 0;
    #100; // Wait for verification

    if (boot_failed) $display("Test Case 3: Failed Boot (Corrupted OS) - PASSED");
    else $display("Test Case 3: Failed Boot (Corrupted OS) - FAILED");


    // Add more test cases as needed (e.g., timing variations, different data patterns)

    $finish;
  end

endmodule