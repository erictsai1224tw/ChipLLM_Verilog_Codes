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
  parameter WIDTH = 8 // Default width of the input
) (
  input  logic [WIDTH-1:0] i_data,  // Input data vector
  output logic [$clog2(WIDTH):0] o_encoded, // Encoded output (log2(WIDTH) bits)
  output logic o_valid             // Indicates that a valid input is present
);

  // Local parameter for cleaner code (avoid recalculating)
  localparam ENCODED_WIDTH = $clog2(WIDTH);

  always_comb begin
    o_valid = 1'b0;
    o_encoded = 0; // Default value if no input is high

    for (int i = WIDTH - 1; i >= 0; i--) begin
      if (i_data[i]) begin
        o_valid = 1'b1;
        o_encoded = i;
        break; // Exit the loop after finding the highest priority
      end
    end
  end

endmodule