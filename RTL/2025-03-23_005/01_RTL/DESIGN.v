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

module DESIGN (
    input clk,
    input rst,
    input enable,

    // Input Data and Key
    input [127:0] data_in,
    input [127:0] key_in,
    input operation_mode,  // 0: Encryption, 1: Decryption

    // Output Data
    output reg [127:0] data_out,
    output reg valid_out,

    // Status Signals
    output reg busy
);

// Internal Signals
reg [127:0] round_key [0:10]; // Round keys for 11 rounds
reg [127:0] state;
reg [3:0] round_num;

// State Machine States
enum logic [2:0] {
    IDLE,
    KEY_EXPANSION,
    ROUND_0,
    ROUND_1,
    ROUND_2,
    ROUND_3,
    ROUND_4,
    ROUND_5,
    ROUND_6,
    ROUND_7,
    ROUND_8,
    ROUND_9,
    ROUND_10,
    OUTPUT
} current_state, next_state;

// Key Expansion Module
aes_key_expansion key_exp (
    .clk(clk),
    .rst(rst),
    .key_in(key_in),
    .round_key(round_key)
);

// AES Round Function Module
aes_round round_func (
    .clk(clk),
    .rst(rst),
    .round_num(round_num),
    .state_in(state),
    .round_key(round_key[round_num]),
    .operation_mode(operation_mode),
    .state_out(state)
);

// State Machine Logic
always_ff @(posedge clk) begin
    if (rst) begin
        current_state <= IDLE;
        data_out <= 128'b0;
        valid_out <= 1'b0;
        busy <= 1'b0;
        round_num <= 4'b0;
        state <= 128'b0;
    end else begin
        current_state <= next_state;
    end
end

// Next State Logic
always_comb begin
    next_state = current_state;
    case (current_state)
        IDLE: begin
            if (enable) begin
                next_state = KEY_EXPANSION;
            end else begin
                next_state = IDLE;
            end
        end
        KEY_EXPANSION: begin
            next_state = ROUND_0;
            state = data_in; // Initial state is the input data
        end
        ROUND_0: next_state = ROUND_1;
        ROUND_1: next_state = ROUND_2;
        ROUND_2: next_state = ROUND_3;
        ROUND_3: next_state = ROUND_4;
        ROUND_4: next_state = ROUND_5;
        ROUND_5: next_state = ROUND_6;
        ROUND_6: next_state = ROUND_7;
        ROUND_7: next_state = ROUND_8;
        ROUND_8: next_state = ROUND_9;
        ROUND_9: next_state = ROUND_10;
        ROUND_10: next_state = OUTPUT;
        OUTPUT: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Output Logic
always_ff @(posedge clk) begin
    if (rst) begin
        // Already handled in reset section
    end else begin
        case (current_state)
            IDLE: begin
                busy <= enable;
                valid_out <= 1'b0;
            end
            KEY_EXPANSION: begin
                busy <= 1'b1;
            end
            ROUND_0: round_num <= 4'd1;
            ROUND_1: round_num <= 4'd2;
            ROUND_2: round_num <= 4'd3;
            ROUND_3: round_num <= 4'd4;
            ROUND_4: round_num <= 4'd5;
            ROUND_5: round_num <= 4'd6;
            ROUND_6: round_num <= 4'd7;
            ROUND_7: round_num <= 4'd8;
            ROUND_8: round_num <= 4'd9;
            ROUND_9: round_num <= 4'd10;
            ROUND_10: round_num <= 4'd0;  // Reset round_num for next encryption
            OUTPUT: begin
                data_out <= state; // Final output
                valid_out <= 1'b1;
                busy <= 1'b0;
            end
            default: begin
                busy <= 1'b0;
                valid_out <= 1'b0;
            end
        endcase
    end
end

endmodule


module aes_key_expansion (
    input clk,
    input rst,
    input [127:0] key_in,
    output reg [127:0] round_key [0:10]
);

  reg [31:0] w [0:43];
  integer i;

  function [31:0] subword;
    input [31:0] word;
    reg [7:0] temp [0:3];
    begin
      temp[0] = sbox[word[23:16]];
      temp[1] = sbox[word[15:8]];
      temp[2] = sbox[word[7:0]];
      temp[3] = sbox[word[31:24]];
      subword = {temp[0], temp[1], temp[2], temp[3]};
    end
  endfunction

  function [31:0] rotword;
    input [31:0] word;
    begin
      rotword = {word[23:0], word[31:24]};
    end
  endfunction

  always_ff @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 44; i = i + 1) begin
            w[i] <= 0;
        end
    end else begin
      // Initialize first four words with the key
      w[0] <= key_in[127:96];
      w[1] <= key_in[95:64];
      w[2] <= key_in[63:32];
      w[3] <= key_in[31:0];

      for (i = 4; i < 44; i = i + 1) begin
        if (i % 4 == 0) begin
          w[i] <= w[i-4] ^ (subword(rotword(w[i-1])) ^ rcon[i/4 - 1]);
        end else begin
          w[i] <= w[i-4] ^ w[i-1];
        end
      end
    end
  end

  always_ff @(posedge clk) begin
      if(rst) begin
        for (i = 0; i < 11; i = i + 1) begin
           round_key[i] <= 0;
        end
      end else begin
        // Generate Round Keys
        round_key[0] <= {w[0], w[1], w[2], w[3]};
        round_key[1] <= {w[4], w[5], w[6], w[7]};
        round_key[2] <= {w[8], w[9], w[10], w[11]};
        round_key[3] <= {w[12], w[13], w[14], w[15]};
        round_key[4] <= {w[16], w[17], w[18], w[19]};
        round_key[5] <= {w[20], w[21], w[22], w[23]};
        round_key[6] <= {w[24], w[25], w[26], w[27]};
        round_key[7] <= {w[28], w[29], w[30], w[31]};
        round_key[8] <= {w[32], w[33], w[34], w[35]};
        round_key[9] <= {w[36], w[37], w[38], w[39]};
        round_key[10] <= {w[40], w[41], w[42], w[43]};
      end
  end

  // S-box (Substitution Box)
  reg [7:0] sbox [0:255];
  initial $readmemh("sbox.data", sbox);  // Load S-box from file

  // Round Constant
  reg [31:0] rcon [0:9];
  initial $readmemh("rcon.data", rcon); // Load Round Constant from file
endmodule

module aes_round (
    input clk,
    input rst,
    input [3:0] round_num,
    input [127:0] state_in,
    input [127:0] round_key,
    input operation_mode,
    output reg [127:0] state_out
);

  reg [127:0] sub_bytes_out;
  reg [127:0] shift_rows_out;
  reg [127:0] mix_columns_out;

  // SubBytes
  always_comb begin
      integer i;
      for (i = 0; i < 16; i = i + 1) begin
          sub_bytes_out[i*8 +: 8] = sbox[state_in[i*8 +: 8]];
      end
  end

  // ShiftRows
  always_comb begin
    shift_rows_out[127:120] = sub_bytes_out[127:120]; // Row 0
    shift_rows_out[119:112] = sub_bytes_out[111:104]; // Row 1
    shift_rows_out[111:104] = sub_bytes_out[103:96];
    shift_rows_out[103:96] = sub_bytes_out[95:88];
    shift_rows_out[95:88] = sub_bytes_out[119:112];

    shift_rows_out[87:80]   = sub_bytes_out[71:64];   // Row 2
    shift_rows_out[79:72]   = sub_bytes_out[63:56];
    shift_rows_out[71:64]   = sub_bytes_out[55:48];
    shift_rows_out[63:56]   = sub_bytes_out[47:40];
    shift_rows_out[55:48]   = sub_bytes_out[87:80];
    shift_rows_out[47:40]   = sub_bytes_out[79:72];

    shift_rows_out[39:32]   = sub_bytes_out[7:0];     // Row 3
    shift_rows_out[31:24]   = sub_bytes_out[15:8];
    shift_rows_out[23:16]   = sub_bytes_out[23:16];
    shift_rows_out[15:8]    = sub_bytes_out[31:24];
    shift_rows_out[7:0]     = sub_bytes_out[39:32];
  end

  // MixColumns
  always_comb begin
    // Implemented using pre-computed matrices for high throughput
    // This is a simplified example, a full implementation would involve matrix multiplication
     if (round_num != 10) begin
         mix_columns_out = mix_columns(shift_rows_out);
     end else begin
         mix_columns_out = shift_rows_out; // No MixColumns in the last round.
     end

  end

  function [127:0] mix_columns;
    input [127:0] in_state;
    reg [127:0] out_state;
    reg [7:0] col [0:3];
    integer i;
    begin
        for (i = 0; i < 4; i = i + 1) begin
            col[i] = {in_state[i*32 + 31: i*32 + 24], in_state[i*32 + 23: i*32 + 16], in_state[i*32 + 15: i*32 + 8], in_state[i*32 + 7: i*32 + 0]};
        end

       // Hardcoding the MixColumns operation for performance. Ideally, precomputed lookup tables or XTIME operations should be employed.
       out_state[127:96] = mix_column_calculation(col[0]);
       out_state[95:64] = mix_column_calculation(col[1]);
       out_state[63:32] = mix_column_calculation(col[2]);
       out_state[31:0] = mix_column_calculation(col[3]);
       mix_columns = out_state;

    end
  endfunction

  function [31:0] mix_column_calculation;
    input [31:0] in_col;
    reg [31:0] out_col;
    begin
     // Simplistic example - NEEDS to be implemented correctly using Galois field arithmetic (XTIME)
        out_col = in_col;
    end
  endfunction


  // AddRoundKey
  always_comb begin
    state_out = mix_columns_out ^ round_key;
  end

  // S-box (Substitution Box) - Decoupled from KeyExpansion
  reg [7:0] sbox [0:255];
  initial $readmemh("sbox.data", sbox); // Load S-box from file


endmodule