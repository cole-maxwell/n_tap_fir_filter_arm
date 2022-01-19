module fir_filter_wrapper #(
    parameter SIGNAL_SIZE_LOG = 7 // Define the size of the input
    )(                            // signal in the form 2^n
    input  wire clk,
    input  wire rst,
    input  wire [15:0] data_in,
    output reg  [15:0] data_out
    );

    // Symbolic state declaration for Wrapper FSMD
    reg [3:0] state_reg, state_next;
    localparam [3:0]
        idle         = 'h0,
        receive_word = 'h1,
        read_fifo    = 'h2,
        send_word    = 'h3,
        reset_pio    = 'h4;
    
    // Wire and reg declaration
    wire [15:0] fifo_data_in;
    wire [15:0] fifo_data_out;
    reg  [7:0]  cnt_values;
    reg  [15:0] prev_data;
    reg  [15:0] prev_data_next;
    reg  [15:0] data_out_next;
    reg  [15:0] fir_data_in_next;
    reg         fir_vld_in_next;
    reg         incr_cnt_val;
    reg         fifo_read;
    reg         last_word;
    wire        fifo_empty;
    wire        fifo_full;




    //===================================================
    // User wire and reg declarations
    //===================================================
    reg         fir_valid_in;
    reg  [15:0] fir_data_in;
    wire [15:0] fir_data_out;
    wire        fir_valid_out;

    // Instantiate FIR module
    fir FIR_UNT(
        .clk       (clk),
        .rst       (rst),
        .load      (1'b1),
        .valid_in  (fir_valid_in),
        .valid_out (fir_valid_out),
        .coeff_in  ({16'd7, 16'd6, 16'd7, 16'd2}),
        .signal_in (fir_data_in),
        .signal_out(fir_data_out)
        );
    //===================================================
    //===================================================



    // Check for reserved values (16'h8000, 16'h8001)
    assign fifo_data_in = ((fir_data_out == 16'h8000) | (fir_data_out == 16'h8001)) ? 16'h8002 : fir_data_out;

    // Instantiate an output FIFO unit
    fifo #(
        .WIDTH(16),
        .DEPTH_LOG(SIGNAL_SIZE_LOG))
    FIFO_UNT(
        .clk            (clk),
        .s_axis_tvalid  (fir_valid_out),
        .s_axis_tdata   (fifo_data_in),
        .m_axis_tready  (fifo_read),
        .m_axis_tdata   (fifo_data_out),
        .axis_prog_empty(fifo_empty),
        .axis_prog_full (fifo_full)
        );


    // FSMD-Wrapper state & data registers
    always @(posedge clk) begin
        if(rst) begin
            state_reg    <= idle;
            prev_data    <= data_in;
            data_out     <= 16'h0000; // ** Don't write on the HPS's input PIO during reset! (e.g. 0xFFFF)
            fir_data_in  <= 16'h0000;
            fir_valid_in <= 1'b0;
            cnt_values   <= 8'h00;
            last_word    <= 1'b0;
        end else begin
            state_reg    <= state_next;
            data_out     <= data_out_next;
            prev_data    <= prev_data_next;
            fir_data_in  <= fir_data_in_next;
            fir_valid_in <= fir_vld_in_next;

            if(incr_cnt_val)
                cnt_values <= cnt_values + 1;

            if((state_reg == reset_pio)  & fifo_empty)
                last_word <= 1'b1;
            else if(state_reg == idle)
                last_word <= 1'b0;
        end
    end

    // FSMD-Wrapper data path next-state logic
    always @(*) begin
        state_next       = state_reg; // Default state
        prev_data_next   = prev_data;
        data_out_next    = 16'h0000;
        fir_data_in_next = fir_data_in;
        fir_vld_in_next  = 1'b0;
        incr_cnt_val     = 1'b0;
        fifo_read        = 1'b0;

        case(state_reg)
            // -------------------------------------------------------
            idle: begin
                if(cnt_values < (2**SIGNAL_SIZE_LOG)) begin
                    // If a new word comes go to
                    // the receive_word state
                    if(prev_data != data_in)
                        state_next = receive_word;
                    else
                        state_next = idle;
                end else begin
                    // Read the values of the FIFO if it is not empty
                    // and the FIR module has finished the processing
                    if(fifo_full & ~fir_valid_out)
                        state_next = read_fifo;
                    else
                        state_next = idle;
                end
            end

            // -------------------------------------------------------
            receive_word: begin
                // Update the prev_data register
                // and send to HPS an ACK message
                prev_data_next = data_in;
                data_out_next  = 16'h8001;
                state_next     = idle;

                // Place the incoming data on the input
                // port of the FIR module. Ignore the
                // value 0x8001 which is used by the HPS
                // to signal a successful transmission
                if(data_in != 16'h8001) begin
                    incr_cnt_val     = 1'b1;
                    fir_vld_in_next  = 1'b1;
                    fir_data_in_next = data_in;
                end
            end

            // -------------------------------------------------------
            read_fifo: begin
                fifo_read     = 1'b1;
                data_out_next = data_out; // Keep the same data
                state_next    = send_word;
            end

            // -------------------------------------------------------
            send_word: begin
                // Whenever FIFO outputs a zero value transmit the value
                // 0x8001 instead, because the value zero cannot trigger
                // the input PIO of the HPS system
                if(fifo_data_out == 16'h0000)
                    data_out_next = 16'h8000;
                else
                    data_out_next = fifo_data_out;

                state_next    = reset_pio;
            end

            // -------------------------------------------------------
            reset_pio: begin
                data_out_next = 16'h8001;

                if(fifo_empty & last_word)
                    state_next = idle;
                else
                    state_next = read_fifo;
            end

            // -------------------------------------------------------
            default: state_next = idle;
        endcase
    end

endmodule // fir_filter_wrapper