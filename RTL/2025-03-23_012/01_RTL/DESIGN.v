// module DESIGN #(
//   parameter WIDTH = 8 // Default width of the input
// ) (
//   input  logic [WIDTH-1:0] i_data,  // Input data
//   output logic [$clog2(WIDTH)-1:0] o_encoded, // Encoded output (index of highest priority input)
//   output logic o_valid        // Indicates if any input is active
// );

//   // Internal signal to store the encoded value
//   logic [$clog2(WIDTH)-1:0] encoded;

//   // Default assignment for o_valid
//   assign o_valid = |i_data; // OR reduction of all input bits

//   always_comb begin
//     encoded = 0; // Default value if no input is active.
//     for (int i = WIDTH-1; i >= 0; i--) begin
//       if (i_data[i]) begin
//         encoded = i;
//         break; // Stop after finding the highest priority bit
//       end
//     end
//   end

//   assign o_encoded = encoded;

// endmodule

module DESIGN #(
    parameter WIDTH = 8 // Default width is 8 bits
) (
    input  logic [WIDTH-1:0]  in,
    output logic [$clog2(WIDTH)-1:0] out,
    output logic              valid
);

  // Internal signal to track the highest priority bit
  logic [WIDTH-1:0] priority_mask;

  // Assign the priority mask based on the input bits
  generate
    genvar i;
    for (i = 0; i < WIDTH; i = i + 1) begin : priority_mask_gen
      if (i == 0) begin
        assign priority_mask[i] = in[i];
      end else begin
        assign priority_mask[i] = in[i] & ~(|in[i-1:0]);
      end
    end
  endgenerate

  // Determine if any input is valid
  assign valid = |in;

  // Encode the priority mask to generate the output
  always_comb begin
    if (!valid) begin
      out = 0; // Default output when no input is valid
    end else begin
      for (int j = WIDTH-1; j >= 0; j--) begin
        if (priority_mask[j]) begin
          out = j;
          break; // Found the highest priority bit, exit loop
        end
      end
    end
  end

endmodule