`define CYCLE_TIME 10.0

// `include "../00_TESTBED/pseudo_DRAM.v"

module PATTERN #(parameter DATA_WIDTH = 16,
    parameter TWIDDLE_WIDTH = 16)(
    output clk, rst,
    output reg signed [DATA_WIDTH-1:0] data_in_real [7:0],
    output reg signed [DATA_WIDTH-1:0] data_in_imag [7:0],
    input signed [DATA_WIDTH:0] data_out_real [7:0],
    input signed [DATA_WIDTH:0] data_out_imag [7:0]
);

    

    // reg clk;
    // reg rst;
    // reg signed [DATA_WIDTH-1:0] data_in_real [7:0];
    // reg signed [DATA_WIDTH-1:0] data_in_imag [7:0];
    // wire signed [DATA_WIDTH:0] data_out_real [7:0];
    // wire signed [DATA_WIDTH:0] data_out_imag [7:0];

    // fft_8point #(
    //     .DATA_WIDTH(DATA_WIDTH),
    //     .TWIDDLE_WIDTH(TWIDDLE_WIDTH)
    // ) dut (
    //     .clk(clk),
    //     .rst(rst),
    //     .data_in_real(data_in_real),
    //     .data_in_imag(data_in_imag),
    //     .data_out_real(data_out_real),
    //     .data_out_imag(data_out_imag)
    // );

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0; //Release reset
        #10;

        // Test Case 1: Impulse Input (Real Part Only)
        data_in_real[0] = 32767;
        data_in_real[1] = 0;
        data_in_real[2] = 0;
        data_in_real[3] = 0;
        data_in_real[4] = 0;
        data_in_real[5] = 0;
        data_in_real[6] = 0;
        data_in_real[7] = 0;

        data_in_imag[0] = 0;
        data_in_imag[1] = 0;
        data_in_imag[2] = 0;
        data_in_imag[3] = 0;
        data_in_imag[4] = 0;
        data_in_imag[5] = 0;
        data_in_imag[6] = 0;
        data_in_imag[7] = 0;
        #20;

        // Test Case 2: DC Input (Real Part Only)
        data_in_real[0] = 32767;
        data_in_real[1] = 32767;
        data_in_real[2] = 32767;
        data_in_real[3] = 32767;
        data_in_real[4] = 32767;
        data_in_real[5] = 32767;
        data_in_real[6] = 32767;
        data_in_real[7] = 32767;

        data_in_imag[0] = 0;
        data_in_imag[1] = 0;
        data_in_imag[2] = 0;
        data_in_imag[3] = 0;
        data_in_imag[4] = 0;
        data_in_imag[5] = 0;
        data_in_imag[6] = 0;
        data_in_imag[7] = 0;
        #20;

        //Test Case 3: Sine wave
        data_in_real[0] = 0;
        data_in_real[1] = 23170; // sin(pi/4)
        data_in_real[2] = 32767; // sin(pi/2)
        data_in_real[3] = 23170; // sin(3pi/4)
        data_in_real[4] = 0;     // sin(pi)
        data_in_real[5] = -23170; // sin(5pi/4)
        data_in_real[6] = -32767; // sin(3pi/2)
        data_in_real[7] = -23170; // sin(7pi/4)

        data_in_imag[0] = 0;
        data_in_imag[1] = 0;
        data_in_imag[2] = 0;
        data_in_imag[3] = 0;
        data_in_imag[4] = 0;
        data_in_imag[5] = 0;
        data_in_imag[6] = 0;
        data_in_imag[7] = 0;
        #20;



        $finish;
    end

    always #5 clk = ~clk; // 10ns clock period

    initial begin
        $dumpfile("fft_8point_tb.vcd");
        $dumpvars(0, fft_8point_tb);
    end

endmodule