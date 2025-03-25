module DESIGN (input clk,
              input rst,
              input [31:0] instruction_mem_data_in,
              output reg [31:0] data_mem_addr,
              input [31:0] data_mem_data_in,
              output reg [31:0] data_mem_data_out,
              output reg data_mem_write_enable);

  // --- Pipeline Registers ---
  logic [31:0] if_id_instr;
  logic [31:0] id_ex_instr;
  logic [31:0] id_ex_reg_rs1_data;
  logic [31:0] id_ex_reg_rs2_data;
  logic [31:0] ex_mem_alu_result;
  logic [31:0] mem_wb_data;


  // --- Internal Signals ---
  logic [31:0] pc, next_pc;
  logic [31:0] instr;
  logic [31:0] rs1_data, rs2_data;
  logic [31:0] alu_result;
  logic [31:0] writeback_data;

  // Register File
  reg [31:0] register_file [31:0];

  //Instruction Memory (Simplified - Ideally, a separate module)
  reg [31:0] instruction_memory [0:1023]; // Example: 4KB instruction memory

  // Control Signals (Example - simplified, more signals are needed in a real implementation)
  logic reg_write_enable;
  logic mem_read;
  logic mem_write;
  logic alu_op; // Placeholder - actual ALU operation depends on instruction bits
  logic branch;  // Branch instruction flag

  //Branch target
  logic [31:0] branch_target;


  // --- Instruction Fetch (IF) Stage ---
  always_ff @(posedge clk) begin
    if (rst) begin
      pc <= 32'h0; // Start at address 0
    end else begin
      pc <= next_pc;
    end
  end

  always_comb begin
    next_pc = pc + 4; // Increment PC by 4 (assuming 32-bit instructions)

    //Implement branch logic here.
    if(branch) begin
      next_pc = branch_target;
    end
  end

  assign instr = instruction_mem_data_in;

  always_ff @(posedge clk) begin
    if_id_instr <= instr;
  end


  // --- Instruction Decode (ID) Stage ---
  always_comb begin
    // Decode instruction (Simplified example)
    //Extract opcode, rs1, rs2, rd, immediate
    //...

    //Read from register file
    rs1_data = register_file[if_id_instr[19:15]]; //rs1 address
    rs2_data = register_file[if_id_instr[24:20]]; //rs2 address

    //Immediate Generation (Simplified example)
    //...

    //Control Signal generation (simplified example)
    //reg_write_enable = (opcode == LOAD || opcode == ALU_OP || opcode == ...);
    //...

  end

  always_ff @(posedge clk) begin
    id_ex_instr <= if_id_instr;
    id_ex_reg_rs1_data <= rs1_data;
    id_ex_reg_rs2_data <= rs2_data;
  end



  // --- Execute (EX) Stage ---
  always_comb begin
    //ALU operation (Simplified example)
    case (alu_op)
      //...
      default: alu_result = 32'h0;
    endcase
  end

  always_ff @(posedge clk) begin
    ex_mem_alu_result <= alu_result;
  end



  // --- Memory Access (MEM) Stage ---
  always_comb begin
    //Memory access logic (Simplified example)
    if (mem_read) begin
      //data_mem_data_out = data_memory[ex_mem_alu_result]; //Read from data memory
      data_mem_addr = ex_mem_alu_result;
    end else if(mem_write) begin
      data_mem_addr = ex_mem_alu_result;
      data_mem_data_out = id_ex_reg_rs2_data;
    end else begin
      data_mem_addr = 32'h0;
      data_mem_data_out = 32'h0;
    end
    data_mem_write_enable = mem_write;

  end

  always_ff @(posedge clk) begin
    mem_wb_data <= data_mem_data_in;
  end


  // --- Write Back (WB) Stage ---
  always_comb begin
    //Select writeback data
    //Example: From memory, from ALU, etc.
    writeback_data = mem_wb_data;
  end

  always_ff @(posedge clk) begin
    if (reg_write_enable) begin
      register_file[id_ex_instr[11:7]] <= writeback_data; //Write to register file
    end
  end

  // Example initial memory load:
  initial begin
    // Load a program into instruction memory
    instruction_memory[0] = 32'h00100093; //addi x1, x0, 1
    instruction_memory[4] = 32'h00200113; //addi x2, x0, 2
    instruction_memory[8] = 32'h00300193; //addi x3, x0, 3
    // ... add more instructions as needed
  end

  // Data memory initialization example
  //initial begin
  //  data_memory[0] = 32'hDEADBEEF;
  //end

endmodule