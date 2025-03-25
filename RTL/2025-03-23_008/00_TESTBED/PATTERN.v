`define CYCLE_TIME 10.0

// `include "../00_TESTBED/pseudo_DRAM.v"

module PATTERN#(
    parameter DATA_LANE_COUNT = 4,
    parameter DATA_WIDTH = 8 // Bits per pixel component (e.g., 8 for grayscale, 8 per color)
)(
  output reg clk, rst, enable,
  output reg [DATA_LANE_COUNT-1:0] d_p,
  output reg [DATA_LANE_COUNT-1:0] d_n,
  output reg clk_p, clk_n,
  input [DATA_LANE_COUNT*DATA_WIDTH-1:0] data_out,
  input data_valid, frame_start, frame_end, error_flag
);

  // // Parameters
  // parameter DATA_LANE_COUNT = 4;
  // parameter DATA_WIDTH = 8;

  // Signals

  // Instantiate the MIPI CSI-2 receiver
  // mipi_csi2_receiver #(
  //   .DATA_LANE_COUNT(DATA_LANE_COUNT),
  //   .DATA_WIDTH(DATA_WIDTH)
  // ) uut (
  //   .clk(clk),
  //   .rst(rst),
  //   .enable(enable),
  //   .d_p(d_p),
  //   .d_n(d_n),
  //   .clk_p(clk_p),
  //   .clk_n(clk_n),
  //   .data_out(data_out),
  //   .data_valid(data_valid),
  //   .frame_start(frame_start),
  //   .frame_end(frame_end),
  //   .error_flag(error_flag)
  // );

  // Clock Generation
  always #5 clk = ~clk; // 100 MHz clock

  // Testbench Stimulus
  initial begin
    clk = 0;
    rst = 1;
    enable = 0;

    // Reset sequence
    #10 rst = 0;
    #20 enable = 1;

    // Simulate CSI-2 Data Transmission
    // Start of Frame (SoF)
    d_p = {DATA_LANE_COUNT{1'b1}};
    d_n = {DATA_LANE_COUNT{1'b0}};
    clk_p = 1;
    clk_n = 0;
    #10; //Wait clock cycles to simulate data transmission

    // Header simulation
    d_p = {DATA_LANE_COUNT{1'b0}};
    d_n = {DATA_LANE_COUNT{1'b1}};
    #10;

    //Data simulation, lane0 high, rest low.
    d_p[0] = 1'b1;
    d_n[0] = 1'b0;
    for (int i = 1; i < DATA_LANE_COUNT; i++) begin
      d_p[i] = 1'b0;
      d_n[i] = 1'b1;
    end
    #10;

     //Data simulation, lane1 high, rest low.
    d_p[1] = 1'b1;
    d_n[1] = 1'b0;
    d_p[0] = 1'b0;
    d_n[0] = 1'b1;
    for (int i = 2; i < DATA_LANE_COUNT; i++) begin
      d_p[i] = 1'b0;
      d_n[i] = 1'b1;
    end
    #10;

    // End of Frame (EoF) - Simplification for demonstration
    d_p = {DATA_LANE_COUNT{1'b0}};
    d_n = {DATA_LANE_COUNT{1'b1}};
    #10;

    // Disable the receiver
    enable = 0;
    #10;

    $finish;
  end

  // Monitor the outputs
  initial begin
    $monitor("Time=%0t, data_out=%h, data_valid=%b, frame_start=%b, frame_end=%b, error_flag=%b",
             $time, data_out, data_valid, frame_start, frame_end, error_flag);
  end

endmodule