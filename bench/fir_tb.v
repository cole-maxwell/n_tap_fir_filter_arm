//==========================================================
//
// Test Bench for 6-Tap FIR Filter
// Last Update: 1/17/22
//
//==========================================================

// Define the time precision of the simulation
`timescale 1ns / 1ns

module fir_tb();

    // Generic parameters of the testbench
    localparam CLK_PERIOD = 10;
    // Declare the number of taps for the FIR filter
    localparam FIR_ORDER = 6; 

    // Generate clock signal
    reg clk;
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Declare 3 arrays to store the coefficients of the FIR filter,
    // the values of the input signal and the expected results
    reg [15:0] coefficients[0:FIR_ORDER-1];
    reg [15:0] signal[0:127];
    reg [15:0] expected_values[0:127];

    // Depending on the FIR_ORDER read the input data and expected results
    // from the text files. Use the makefile in /tests to generate new values.
    initial begin
        if (FIR_ORDER==4) begin
            $readmemh("../../../../tests/4tap/coeff_4tap.txt", coefficients);
            $readmemh("../../../../tests/4tap/signal_in.txt", signal);
            $readmemh("../../../../tests/4tap/expected_values_4tap.txt", expected_values);
        end
        if (FIR_ORDER==6) begin
            $readmemh("../../../../tests/6tap/coeff_6tap.txt", coefficients);
            $readmemh("../../../../tests/6tap/signal_in.txt", signal);
            $readmemh("../../../../tests/6tap/expected_values_6tap.txt", expected_values);
        end
        // Test other N-Tap filters here.
    end

    // Testbench signal declaration
    integer i, signal_idx;
    reg start_testing, test_flag;

    // Signal declaration for Unit Under Test (UUT)
    reg  rst;
    reg  load;
    reg  valid_in;
    wire valid_out;
    reg  [(FIR_ORDER*16)-1:0] coeff_in;
    wire [15:0] signal_in;
    wire [15:0] signal_out;

    // Instantiate the fir module
    fir UUT(
        .clk       (clk),
        .rst       (rst),
        .load      (load),
        .valid_in  (valid_in),
        .valid_out (valid_out),
        .coeff_in  (coeff_in),
        .signal_in (signal_in),
        .signal_out(signal_out)
    );

    // Initialize the coefficient input signal
    initial begin
        for(i=0; i<FIR_ORDER; i=i+1)
            coeff_in[16*i +: 16] = coefficients[i];
    end

    // Use a counter to index the values of the input signal
    always @(posedge clk) begin
        if(rst)
            signal_idx <= 0;
        else if(start_testing & valid_in & (signal_idx < 128))
            signal_idx <= signal_idx + 1;
    end

    // Send the values of the input signal to the FIR module
    assign signal_in = rst ? 0 : signal[signal_idx];

    // Generate valid_in signal
    initial begin
        // Reset valid_in signal
        valid_in = 0;

        // Wait on starting_testing
        wait(start_testing);

        while(signal_idx < 128) begin
            // Assert to one the valid_in
            // signal for one clock cycle
            valid_in = 1;
            #(CLK_PERIOD);
            valid_in = 0;

            // Introduce a delay between each valid_in
            // cycle to mimic the real transmission
            #(CLK_PERIOD*4);
        end
    end

    // Stimulus process
    initial begin
        // Signal initialization
        rst           = 1;
        load          = 0;
        start_testing = 0;
        test_flag     = 1;

        // After 100 ns deassert the reset signal
        #(CLK_PERIOD*10);
        rst = 0;

        // Load the coefficients to the FIR module
        #(CLK_PERIOD*5);
        load = 1;
        #(CLK_PERIOD);
        load = 0;

        // Initiate testing
        start_testing = 1;

        // Synch on the rising edge of the clock
        #(CLK_PERIOD/2);

        // Compare all the outcomes of the FIR module with the expected values and if
        // a mismatch occurs print out to the console a message to inform the user
        while(signal_idx < 128) begin
            if(valid_out & signal_out != expected_values[signal_idx]) begin
                $display("FAIL: index: %4d, actual output: 0x%h, expected: 0x%h", signal_idx, signal_out, expected_values[signal_idx]);
                test_flag = 0;
            end

            // Add a delay cycle to the while-loop
            #(CLK_PERIOD);
        end

        // Reset FIR module
        rst = 1;
        start_testing = 0;

        // Print out a message about the total result of the simulation
        if(test_flag)
            $display("\nSUCCESS: the UUT passed ALL the test cases");
        else
            $display("\nFAIL: at least one outcome of the UUT did not match with the expected one");
    end

endmodule // fir6_tb