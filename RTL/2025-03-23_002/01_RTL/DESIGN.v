module DESIGN #(parameter WIDTH = 8) (
    input logic [WIDTH-1:0] i_req,
    output logic [$clog2(WIDTH)-1:0] o_grant,
    output logic o_valid
);

  // Internal signal to store the encoded value
  logic [$clog2(WIDTH)-1:0] encoded_value;

  always_comb begin
    o_valid = 0; // Default: no request asserted
    encoded_value = 0; // Default: no valid request

    for (int i = WIDTH-1; i >= 0; i--) begin
      if (i_req[i]) begin
        encoded_value = i;
        o_valid = 1; // A request is asserted
        break; // Exit the loop, highest priority found
      end
    end
    o_grant = encoded_value;
  end

endmodule