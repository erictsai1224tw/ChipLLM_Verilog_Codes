module DESIGN (
  input clk,
  input rst_n,

  // PHY Interface (Simplified)
  input rx_data_valid,
  input [7:0] rx_data, // Simplified 8-bit data
  output tx_en,
  output [7:0] tx_data,

  // Host Interface (Simplified)
  input host_tx_req,
  input [7:0] host_tx_data,
  output host_rx_rdy,
  output [7:0] host_rx_data
);

  // Parameters
  parameter MAC_ADDR = 48'h00_00_00_AA_BB_CC; // Example MAC address

  // Internal Signals
  reg [7:0] rx_fifo [0:63]; // Reception FIFO (64 bytes)
  reg [5:0] rx_fifo_wr_ptr;
  reg [5:0] rx_fifo_rd_ptr;
  reg rx_fifo_full;
  reg rx_fifo_empty;

  reg [7:0] tx_fifo [0:63]; // Transmission FIFO (64 bytes)
  reg [5:0] tx_fifo_wr_ptr;
  reg [5:0] tx_fifo_rd_ptr;
  reg tx_fifo_full;
  reg tx_fifo_empty;

  reg transmitting;
  reg receiving;
  reg collision;
  reg [31:0] fcs;
  reg [47:0] dest_mac_addr;
  integer i;

  // State Machine
  localparam IDLE        = 0;
  localparam PREAMBLE    = 1;
  localparam DEST_ADDR   = 2;
  localparam SRC_ADDR    = 3;
  localparam TYPE        = 4;
  localparam DATA        = 5;
  localparam FCS_CALC    = 6;
  localparam FCS_CHECK   = 7;
  localparam TX_PREAMBLE = 8;
  localparam TX_SFD      = 9;
  localparam TX_DATA     = 10;
  localparam TX_FCS      = 11;
  localparam TX_IFG      = 12;

  reg [3:0] rx_state;
  reg [3:0] tx_state;

  // Preamble and SFD
  localparam PREAMBLE_BYTE = 8'h55; // 01010101
  localparam SFD_BYTE      = 8'hD5; // 11010101

  // Interframe Gap (IFG) - Minimum 96 bits (12 bytes)
  localparam IFG_BYTES = 12;
  reg [3:0] ifg_count;

  // FCS Polynomial (IEEE 802.3)
  localparam FCS_POLYNOMIAL = 32'hEDB88320;

  //----------------------------------------------------------------------------
  // Transmission Logic
  //----------------------------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tx_en <= 0;
      tx_data <= 0;
      tx_fifo_wr_ptr <= 0;
      tx_fifo_rd_ptr <= 0;
      tx_fifo_full <= 0;
      tx_fifo_empty <= 1;
      transmitting <= 0;
      tx_state <= IDLE;
    end else begin
      case (tx_state)
        IDLE: begin
          if (host_tx_req && !tx_fifo_full) begin
            tx_fifo[tx_fifo_wr_ptr] <= host_tx_data;
            tx_fifo_wr_ptr <= tx_fifo_wr_ptr + 1;
            if (tx_fifo_wr_ptr == 63) tx_fifo_full <= 1;
            tx_fifo_empty <= 0;

            if (!transmitting) begin
              transmitting <= 1;
              tx_state <= TX_PREAMBLE;
              tx_fifo_rd_ptr <= 0; // Reset read pointer for transmission
            end
          end
        end

        TX_PREAMBLE: begin
          tx_en <= 1;
          tx_data <= PREAMBLE_BYTE;
          if (tx_fifo_rd_ptr < 7) begin // 7 bytes preamble
             tx_fifo_rd_ptr <= tx_fifo_rd_ptr + 1;
          end else begin
            tx_state <= TX_SFD;
            tx_fifo_rd_ptr <= 0;  // Reset read pointer to point to data
          end
        end

        TX_SFD: begin
          tx_en <= 1;
          tx_data <= SFD_BYTE;
          tx_state <= TX_DATA;
          tx_fifo_rd_ptr <= 0;

        end

        TX_DATA: begin
          if (!tx_fifo_empty) begin
            tx_en <= 1;
            tx_data <= tx_fifo[tx_fifo_rd_ptr];
            tx_fifo_rd_ptr <= tx_fifo_rd_ptr + 1;
            if (tx_fifo_rd_ptr == tx_fifo_wr_ptr) tx_fifo_empty <= 1;
            if (tx_fifo_wr_ptr == 63) tx_fifo_full <= 0;
          end else begin
            tx_state <= TX_FCS;
            fcs <= 32'hFFFFFFFF; // Initial FCS value
          end
        end

        TX_FCS: begin
          // Simplified FCS Calculation (For demonstration. Real implementation would calculate FCS during TX_DATA)
          tx_en <= 1;
          tx_data <= fcs[7:0]; // This is a placeholder! FCS calculation not fully implemented.
          tx_state <= TX_IFG;
          ifg_count <= 0;

        end

        TX_IFG: begin
            tx_en <= 0;
            if (ifg_count < IFG_BYTES - 1) begin
                ifg_count <= ifg_count + 1;
            end else begin
                tx_state <= IDLE;
                transmitting <= 0;
                tx_fifo_wr_ptr <= 0;
                tx_fifo_rd_ptr <= 0;
                tx_fifo_full <= 0;
                tx_fifo_empty <= 1;
            end
        end

      endcase
    end
  end

  //----------------------------------------------------------------------------
  // Reception Logic
  //----------------------------------------------------------------------------

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      receiving <= 0;
      rx_state <= IDLE;
      rx_fifo_wr_ptr <= 0;
      rx_fifo_rd_ptr <= 0;
      rx_fifo_full <= 0;
      rx_fifo_empty <= 1;
      host_rx_rdy <= 0;
      host_rx_data <= 0;
    end else begin
      case (rx_state)
        IDLE: begin
          if (rx_data_valid && (rx_data == PREAMBLE_BYTE)) begin
            receiving <= 1;
            rx_state <= PREAMBLE;
            rx_fifo_wr_ptr <= 0;
            rx_fifo_rd_ptr <= 0;
            rx_fifo_full <= 0;
            rx_fifo_empty <= 1;
          end
        end

        PREAMBLE: begin
          if (rx_data_valid && (rx_data == SFD_BYTE)) begin
            rx_state <= DEST_ADDR;
            dest_mac_addr <= 0;
            i <= 0;
          end else if (rx_data_valid && (rx_data != PREAMBLE_BYTE))begin
            rx_state <= IDLE;
            receiving <= 0;
          end
        end

        DEST_ADDR: begin
          if(rx_data_valid) begin
            dest_mac_addr[i*8 +: 8] <= rx_data;
            i = i + 1;
            if(i == 6) begin
                rx_state <= SRC_ADDR;
                i <= 0;
            end
          end
        end

        SRC_ADDR: begin
          if(rx_data_valid) begin
            i = i + 1;
            if(i == 6) begin
                rx_state <= TYPE;
            end
          end
        end


        TYPE: begin
          if (rx_data_valid) begin
            rx_state <= DATA;
          end
        end

        DATA: begin
          if (rx_data_valid && !rx_fifo_full) begin
            rx_fifo[rx_fifo_wr_ptr] <= rx_data;
            rx_fifo_wr_ptr <= rx_fifo_wr_ptr + 1;
            if (rx_fifo_wr_ptr == 63) rx_fifo_full <= 1;
            rx_fifo_empty <= 0;
            rx_state <= DATA;  // Keep receiving data
          end else begin
            rx_state <= FCS_CHECK;
            fcs <= 32'hFFFFFFFF; // Initial FCS Value
          end
        end

        FCS_CHECK: begin
          if (rx_data_valid) begin
              // Simplified FCS Check Placeholder - Real implementation would calculate FCS during DATA receive
              if (dest_mac_addr == MAC_ADDR) begin
                 host_rx_data <= rx_fifo[0]; // Just passing first byte for now.
                 host_rx_rdy <= 1;
              end
              rx_state <= IDLE;
              receiving <= 0;
              rx_fifo_wr_ptr <= 0;
              rx_fifo_rd_ptr <= 0;
              rx_fifo_full <= 0;
              rx_fifo_empty <= 1;
          end
        end
      endcase
    end
  end

endmodule