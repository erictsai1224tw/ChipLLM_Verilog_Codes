module DESIGN #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 64,
  parameter NUM_MASTERS = 2,
  parameter NUM_SLAVES = 2
) (
  // Global signals
  input  logic clk,
  input  logic rst,

  // Master interfaces (example: AXI4 Write)
  input  logic [NUM_MASTERS-1:0][ADDR_WIDTH-1:0] awaddr_m,
  input  logic [NUM_MASTERS-1:0][DATA_WIDTH-1:0] wdata_m,
  input  logic [NUM_MASTERS-1:0][DATA_WIDTH/8-1:0] wstrb_m,
  input  logic [NUM_MASTERS-1:0] awvalid_m,
  output logic [NUM_MASTERS-1:0] awready_m,
  input  logic [NUM_MASTERS-1:0] wvalid_m,
  output logic [NUM_MASTERS-1:0] wready_m,
  input  logic [NUM_MASTERS-1:0] bready_m,
  output logic [NUM_MASTERS-1:0] bvalid_m,
  output logic [NUM_MASTERS-1:0][2:0] bresp_m,

  // Slave interfaces (example: AXI4 Write)
  output logic [NUM_SLAVES-1:0][ADDR_WIDTH-1:0] awaddr_s,
  output logic [NUM_SLAVES-1:0][DATA_WIDTH-1:0] wdata_s,
  output logic [NUM_SLAVES-1:0][DATA_WIDTH/8-1:0] wstrb_s,
  output logic [NUM_SLAVES-1:0] awvalid_s,
  input  logic [NUM_SLAVES-1:0] awready_s,
  output logic [NUM_SLAVES-1:0] wvalid_s,
  input  logic [NUM_SLAVES-1:0] wready_s,
  output logic [NUM_SLAVES-1:0] bready_s,
  input  logic [NUM_SLAVES-1:0] bvalid_s,
  input  logic [NUM_SLAVES-1:0][2:0] bresp_s
);

  // Address map (example - configurable through parameters if needed for more flexibility)
  localparam ADDR_SLAVE0_START = 32'h00000000;
  localparam ADDR_SLAVE0_END   = 32'h0000FFFF;
  localparam ADDR_SLAVE1_START = 32'h00010000;
  localparam ADDR_SLAVE1_END   = 32'h0001FFFF;

  // Arbitration logic (Round Robin for simplicity)
  logic [NUM_MASTERS-1:0] master_request[NUM_SLAVES];
  logic [NUM_SLAVES-1:0] slave_grant[NUM_MASTERS];
  logic [NUM_SLAVES-1:0] slave_active;
  logic [NUM_MASTERS-1:0] master_active;

  //Internal signals
  logic [NUM_MASTERS-1:0] slave0_req;
  logic [NUM_MASTERS-1:0] slave1_req;

  // Address Decoding
  always_comb begin
    for (int i = 0; i < NUM_MASTERS; i++) begin
        slave0_req[i] = (awaddr_m[i] >= ADDR_SLAVE0_START && awaddr_m[i] <= ADDR_SLAVE0_END) && awvalid_m[i];
        slave1_req[i] = (awaddr_m[i] >= ADDR_SLAVE1_START && awaddr_m[i] <= ADDR_SLAVE1_END) && awvalid_m[i];
    end
  end

  // Arbitration logic for each slave
  always_comb begin
    for (int i = 0; i < NUM_MASTERS; i++) begin
        master_request[0][i] = slave0_req[i];
        master_request[1][i] = slave1_req[i];
    end
  end

  //Round robin arbiter
  generate
      for (genvar j = 0; j < NUM_SLAVES; j++) begin : arb_gen
          round_robin_arbiter #(
              .NUM_INPUTS(NUM_MASTERS)
          ) arb (
              .clk(clk),
              .rst(rst),
              .request_in(master_request[j]),
              .grant_out(slave_grant[j]),
              .active_out(slave_active[j])
          );
      end
  endgenerate

  //Slave Assignments
  always_comb begin
    for (int i = 0; i < NUM_SLAVES; i++) begin
      awaddr_s[i]  = '0;
      wdata_s[i]   = '0;
      wstrb_s[i]   = '0;
      awvalid_s[i] = '0;
      wvalid_s[i] = '0;
      bready_s[i] = '0;
    end
    for (int i = 0; i < NUM_MASTERS; i++) begin
      awready_m[i]  = 0;
      wready_m[i]   = 0;
      bvalid_m[i] = 0;
      bresp_m[i] = '0;
    end
  end


  always_comb begin
    // Slave 0 Assignments
    for(int i = 0; i < NUM_MASTERS; i++) begin
        if (slave_grant[0][i] && slave0_req[i]) begin
            awaddr_s[0]   = awaddr_m[i];
            wdata_s[0]    = wdata_m[i];
            wstrb_s[0]    = wstrb_m[i];
            awvalid_s[0]  = awvalid_m[i];
            wvalid_s[0]   = wvalid_m[i];
            bready_s[0]   = bready_m[i];

            awready_m[i]  = awready_s[0];
            wready_m[i]   = wready_s[0];
            bvalid_m[i] = bvalid_s[0];
            bresp_m[i] = bresp_s[0];
        end
    end

    // Slave 1 Assignments
    for(int i = 0; i < NUM_MASTERS; i++) begin
        if (slave_grant[1][i] && slave1_req[i]) begin
            awaddr_s[1]   = awaddr_m[i];
            wdata_s[1]    = wdata_m[i];
            wstrb_s[1]    = wstrb_m[i];
            awvalid_s[1]  = awvalid_m[i];
            wvalid_s[1]   = wvalid_m[i];
            bready_s[1]   = bready_m[i];

            awready_m[i]  = awready_s[1];
            wready_m[i]   = wready_s[1];
            bvalid_m[i] = bvalid_s[1];
            bresp_m[i] = bresp_s[1];
        end
    end
  end


endmodule

//Round Robin Arbiter
module round_robin_arbiter #(
    parameter NUM_INPUTS = 2
) (
    input  logic clk,
    input  logic rst,
    input  logic [NUM_INPUTS-1:0] request_in,
    output logic [NUM_INPUTS-1:0] grant_out,
    output logic active_out
);

  logic [NUM_INPUTS-1:0] current_grant;
  logic [NUM_INPUTS-1:0] next_grant;

  // Initialize grant to the first input after reset
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      current_grant <= {NUM_INPUTS{1'b0}};
      current_grant[0] <= 1'b1;
    end else begin
      current_grant <= next_grant;
    end
  end

  // Determine next grant
  always_comb begin
    next_grant = '0; // Default to no grant
    logic found_request = 0;

    for (int i = 0; i < NUM_INPUTS; i++) begin
      integer index = (integer)((NUM_INPUTS + i) % NUM_INPUTS);
      if (current_grant[index] == 1'b1) begin
          for (int j = 1; j < NUM_INPUTS; j++) begin
              integer check_index = (integer)((NUM_INPUTS + index + j) % NUM_INPUTS);
              if (request_in[check_index] == 1'b1) begin
                  next_grant[check_index] = 1'b1;
                  found_request = 1;
                  break;
              end
          end
          if (!found_request && request_in[index]) begin
               next_grant[index] = 1'b1;
               found_request = 1;
               break;
          end

      end
    end
      if (!found_request) begin
        for (int k = 0; k < NUM_INPUTS; k++) begin
          if (request_in[k] == 1'b1) begin
              next_grant[k] = 1'b1;
              found_request = 1;
              break;
          end
        end
    end
    if (!found_request) begin
      next_grant = current_grant;
    end
  end

  // Grant Output
  assign grant_out = next_grant;

  // Active Output (Indicates if any grant is active)
  assign active_out = |next_grant;

endmodule