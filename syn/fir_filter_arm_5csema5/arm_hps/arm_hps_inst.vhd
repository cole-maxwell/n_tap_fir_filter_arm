	component arm_hps is
		port (
			clk_clk             : in    std_logic                     := 'X';             -- clk
			memory_mem_a        : out   std_logic_vector(12 downto 0);                    -- mem_a
			memory_mem_ba       : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck       : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n     : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke      : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n     : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n    : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n    : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n     : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n  : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq       : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dq
			memory_mem_dqs      : inout std_logic                     := 'X';             -- mem_dqs
			memory_mem_dqs_n    : inout std_logic                     := 'X';             -- mem_dqs_n
			memory_mem_odt      : out   std_logic;                                        -- mem_odt
			memory_mem_dm       : out   std_logic;                                        -- mem_dm
			memory_oct_rzqin    : in    std_logic                     := 'X';             -- oct_rzqin
			pio_display_export  : out   std_logic_vector(31 downto 0);                    -- export
			pio_fpga2hps_export : in    std_logic_vector(15 downto 0) := (others => 'X'); -- export
			pio_hps2fpga_export : out   std_logic_vector(15 downto 0);                    -- export
			pio_keys_export     : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			pio_led_export      : out   std_logic_vector(9 downto 0);                     -- export
			reset_reset_n       : in    std_logic                     := 'X'              -- reset_n
		);
	end component arm_hps;

	u0 : component arm_hps
		port map (
			clk_clk             => CONNECTED_TO_clk_clk,             --          clk.clk
			memory_mem_a        => CONNECTED_TO_memory_mem_a,        --       memory.mem_a
			memory_mem_ba       => CONNECTED_TO_memory_mem_ba,       --             .mem_ba
			memory_mem_ck       => CONNECTED_TO_memory_mem_ck,       --             .mem_ck
			memory_mem_ck_n     => CONNECTED_TO_memory_mem_ck_n,     --             .mem_ck_n
			memory_mem_cke      => CONNECTED_TO_memory_mem_cke,      --             .mem_cke
			memory_mem_cs_n     => CONNECTED_TO_memory_mem_cs_n,     --             .mem_cs_n
			memory_mem_ras_n    => CONNECTED_TO_memory_mem_ras_n,    --             .mem_ras_n
			memory_mem_cas_n    => CONNECTED_TO_memory_mem_cas_n,    --             .mem_cas_n
			memory_mem_we_n     => CONNECTED_TO_memory_mem_we_n,     --             .mem_we_n
			memory_mem_reset_n  => CONNECTED_TO_memory_mem_reset_n,  --             .mem_reset_n
			memory_mem_dq       => CONNECTED_TO_memory_mem_dq,       --             .mem_dq
			memory_mem_dqs      => CONNECTED_TO_memory_mem_dqs,      --             .mem_dqs
			memory_mem_dqs_n    => CONNECTED_TO_memory_mem_dqs_n,    --             .mem_dqs_n
			memory_mem_odt      => CONNECTED_TO_memory_mem_odt,      --             .mem_odt
			memory_mem_dm       => CONNECTED_TO_memory_mem_dm,       --             .mem_dm
			memory_oct_rzqin    => CONNECTED_TO_memory_oct_rzqin,    --             .oct_rzqin
			pio_display_export  => CONNECTED_TO_pio_display_export,  --  pio_display.export
			pio_fpga2hps_export => CONNECTED_TO_pio_fpga2hps_export, -- pio_fpga2hps.export
			pio_hps2fpga_export => CONNECTED_TO_pio_hps2fpga_export, -- pio_hps2fpga.export
			pio_keys_export     => CONNECTED_TO_pio_keys_export,     --     pio_keys.export
			pio_led_export      => CONNECTED_TO_pio_led_export,      --      pio_led.export
			reset_reset_n       => CONNECTED_TO_reset_reset_n        --        reset.reset_n
		);

