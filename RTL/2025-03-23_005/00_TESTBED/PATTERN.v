module PATTERN();

  reg clk;
  reg rst;
  reg enable;
  reg [127:0] data_in;
  reg [127:0] key_in;
  reg operation_mode;

  wire [127:0] data_out;
  wire valid_out;
  wire busy;

  // aes_128 dut (
  //   .clk(clk),
  //   .rst(rst),
  //   .enable(enable),
  //   .data_in(data_in),
  //   .key_in(key_in),
  //   .operation_mode(operation_mode),
  //   .data_out(data_out),
  //   .valid_out(valid_out),
  //   .busy(busy)
  // );

  // Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period
  end

  // Test Sequence
  initial begin
    rst = 1;
    enable = 0;
    operation_mode = 0; // Encryption by default
    data_in = 128'h3243F6A8885A308D313198A2E0370734;
    key_in = 128'h2B7E151628AED2A6ABF7158809CF4F3C;

    #10 rst = 0;
    #20 enable = 1;
    #120 enable = 0;

    #100 operation_mode = 1; // Decryption Test
    #10 enable = 1;
    #120 enable = 0;

    #50 $finish;
  end

  initial begin
    $dumpfile("aes_128_tb.vcd");
    $dumpvars(0, aes_128_tb);
  end

endmodule