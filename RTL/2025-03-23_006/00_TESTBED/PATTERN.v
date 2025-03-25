`define CYCLE_TIME 10.0

// `include "../00_TESTBED/pseudo_DRAM.v"

module PATTERN(
    output clk,
    output rst_n,

    output rx_data_valid,
    output rx_data,
    input tx_en,
    input tx_data,

    output host_tx_req,
    output host_tx_data,
    input host_rx_rdy,
    input host_rx_data

    
);
  reg clk;
  reg rst_n;

  // PHY Interface
  reg rx_data_valid;
  reg [7:0] rx_data;
  wire tx_en;
  wire [7:0] tx_data;

  // Host Interface
  reg host_tx_req;
  reg [7:0] host_tx_data;
  wire host_rx_rdy;
  wire [7:0] host_rx_data;
  // Instantiate the MAC Controller
  // gige_mac_controller mac_inst (
  //   .clk(clk),
  //   .rst_n(rst_n),
  //   .rx_data_valid(rx_data_valid),
  //   .rx_data(rx_data),
  //   .tx_en(tx_en),
  //   .tx_data(tx_data),
  //   .host_tx_req(host_tx_req),
  //   .host_tx_data(host_tx_data),
  //   .host_rx_rdy(host_rx_rdy),
  //   .host_rx_data(host_rx_data)
  // );

  // Clock Generation
  // initial begin
  //   clk = 0;
  //   forever #5 clk = ~clk; // 100 MHz clock (period = 10 ns)
  // end


  // // Test Sequence
  // initial begin
  //   // Reset
  //   rst_n = 0;
  //   #20 rst_n = 1;


  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 1;

    //----------------------------------------------------------------------
    // Transmission Test
    //----------------------------------------------------------------------
    #10 host_tx_req = 1;
    host_tx_data = 8'h01;
    #10 host_tx_req = 1;
    host_tx_data = 8'h02;
    #10 host_tx_req = 1;
    host_tx_data = 8'h03;
    #10 host_tx_req = 0; // Stop transmission request

    #50; // Wait for transmission to complete

    //----------------------------------------------------------------------
    // Reception Test (Simulated PHY input)
    //----------------------------------------------------------------------
    rx_data_valid = 0;
    rx_data = 0;
    #20;
    // Simulate Preamble (7 bytes)
    rx_data_valid = 1;
    rx_data = 8'h55; #10;
    rx_data = 8'h55; #10;
    rx_data = 8'h55; #10;
    rx_data = 8'h55; #10;
    rx_data = 8'h55; #10;
    rx_data = 8'h55; #10;
    rx_data = 8'h55; #10;

    // Simulate SFD
    rx_data = 8'hD5; #10;

    // Simulate Destination MAC Address (Set to MAC_ADDR in the controller)
    rx_data = 8'h00; #10;
    rx_data = 8'h00; #10;
    rx_data = 8'h00; #10;
    rx_data = 8'hAA; #10;
    rx_data = 8'hBB; #10;
    rx_data = 8'hCC; #10;

    // Simulate Source MAC Address (Dummy Values)
    rx_data = 8'h11; #10;
    rx_data = 8'h22; #10;
    rx_data = 8'h33; #10;
    rx_data = 8'h44; #10;
    rx_data = 8'h55; #10;
    rx_data = 8'h66; #10;

    // Simulate EtherType
    rx_data = 8'h08; #10;
    rx_data = 8'h00; #10;

    // Simulate Data (Send a single byte)
    rx_data = 8'h77; #10;
    rx_data_valid = 0;
    // Simulate FCS Placeholder (Dummy Value - In a real scenario, it needs accurate calculations)

    #50; // Wait for reception to complete

    // Finish simulation
    #100 $finish;
  end

  // Monitoring and Assertions (Simple)
  always @(posedge clk) begin
    if (host_rx_rdy) begin
      $display("Received data: %h", host_rx_data);
    end

    if (tx_en) begin
        $display("Transmitting data: %h", tx_data);
    end
  end

endmodule