module display_logic #(
	parameter NUM_DISPLAYS = 6
	)(
	input  wire [(NUM_DISPLAYS*4)-1:0] bcd_value,
	output wire [(NUM_DISPLAYS*7)-1:0] display);

	// Instantiate one display decoder for each display of the board
	genvar i;
    generate
        for(i=0; i<NUM_DISPLAYS; i=i+1) begin: DISPLAY_DECODER_GEN
        	display_decoder DISPLAY_DECODER_UNT(
        		.bcd_digit(bcd_value[i*4+:4]),
        		.display  (display[i*7+:7])
        	);
        end
    endgenerate

endmodule // display_logic