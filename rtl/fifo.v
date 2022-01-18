//==========================================================
// Company:         
// Engineer:        G.Provelengios
// 
// Created Date:    Dec 5, 2014
// Design:          FIFO with AXI Stream interface
// Module Name:     fifo.v
// Project Name:    
//
// Comments:        
//
//===========================================================
module fifo #(
    parameter WIDTH     = 32,
    parameter DEPTH_LOG = 5
    )(
    input  wire clk,
    output reg  s_axis_tready,
    input  wire s_axis_tvalid,
    input  wire [WIDTH-1:0] s_axis_tdata,
    input  wire m_axis_tready,
    output reg  m_axis_tvalid,
    output reg  [WIDTH-1:0] m_axis_tdata,
    output wire axis_prog_full,
    output wire axis_prog_empty
    );

    // Signal declaration
    reg  [WIDTH-1:0] fifo_array [0:2**DEPTH_LOG-1];
    wire [DEPTH_LOG-1:0] wt_cnt_temp, rd_cnt_temp;
    reg  [DEPTH_LOG-1:0] wt_cnt_reg = 'b0,  wt_cnt = 'b0;
    reg  [DEPTH_LOG-1:0] rd_cnt_reg = 'b0,  rd_cnt = 'b0;
    reg  full      = 'b0;
    reg  full_reg  = 'b0;
    reg  empty     = 'b1;
    reg  empty_reg = 'b1;

    //
    assign axis_prog_full  = full_reg;
    assign axis_prog_empty = empty_reg;
    assign wt_cnt_temp = (wt_cnt_reg < 2**DEPTH_LOG-1) ? (wt_cnt_reg + 1) : {DEPTH_LOG{1'b0}};
    assign rd_cnt_temp = (rd_cnt_reg < 2**DEPTH_LOG-1) ? (rd_cnt_reg + 1) : {DEPTH_LOG{1'b0}};

    // Reigster file write/read operation
    always @(posedge clk) begin
        if(s_axis_tvalid & ~full_reg)
            fifo_array[wt_cnt_reg] <= s_axis_tdata;

        // Output register
        m_axis_tdata <= fifo_array[rd_cnt_reg];
    end

    // Register FIFO Control Signals
    always @(posedge clk) begin
        s_axis_tready <= ~full;
        m_axis_tvalid <= ~empty_reg & m_axis_tready;
    
        wt_cnt_reg <= wt_cnt;
        rd_cnt_reg <= rd_cnt; 
        full_reg   <= full;
        empty_reg  <= empty;
    end

    //
    always @(*) begin
        wt_cnt = wt_cnt_reg;
        rd_cnt = rd_cnt_reg;
        full   = full_reg;
        empty  = empty_reg;

        case({s_axis_tvalid, m_axis_tready})
            // 2'b00: no operation

            // -- Read Operation -----------------------------------------
            2'b01: begin
                if(~empty_reg) begin // Not empty
                    rd_cnt = rd_cnt_temp;
                    full   = 1'b0;
                    
                    if(rd_cnt_temp == wt_cnt_reg)
                        empty <= 1'b1;
                end
            end

            // -- Write Operation -----------------------------------------
            2'b10: begin
                if(~full_reg) begin // Not full
                    wt_cnt = wt_cnt_temp;
                    empty  = 1'b0;

                    if(wt_cnt_temp == rd_cnt_reg)
                        full = 1'b1;
                end
            end

            // -- Write/read Operation ------------------------------------
            2'b11: begin
                wt_cnt = wt_cnt_temp;
                rd_cnt = rd_cnt_temp;
            end
        endcase
    end

    // Initiliazation block only for simulation
    integer i;
    initial
        for(i=0; i<(2**DEPTH_LOG); i=i+1)
            fifo_array[i] = 'b0;

endmodule