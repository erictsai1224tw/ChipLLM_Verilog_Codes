`define CYCLE_TIME 10.0

// `include "../00_TESTBED/pseudo_DRAM.v"


module PATTERN(
  output clk,
  output rst,

  // Master interfaces (example: AXI4 Write)
  output awaddr_m,
  output wdata_m,
  output wstrb_m,
  output awvalid_m,
  input awready_m,
  output wvalid_m,
  input wready_m,
  output bready_m,
  input bvalid_m,
  input bresp_m,

  // Slave interfaces (example: AXI4 Write)
  input  awaddr_s,
  input  wdata_s,
  input wstrb_s,
  input awvalid_s,
  output  awready_s,
  input wvalid_s,
  output  wready_s,
  input bready_s,
  output bvalid_s,
  output bresp_s
);

  // Parameters
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 64;
  parameter NUM_MASTERS = 2;
  parameter NUM_SLAVES = 2;

  // Clock and Reset
  logic clk;
  logic rst;

  // Master signals
  logic [NUM_MASTERS-1:0][ADDR_WIDTH-1:0] awaddr_m;
  logic [NUM_MASTERS-1:0][DATA_WIDTH-1:0] wdata_m;
  logic [NUM_MASTERS-1:0][DATA_WIDTH/8-1:0] wstrb_m;
  logic [NUM_MASTERS-1:0] awvalid_m;
  logic [NUM_MASTERS-1:0] awready_m;
  logic [NUM_MASTERS-1:0] wvalid_m;
  logic [NUM_MASTERS-1:0] wready_m;
  logic [NUM_MASTERS-1:0] bready_m;
  logic [NUM_MASTERS-1:0] bvalid_m;
  logic [NUM_MASTERS-1:0][2:0] bresp_m;

  // Slave signals
  logic [NUM_SLAVES-1:0][ADDR_WIDTH-1:0] awaddr_s;
  logic [NUM_SLAVES-1:0][DATA_WIDTH-1:0] wdata_s;
  logic [NUM_SLAVES-1:0][DATA_WIDTH/8-1:0] wstrb_s;
  logic [NUM_SLAVES-1:0] awvalid_s;
  logic [NUM_SLAVES-1:0] awready_s;
  logic [NUM_SLAVES-1:0] wvalid_s;
  logic [NUM_SLAVES-1:0] wready_s;
  logic [NUM_SLAVES-1:0] bready_s;
  logic [NUM_SLAVES-1:0] bvalid_s;
  logic [NUM_SLAVES-1:0][2:0] bresp_s;

  // Instantiate the interconnect
  // axi_interconnect #(
  //   .ADDR_WIDTH(ADDR_WIDTH),
  //   .DATA_WIDTH(DATA_WIDTH),
  //   .NUM_MASTERS(NUM_MASTERS),
  //   .NUM_SLAVES(NUM_SLAVES)
  // ) u_axi_interconnect (
  //   .clk(clk),
  //   .rst(rst),
  //   .awaddr_m(awaddr_m),
  //   .wdata_m(wdata_m),
  //   .wstrb_m(wstrb_m),
  //   .awvalid_m(awvalid_m),
  //   .awready_m(awready_m),
  //   .wvalid_m(wvalid_m),
  //   .wready_m(wready_m),
  //   .bready_m(bready_m),
  //   .bvalid_m(bvalid_m),
  //   .bresp_m(bresp_m),
  //   .awaddr_s(awaddr_s),
  //   .wdata_s(wdata_s),
  //   .wstrb_s(wstrb_s),
  //   .awvalid_s(awvalid_s),
  //   .awready_s(awready_s),
  //   .wvalid_s(wvalid_s),
  //   .wready_s(wready_s),
  //   .bready_s(bready_s),
  //   .bvalid_s(bvalid_s),
  //   .bresp_s(bresp_s)
  // );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;

    // Initialize signals
    awaddr_m = '0;
    wdata_m  = '0;
    wstrb_m  = '0;
    awvalid_m = '0;
    wvalid_m  = '0;
    bready_m  = '0;
    bresp_m   = '0;

    #10 rst = 0;

    // Test Case 1: Master 0 writes to Slave 0
    awaddr_m[0] = 32'h00000010; // Within Slave 0's range
    wdata_m[0]  = 64'h1234567890abcdef;
    wstrb_m[0]  = 8'hff; // Write all bytes
    awvalid_m[0] = 1;
    wvalid_m[0]  = 1;
    bready_m[0]  = 1;
    #10 awvalid_m[0] = 0;
    #10 wvalid_m[0] = 0;
    #10 bready_m[0] = 0;

    // Test Case 2: Master 1 writes to Slave 1
    awaddr_m[1] = 32'h00010020; // Within Slave 1's range
    wdata_m[1]  = 64'hfedcba0987654321;
    wstrb_m[1]  = 8'hff; // Write all bytes
    awvalid_m[1] = 1;
    wvalid_m[1]  = 1;
    bready_m[1]  = 1;
    #10 awvalid_m[1] = 0;
    #10 wvalid_m[1] = 0;
    #10 bready_m[1] = 0;

    // Test Case 3: Masters 0 and 1 compete for Slave 0
    awaddr_m[0] = 32'h00000030;
    wdata_m[0]  = 64'h0011223344556677;
    wstrb_m[0]  = 8'hff;
    awvalid_m[0] = 1;
    wvalid_m[0]  = 1;
    bready_m[0]  = 1;

    awaddr_m[1] = 32'h00000040;
    wdata_m[1]  = 64'h7766554433221100;
    wstrb_m[1]  = 8'hff;
    awvalid_m[1] = 1;
    wvalid_m[1]  = 1;
    bready_m[1]  = 1;

    #20 awvalid_m[0] = 0;
    #20 wvalid_m[0] = 0;
    #20 bready_m[0] = 0;
    #20 awvalid_m[1] = 0;
    #20 wvalid_m[1] = 0;
    #20 bready_m[1] = 0;

    #100 $finish;
  end

  // initial begin
  //   $dumpfile("axi_interconnect.vcd");
  //   $dumpvars(0, axi_interconnect_tb);
  // end

endmodule