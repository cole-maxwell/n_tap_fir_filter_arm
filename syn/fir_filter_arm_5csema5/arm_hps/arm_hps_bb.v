
module arm_hps (
	clk_clk,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	pio_display_export,
	pio_fpga2hps_export,
	pio_hps2fpga_export,
	pio_keys_export,
	pio_led_export,
	reset_reset_n);	

	input		clk_clk;
	output	[12:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[7:0]	memory_mem_dq;
	inout		memory_mem_dqs;
	inout		memory_mem_dqs_n;
	output		memory_mem_odt;
	output		memory_mem_dm;
	input		memory_oct_rzqin;
	output	[31:0]	pio_display_export;
	input	[15:0]	pio_fpga2hps_export;
	output	[15:0]	pio_hps2fpga_export;
	input	[3:0]	pio_keys_export;
	output	[9:0]	pio_led_export;
	input		reset_reset_n;
endmodule
