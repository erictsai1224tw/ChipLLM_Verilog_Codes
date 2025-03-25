module DESIGN #(
  parameter DATA_WIDTH = 8  // Default data width is 8 bits
) (
  input  logic [DATA_WIDTH-1:0] i_data,
  output logic [clog2(DATA_WIDTH)-1:0] o_encoded, // Log2 of DATA_WIDTH to get encoding size
  output logic                    o_valid        // Indicates a valid input (at least one '1')
);

  // Calculate log2 of DATA_WIDTH for encoding width
  function integer clog2;
    input integer depth;
    integer i;
    begin
      i = 0;
      while (depth > (1 << i)) begin
        i = i + 1;
      end
      clog2 = i;
    end
  endfunction

  logic found; // Internal signal to track if a '1' has been found

  always_comb begin
    o_valid = |i_data;  // OR reduction to check if any input bit is '1'
    o_encoded = 0; // Default encoded value

    found = 0; //reset flag

    for (int i = DATA_WIDTH - 1; i >= 0; i--) begin
      if (i_data[i] == 1'b1 && !found) begin
        o_encoded = i;
        found = 1;
      end
    end
  end

endmodule