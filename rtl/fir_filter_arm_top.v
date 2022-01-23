// Copyright (c) 2013 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Thu Jul 11 11:26:45 2013
// ============================================================================

// `define ENABLE_ADC
// `define ENABLE_AUD
`define ENABLE_CLOCK2
`define ENABLE_CLOCK3
`define ENABLE_CLOCK4
`define ENABLE_CLOCK
`define ENABLE_DRAM
`define ENABLE_FAN
`define ENABLE_FPGA
`define ENABLE_GPIO
`define ENABLE_HEX
`define ENABLE_HPS
// `define ENABLE_IRDA
`define ENABLE_KEY
`define ENABLE_LEDR
// `define ENABLE_PS2
`define ENABLE_SW
// `define ENABLE_TD
// `define ENABLE_VGA

module fir_filter_arm_top(

    /* Enables ADC - 3.3V */
    `ifdef ENABLE_ADC
    output             ADC_CONVST,
    output             ADC_DIN,
    input              ADC_DOUT,
    output             ADC_SCLK,
    `endif

    /* Enables AUD - 3.3V */
    `ifdef ENABLE_AUD
    input              AUD_ADCDAT,
    inout              AUD_ADCLRCK,
    inout              AUD_BCLK,
    output             AUD_DACDAT,
    inout              AUD_DACLRCK,
    output             AUD_XCK,
    `endif

    /* Enables CLOCK2  */
    `ifdef ENABLE_CLOCK2
    input              CLOCK2_50,
    `endif

    /* Enables CLOCK3 */
    `ifdef ENABLE_CLOCK3
    input              CLOCK3_50,
    `endif

    /* Enables CLOCK4 */
    `ifdef ENABLE_CLOCK4
    input              CLOCK4_50,
    `endif

    /* Enables CLOCK */
    `ifdef ENABLE_CLOCK
    input              CLOCK_50,
    `endif

    /* Enables DRAM - 3.3V */
    `ifdef ENABLE_DRAM
    output      [12:0] DRAM_ADDR,
    output      [1:0]  DRAM_BA,
    output             DRAM_CAS_N,
    output             DRAM_CKE,
    output             DRAM_CLK,
    output             DRAM_CS_N,
    inout       [15:0] DRAM_DQ,
    output             DRAM_LDQM,
    output             DRAM_RAS_N,
    output             DRAM_UDQM,
    output             DRAM_WE_N,
    `endif

    /* Enables FAN - 3.3V */
    `ifdef ENABLE_FAN
    output             FAN_CTRL,
    `endif

    /* Enables FPGA - 3.3V */
    `ifdef ENABLE_FPGA
    output             FPGA_I2C_SCLK,
    inout              FPGA_I2C_SDAT,
    `endif

    /* Enables GPIO - 3.3V */
    `ifdef ENABLE_GPIO
    inout     [35:0]         GPIO_0,
    inout     [35:0]         GPIO_1,
    `endif
 

    /* Enables HEX - 3.3V */
    `ifdef ENABLE_HEX
    output      [6:0]  HEX0,
    output      [6:0]  HEX1,
    output      [6:0]  HEX2,
    output      [6:0]  HEX3,
    output      [6:0]  HEX4,
    output      [6:0]  HEX5,
    `endif

    /* Enables HPS */
    `ifdef ENABLE_HPS
    inout              HPS_CONV_USB_N,
    output      [12:0] HPS_DDR3_ADDR,
    output      [2:0]  HPS_DDR3_BA,
    output             HPS_DDR3_CAS_N,
    output             HPS_DDR3_CKE,
    output             HPS_DDR3_CK_N, //1.5V
    output             HPS_DDR3_CK_P, //1.5V
    output             HPS_DDR3_CS_N,
    output      [0:0]  HPS_DDR3_DM,
    inout       [7:0]  HPS_DDR3_DQ,
    inout       [0:0]  HPS_DDR3_DQS_N,
    inout       [0:0]  HPS_DDR3_DQS_P,
    output             HPS_DDR3_ODT,
    output             HPS_DDR3_RAS_N,
    output             HPS_DDR3_RESET_N,
    input              HPS_DDR3_RZQ,
    output             HPS_DDR3_WE_N,
    output             HPS_ENET_GTX_CLK,
    inout              HPS_ENET_INT_N,
    output             HPS_ENET_MDC,
    inout              HPS_ENET_MDIO,
    input              HPS_ENET_RX_CLK,
    input       [3:0]  HPS_ENET_RX_DATA,
    input              HPS_ENET_RX_DV,
    output      [3:0]  HPS_ENET_TX_DATA,
    output             HPS_ENET_TX_EN,
    inout       [3:0]  HPS_FLASH_DATA,
    output             HPS_FLASH_DCLK,
    output             HPS_FLASH_NCSO,
    inout              HPS_GSENSOR_INT,
    inout              HPS_I2C1_SCLK,
    inout              HPS_I2C1_SDAT,
    inout              HPS_I2C2_SCLK,
    inout              HPS_I2C2_SDAT,
    inout              HPS_I2C_CONTROL,
    inout              HPS_KEY,
    inout              HPS_LED,
    inout              HPS_LTC_GPIO,
    output             HPS_SD_CLK,
    inout              HPS_SD_CMD,
    inout       [3:0]  HPS_SD_DATA,
    output             HPS_SPIM_CLK,
    input              HPS_SPIM_MISO,
    output             HPS_SPIM_MOSI,
    inout              HPS_SPIM_SS,
    input              HPS_UART_RX,
    output             HPS_UART_TX,
    input              HPS_USB_CLKOUT,
    inout       [7:0]  HPS_USB_DATA,
    input              HPS_USB_DIR,
    input              HPS_USB_NXT,
    output             HPS_USB_STP,
    `endif 

    /* Enables IRDA - 3.3V */
    `ifdef ENABLE_IRDA
    input              IRDA_RXD,
    output             IRDA_TXD,
    `endif

    /* Enables KEY - 3.3V */
    `ifdef ENABLE_KEY
    input       [3:0]  KEY,
    `endif

    /* Enables LEDR - 3.3V */
    `ifdef ENABLE_LEDR
    output      [9:0]  LEDR,
    `endif

    /* Enables PS2 - 3.3V */
    `ifdef ENABLE_PS2
    inout              PS2_CLK,
    inout              PS2_CLK2,
    inout              PS2_DAT,
    inout              PS2_DAT2,
    `endif

    /* Enables SW - 3.3V */
    `ifdef ENABLE_SW
    input       [9:0]  SW
    `endif

    /* Enables TD - 3.3V */
    `ifdef ENABLE_TD
    input             TD_CLK27,
    input      [7:0]  TD_DATA,
    input             TD_HS,
    output            TD_RESET_N,
    input             TD_VS,
    `endif

    /* Enables VGA - 3.3V */
    `ifdef ENABLE_VGA
    output      [7:0]  VGA_B,
    output             VGA_BLANK_N,
    output             VGA_CLK,
    output      [7:0]  VGA_G,
    output             VGA_HS,
    output      [7:0]  VGA_R,
    output             VGA_SYNC_N,
    output             VGA_VS
    `endif
);

//=======================================================
//  Reg/wire declarations
//=======================================================
    wire        clk_50mhz;
    wire        clk_locked;
    reg         clk_rst;
    reg  [1:0]  clk_locked_d;
    reg  [7:0]  clk_rst_cnt;
    reg  [25:0] clk_div_cnt;
    wire [3:0]  pio_keys_export;
    wire [31:0] pio_display_export;
    wire [15:0] fir_filter_data_i;
    wire [15:0] fir_filter_data_o;

//=======================================================
//  Structural coding
//=======================================================

    // Instantiate a PLL to create a clock signal at 50 MHz
    osc_50_pll OSC_50_PLL_UNT (
        .refclk  (CLOCK_50),     //  refclk.clk
        .rst     (1'b0),         //   reset.reset
        .outclk_0(clk_50mhz),    // outclk0.clk
        .locked  (clk_locked)    //  locked.export
    );

    // Generate a reset signal if clock signal is not stable
    always @(posedge CLOCK_50) begin
        // Delay by two cycles the clk_locked signal
        clk_locked_d[0] <= clk_locked;
        clk_locked_d[1] <= clk_locked_d;

        // After the clock signal is locked count up to 100
        if(clk_locked_d[0] & ~clk_locked_d[1])
            clk_rst_cnt <= 8'h00;
        else if(clk_rst_cnt < 100)
            clk_rst_cnt <= clk_rst_cnt + 1;

        // While clk_rst_cnt < 100 generate reset
        // signal to ensure stability in the system
        clk_rst <= (clk_rst_cnt < 100);
    end

    // Use a counter to generate divided clock signals
    always @(posedge clk_50mhz) clk_div_cnt <= clk_div_cnt + 1;

    // Instantiate the ARM Hard Processor System (HPS)
    arm_hps ARM_HPS_UNT (
        .clk_clk                        (clk_50mhz),                       //      clk.clk
        .reset_reset_n                  (~clk_rst),                        //    reset.reset_n
        .memory_mem_a                   (HPS_DDR3_ADDR),                   //   memory.mem_a
        .memory_mem_ba                  (HPS_DDR3_BA),                     //         .mem_ba
        .memory_mem_ck                  (HPS_DDR3_CK_P),                   //         .mem_ck
        .memory_mem_ck_n                (HPS_DDR3_CK_N),                   //         .mem_ck_n
        .memory_mem_cke                 (HPS_DDR3_CKE),                    //         .mem_cke
        .memory_mem_cs_n                (HPS_DDR3_CS_N),                   //         .mem_cs_n
        .memory_mem_ras_n               (HPS_DDR3_RAS_N),                  //         .mem_ras_n
        .memory_mem_cas_n               (HPS_DDR3_CAS_N),                  //         .mem_cas_n
        .memory_mem_we_n                (HPS_DDR3_WE_N),                   //         .mem_we_n
        .memory_mem_reset_n             (HPS_DDR3_RESET_N),                //         .mem_reset_n
        .memory_mem_dq                  (HPS_DDR3_DQ),                     //         .mem_dq
        .memory_mem_dqs                 (HPS_DDR3_DQS_P),                  //         .mem_dqs
        .memory_mem_dqs_n               (HPS_DDR3_DQS_N),                  //         .mem_dqs_n
        .memory_mem_odt                 (HPS_DDR3_ODT),                    //         .mem_odt
        .memory_mem_dm                  (HPS_DDR3_DM),                     //         .mem_dm
        .memory_oct_rzqin               (HPS_DDR3_RZQ),                    //         .oct_rzqin
        .pio_keys_export                (KEY),                             // pio_keys.export
        .pio_led_export                 (LEDR),                            //      pio_led.export
        .pio_display_export             (pio_display_export),              //  pio_display.export
        .pio_hps2fpga_export            (fir_filter_data_i),               // pio_hps2fpga.export
        .pio_fpga2hps_export            (fir_filter_data_o)                // pio_fpga2hps.export  
    );

    // Instantiate the FIR wrapper
    fir_filter_wrapper(
        .clk      (clk_div_cnt[8]),    //~100 KHz
        .rst      (clk_rst | ~KEY[0]),
        .data_in  (fir_filter_data_i),
        .data_out (fir_filter_data_o)
    );

//=======================================================
// ************** User Declarations *********************
//=======================================================
// Use this section to instantiate and declare any
// module or signal you need in your design
//======================================================='

    wire [18:0] bin2bcd_out;

    // Instantiate here the BIN2BCD converter to convert
    // the binary output of the HPS to BCD representation
    binary_to_decimal BIN2BCD_UNT(
        .inbcd (pio_display_export[13:0]),
        .outbcd(bin2bcd_out)
    );



    // Instantiate here the DISPLAY LOGIC unit in order
    // to drive the 6 Hex displays of the board.
    display_logic #(.NUM_DISPLAYS(6))
    DISPLAY_LOGIC_UNT(
        .bcd_value({(5'b00000), bin2bcd_out}),
        .display  ({HEX5, HEX4, HEX3, HEX2, HEX1, HEX0})
    );

endmodule