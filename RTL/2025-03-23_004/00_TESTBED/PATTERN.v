`define CYCLE_TIME 10.0

// `include "../00_TESTBED/pseudo_DRAM.v"

module PATTERN(output clk,
                output rst,
                output instruction_mem_data_in,
                input data_mem_addr,
                output data_mem_data_in,
                input data_mem_data_out,
                input data_mem_write_enable);

  reg clk;
  reg rst;
  reg [31:0] instruction_mem_data_in;
  wire [31:0] data_mem_addr;
  reg  [31:0] data_mem_data_in;
  wire [31:0] data_mem_data_out;
  wire data_mem_write_enable;

  // riscv_pipeline uut (
  //   .clk(clk),
  //   .rst(rst),
  //   .instruction_mem_data_in(instruction_mem_data_in),
  //   .data_mem_addr(data_mem_addr),
  //   .data_mem_data_in(data_mem_data_in),
  //   .data_mem_data_out(data_mem_data_out),
  //   .data_mem_write_enable(data_mem_write_enable)
  // );

  initial begin
    clk = 0;
    rst = 1;
    instruction_mem_data_in = 32'h0; // Initialize instruction memory data

    #10 rst = 0; // Deassert reset

    // Simulate instruction fetching (replace with more comprehensive memory loading)
    instruction_mem_data_in = 32'h00100093; //addi x1, x0, 1 @ address 0
    #20 instruction_mem_data_in = 32'h00200113; //addi x2, x0, 2 @ address 4
    #20 instruction_mem_data_in = 32'h00300193; //addi x3, x0, 3 @ address 8
    #20 instruction_mem_data_in = 32'h00400213; //addi x4, x0, 4 @ address 12
    #20 instruction_mem_data_in = 32'h00500293; //addi x5, x0, 5 @ address 16

    #100 $finish; // End simulation
  end

  always #5 clk = ~clk; // 10ns clock period

  always @(posedge clk) begin
    // Simulate Data Memory - VERY basic!
    if (data_mem_write_enable) begin
      $display("Write to Memory at addr: %h, data: %h", data_mem_addr, data_mem_data_out);
    end
    data_mem_data_in = 32'h0; // For memory reads (currently not implemented fully)
  end


endmodule
