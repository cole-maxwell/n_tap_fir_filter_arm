//==========================================================
//
// Single tap instantiated N times by 'fir.sv'
//
// Last update on 02/18/2022
// Created by Cole Maxwell
//
//==========================================================

module fir_tap(
    input  logic clk, rst, enable,
    input  logic [15:0] coeff_in, signal_in, prev_tap_result,
    output logic [15:0] signal_del, signal_out);

    // Delay one cycle the input signal
    always_ff @(posedge clk or posedge rst) begin
        if(rst)
            signal_del <= '0;
        else
            if(enable)
                signal_del <= signal_in;
    end

    // Combinational logic of one Multiplier-Accumulator (MAC)
    assign signal_out = (signal_del * coeff_in) + prev_tap_result;

endmodule // fir_tap