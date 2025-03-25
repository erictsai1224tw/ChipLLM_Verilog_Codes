module DESIGN #(
    parameter DATA_WIDTH = 16,
    parameter TWIDDLE_WIDTH = 16
) (
    input signed [DATA_WIDTH-1:0] real_in,
    input signed [DATA_WIDTH-1:0] imag_in,
    input signed [TWIDDLE_WIDTH-1:0] twiddle_real,
    input signed [TWIDDLE_WIDTH-1:0] twiddle_imag,
    output signed [DATA_WIDTH+TWIDDLE_WIDTH-1:0] real_out,
    output signed [DATA_WIDTH+TWIDDLE_WIDTH-1:0] imag_out
);

    wire signed [DATA_WIDTH+TWIDDLE_WIDTH-1:0] mult1, mult2, mult3, mult4;

    assign mult1 = real_in * twiddle_real;
    assign mult2 = imag_in * twiddle_imag;
    assign mult3 = real_in * twiddle_imag;
    assign mult4 = imag_in * twiddle_real;

    assign real_out = mult1 - mult2;
    assign imag_out = mult3 + mult4;

endmodule

module butterfly #(
    parameter DATA_WIDTH = 16,
    parameter TWIDDLE_WIDTH = 16
) (
    input signed [DATA_WIDTH-1:0] data_in_real_top,
    input signed [DATA_WIDTH-1:0] data_in_imag_top,
    input signed [DATA_WIDTH-1:0] data_in_real_bottom,
    input signed [DATA_WIDTH-1:0] data_in_imag_bottom,
    input signed [TWIDDLE_WIDTH-1:0] twiddle_real,
    input signed [TWIDDLE_WIDTH-1:0] twiddle_imag,
    output signed [DATA_WIDTH:0] data_out_real_top, // Increased bit width for potential overflow
    output signed [DATA_WIDTH:0] data_out_imag_top,
    output signed [DATA_WIDTH:0] data_out_real_bottom,
    output signed [DATA_WIDTH:0] data_out_imag_bottom
);

    wire signed [DATA_WIDTH+TWIDDLE_WIDTH-1:0] mult_real, mult_imag;

    complex_multiplier #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) complex_mult (
        .real_in(data_in_real_bottom),
        .imag_in(data_in_imag_bottom),
        .twiddle_real(twiddle_real),
        .twiddle_imag(twiddle_imag),
        .real_out(mult_real),
        .imag_out(mult_imag)
    );

    assign data_out_real_top = data_in_real_top + mult_real[DATA_WIDTH+TWIDDLE_WIDTH-1:DATA_WIDTH+TWIDDLE_WIDTH-DATA_WIDTH-1]; // Truncate to DATA_WIDTH + sign bit
    assign data_out_imag_top = data_in_imag_top + mult_imag[DATA_WIDTH+TWIDDLE_WIDTH-1:DATA_WIDTH+TWIDDLE_WIDTH-DATA_WIDTH-1]; // Truncate to DATA_WIDTH + sign bit
    assign data_out_real_bottom = data_in_real_top - mult_real[DATA_WIDTH+TWIDDLE_WIDTH-1:DATA_WIDTH+TWIDDLE_WIDTH-DATA_WIDTH-1]; // Truncate to DATA_WIDTH + sign bit
    assign data_out_imag_bottom = data_in_imag_top - mult_imag[DATA_WIDTH+TWIDDLE_WIDTH-1:DATA_WIDTH+TWIDDLE_WIDTH-DATA_WIDTH-1]; // Truncate to DATA_WIDTH + sign bit

endmodule

module fft_8point #(
    parameter DATA_WIDTH = 16,
    parameter TWIDDLE_WIDTH = 16
) (
    input clk,
    input rst,
    input signed [DATA_WIDTH-1:0] data_in_real [7:0],
    input signed [DATA_WIDTH-1:0] data_in_imag [7:0],
    output signed [DATA_WIDTH:0] data_out_real [7:0],
    output signed [DATA_WIDTH:0] data_out_imag [7:0]
);

    // Stage 1
    wire signed [DATA_WIDTH:0] stage1_real [7:0];
    wire signed [DATA_WIDTH:0] stage1_imag [7:0];

    // Stage 2
    wire signed [DATA_WIDTH:0] stage2_real [7:0];
    wire signed [DATA_WIDTH:0] stage2_imag [7:0];

    // Stage 3
    wire signed [DATA_WIDTH:0] stage3_real [7:0];
    wire signed [DATA_WIDTH:0] stage3_imag [7:0];


    // Twiddle Factors (Example for 8-point FFT)
    localparam TWIDDLE_REAL_0 = 32767; // cos(0) * 2^15
    localparam TWIDDLE_IMAG_0 = 0;     // sin(0) * 2^15
    localparam TWIDDLE_REAL_1 = 23170; // cos(pi/4) * 2^15
    localparam TWIDDLE_IMAG_1 = -23170; // sin(pi/4) * 2^15
    localparam TWIDDLE_REAL_2 = 0;     // cos(pi/2) * 2^15
    localparam TWIDDLE_IMAG_2 = -32767; // sin(pi/2) * 2^15
    localparam TWIDDLE_REAL_3 = -23170; // cos(3pi/4) * 2^15
    localparam TWIDDLE_IMAG_3 = -23170; // sin(3pi/4) * 2^15

    // Stage 1 butterflies
    butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly1_0 (
        .data_in_real_top(data_in_real[0]),
        .data_in_imag_top(data_in_imag[0]),
        .data_in_real_bottom(data_in_real[4]),
        .data_in_imag_bottom(data_in_imag[4]),
        .twiddle_real(TWIDDLE_REAL_0),
        .twiddle_imag(TWIDDLE_IMAG_0),
        .data_out_real_top(stage1_real[0]),
        .data_out_imag_top(stage1_imag[0]),
        .data_out_real_bottom(stage1_real[4]),
        .data_out_imag_bottom(stage1_imag[4])
    );

    butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly1_1 (
        .data_in_real_top(data_in_real[1]),
        .data_in_imag_top(data_in_imag[1]),
        .data_in_real_bottom(data_in_real[5]),
        .data_in_imag_bottom(data_in_imag[5]),
        .twiddle_real(TWIDDLE_REAL_0),
        .twiddle_imag(TWIDDLE_IMAG_0),
        .data_out_real_top(stage1_real[1]),
        .data_out_imag_top(stage1_imag[1]),
        .data_out_real_bottom(stage1_real[5]),
        .data_out_imag_bottom(stage1_imag[5])
    );

    butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly1_2 (
        .data_in_real_top(data_in_real[2]),
        .data_in_imag_top(data_in_imag[2]),
        .data_in_real_bottom(data_in_real[6]),
        .data_in_imag_bottom(data_in_imag[6]),
        .twiddle_real(TWIDDLE_REAL_0),
        .twiddle_imag(TWIDDLE_IMAG_0),
        .data_out_real_top(stage1_real[2]),
        .data_out_imag_top(stage1_imag[2]),
        .data_out_real_bottom(stage1_real[6]),
        .data_out_imag_bottom(stage1_imag[6])
    );

    butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly1_3 (
        .data_in_real_top(data_in_real[3]),
        .data_in_imag_top(data_in_imag[3]),
        .data_in_real_bottom(data_in_real[7]),
        .data_in_imag_bottom(data_in_imag[7]),
        .twiddle_real(TWIDDLE_REAL_0),
        .twiddle_imag(TWIDDLE_IMAG_0),
        .data_out_real_top(stage1_real[3]),
        .data_out_imag_top(stage1_imag[3]),
        .data_out_real_bottom(stage1_real[7]),
        .data_out_imag_bottom(stage1_imag[7])
    );

    // Stage 2 butterflies
    butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly2_0 (
        .data_in_real_top(stage1_real[0]),
        .data_in_imag_top(stage1_imag[0]),
        .data_in_real_bottom(stage1_real[2]),
        .data_in_imag_bottom(stage1_imag[2]),
        .twiddle_real(TWIDDLE_REAL_0),
        .twiddle_imag(TWIDDLE_IMAG_0),
        .data_out_real_top(stage2_real[0]),
        .data_out_imag_top(stage2_imag[0]),
        .data_out_real_bottom(stage2_real[2]),
        .data_out_imag_bottom(stage2_imag[2])
    );

     butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly2_1 (
        .data_in_real_top(stage1_real[1]),
        .data_in_imag_top(stage1_imag[1]),
        .data_in_real_bottom(stage1_real[3]),
        .data_in_imag_bottom(stage1_imag[3]),
        .twiddle_real(TWIDDLE_REAL_1),
        .twiddle_imag(TWIDDLE_IMAG_1),
        .data_out_real_top(stage2_real[1]),
        .data_out_imag_top(stage2_imag[1]),
        .data_out_real_bottom(stage2_real[3]),
        .data_out_imag_bottom(stage2_imag[3])
    );

   butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly2_2 (
        .data_in_real_top(stage1_real[4]),
        .data_in_imag_top(stage1_imag[4]),
        .data_in_real_bottom(stage1_real[6]),
        .data_in_imag_bottom(stage1_imag[6]),
        .twiddle_real(TWIDDLE_REAL_2),
        .twiddle_imag(TWIDDLE_IMAG_2),
        .data_out_real_top(stage2_real[4]),
        .data_out_imag_top(stage2_imag[4]),
        .data_out_real_bottom(stage2_real[6]),
        .data_out_imag_bottom(stage2_imag[6])
    );

    butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly2_3 (
        .data_in_real_top(stage1_real[5]),
        .data_in_imag_top(stage1_imag[5]),
        .data_in_real_bottom(stage1_real[7]),
        .data_in_imag_bottom(stage1_imag[7]),
        .twiddle_real(TWIDDLE_REAL_3),
        .twiddle_imag(TWIDDLE_IMAG_3),
        .data_out_real_top(stage2_real[5]),
        .data_out_imag_top(stage2_imag[5]),
        .data_out_real_bottom(stage2_real[7]),
        .data_out_imag_bottom(stage2_imag[7])
    );

   // Stage 3 butterflies
   butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly3_0 (
        .data_in_real_top(stage2_real[0]),
        .data_in_imag_top(stage2_imag[0]),
        .data_in_real_bottom(stage2_real[1]),
        .data_in_imag_bottom(stage2_imag[1]),
        .twiddle_real(TWIDDLE_REAL_0),
        .twiddle_imag(TWIDDLE_IMAG_0),
        .data_out_real_top(stage3_real[0]),
        .data_out_imag_top(stage3_imag[0]),
        .data_out_real_bottom(stage3_real[1]),
        .data_out_imag_bottom(stage3_imag[1])
    );

    butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly3_1 (
        .data_in_real_top(stage2_real[2]),
        .data_in_imag_top(stage2_imag[2]),
        .data_in_real_bottom(stage2_real[3]),
        .data_in_imag_bottom(stage2_imag[3]),
        .twiddle_real(TWIDDLE_REAL_0),
        .twiddle_imag(TWIDDLE_IMAG_0),
        .data_out_real_top(stage3_real[2]),
        .data_out_imag_top(stage3_imag[2]),
        .data_out_real_bottom(stage3_real[3]),
        .data_out_imag_bottom(stage3_imag[3])
    );

   butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly3_2 (
        .data_in_real_top(stage2_real[4]),
        .data_in_imag_top(stage2_imag[4]),
        .data_in_real_bottom(stage2_real[5]),
        .data_in_imag_bottom(stage2_imag[5]),
        .twiddle_real(TWIDDLE_REAL_0),
        .twiddle_imag(TWIDDLE_IMAG_0),
        .data_out_real_top(stage3_real[4]),
        .data_out_imag_top(stage3_imag[4]),
        .data_out_real_bottom(stage3_real[5]),
        .data_out_imag_bottom(stage3_imag[5])
    );

   butterfly #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    ) butterfly3_3 (
        .data_in_real_top(stage2_real[6]),
        .data_in_imag_top(stage2_imag[6]),
        .data_in_real_bottom(stage2_real[7]),
        .data_in_imag_bottom(stage2_imag[7]),
        .twiddle_real(TWIDDLE_REAL_0),
        .twiddle_imag(TWIDDLE_IMAG_0),
        .data_out_real_top(stage3_real[6]),
        .data_out_imag_top(stage3_imag[6]),
        .data_out_real_bottom(stage3_real[7]),
        .data_out_imag_bottom(stage3_imag[7])
    );



    // Output assignment (Bit-reversed order)
    assign data_out_real[0] = stage3_real[0];
    assign data_out_imag[0] = stage3_imag[0];
    assign data_out_real[4] = stage3_real[1];
    assign data_out_imag[4] = stage3_imag[1];
    assign data_out_real[2] = stage3_real[2];
    assign data_out_imag[2] = stage3_imag[2];
    assign data_out_real[6] = stage3_real[3];
    assign data_out_imag[6] = stage3_imag[3];
    assign data_out_real[1] = stage3_real[4];
    assign data_out_imag[1] = stage3_imag[4];
    assign data_out_real[5] = stage3_real[5];
    assign data_out_imag[5] = stage3_imag[5];
    assign data_out_real[3] = stage3_real[6];
    assign data_out_imag[3] = stage3_imag[6];
    assign data_out_real[7] = stage3_real[7];
    assign data_out_imag[7] = stage3_imag[7];



endmodule