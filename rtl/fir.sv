//==========================================================
//
// Modular FIR module for N-Tap instantiation.
//
// Last update on 02/18/2022
// Created by Cole Maxwell
//
//==========================================================

module fir #(

	// Define Tap Order / Number of Taps
	parameter N = 4
		)(
    input  logic clk, rst, load,
    input  logic valid_in,
    output logic valid_out,
    input  logic [(N*16)-1:0] coeff_in,
    input  logic [15:0] signal_in,
    output logic [15:0] signal_out);

    // Signal declaration
    logic [(N*16)-1:0] coeff_reg;
    logic [15:0] first_tap;
    logic [15:0] signal_array[N-2];
    logic [15:0] signal_del_array[N-2];

    // Valid out
    assign valid_out = valid_in;

    // First Tap multiplication
    assign first_tap = signal_in * coeff_reg[15:0];
	 
	 // Instantiate Tap2
    fir_tap TAP2 (
        .clk            (clk),
        .rst            (rst),
        .enable         (valid_in),
        .coeff_in       (coeff_in[31:16]),
        .signal_in      (signal_in),
        .signal_out     (signal_array[0]),
        .signal_del     (signal_del_array[0]),
        .prev_tap_result(first_tap));

	// Generate the Taps 3 to N-1
	genvar i;
	generate
		for(i=0; i<(N-3); i=i+1) begin: TAP_GEN
        fir_tap FIR_UNT(
			  .clk            (clk),
			  .rst            (rst),
			  .enable         (valid_in),
			  .coeff_in       (coeff_in[((i+3)*16)-1:(i+2)*16]),
			  .signal_in      (signal_del_array[i]),
			  .signal_out     (signal_array[i+1]),
			  .signal_del     (signal_del_array[i+1]),
			  .prev_tap_result(signal_array[i]));
		end
	endgenerate

	// Instantiate the Nth Tap
    fir_tap FINAL_TAP (
        .clk            (clk),
        .rst            (rst),
        .enable         (valid_in),
        .coeff_in       (coeff_in[(N*16)-1:(N-1)*16]),
        .signal_in      (signal_del_array[N-3]),
        .signal_out     (signal_out),
        .signal_del     (),
        .prev_tap_result(signal_array[N-3]));

    // Store the coefficient of tap into a register
    always_ff @(posedge clk or posedge rst or posedge load) begin
        if(rst)
            coeff_reg <= '0;
        else if(load)
            coeff_reg <= coeff_in;
    end


endmodule // fir