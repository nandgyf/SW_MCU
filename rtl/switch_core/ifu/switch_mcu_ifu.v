module switch_mcu_ifu (
    in_clk          ,
    in_rst          ,
    in_init_done    ,

    in_hready       ,
    in_hresp        ,
    in_hrdata       ,

    out_haddr       ,
    out_hwrite      ,
    out_hsize       ,
    out_hburst      ,
    out_hport       ,
    out_htrans      ,
    out_hmastlock   ,

    out_pc_reg      ,
    out_inst        ,
    out_cycle_cnt   ,
);
// State machine parameters
parameter   IDLE = 3'd0     ,
            STATE1 = 3'd1   ,
            STATE2 = 3'd2   ;

// Global signals
input   wire          in_clk          ;
input   wire          in_rst          ;
input   wire          in_init_done    ;
//  AHB Bus signals
input   wire          in_hready       ;
input   wire          in_hresp        ;
input   wire [31:0]   in_hrdata       ;
output  reg  [31:0]   out_haddr       ;
output  wire          out_hwrite      ;
output  wire [3:0]    out_hsize       ;
output  wire [3:0]    out_hport       ;
output  wire [2:0]    out_hburst      ;
output  reg  [1:0]    out_htrans      ;
output  wire          out_hmastlock   ;
// Pointer Counter
output  reg  [31:0]   out_pc_reg      ;
// Instructions putput
output  reg  [31:0]   out_inst        ;
// Counter
output  reg  [3:0]    out_cycle_cnt ;

// State machine signals
reg  [1:0]            state           ;
wire [1:0]            next_state      ;

// Temp instruction
reg  [31:0]           temp_inst       ;

// pc_reg singal
always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst)
        out_pc_reg <= 0;
    else if(out_cycle_cnt == 1)
        out_pc_reg <= out_pc_reg + 4;
    else
        out_pc_reg <= out_pc_reg;
end

// Counter logic
always@(posedge in_clk or negedge in_rst) begin
    if(!in_rst | !in_init_done)
    out_cycle_cnt <= 0;
    else if(out_cycle_cnt == 4)
        if(state == IDLE)
            out_cycle_cnt <= 0;
        else
            out_cycle_cnt <= out_cycle_cnt;
    else
        out_cycle_cnt <= out_cycle_cnt + 1;
end

// States update
always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        state <= 3'd0;
        out_htrans <= 0;
        out_haddr <= 0;
        out_inst <= 0;
        temp_inst <= 0;
    end else begin
        case(state)
            IDLE:
                if(out_cycle_cnt == 1) begin
                    state <= STATE1;
                    out_htrans <= 1;
                    out_haddr <= out_pc_reg;
                    temp_inst <= temp_inst;
                end else begin
                    state <= IDLE;
                    out_htrans <= 0;
                    out_haddr <= 0;
                    temp_inst <= temp_inst;
                end
            STATE1:
                if(in_hready) begin
                    state <= STATE2;
                    out_htrans <= 0;
                    out_haddr <= 0;
                    temp_inst <= temp_inst;
                end else begin
                    state <= STATE1;
                    out_htrans <= out_htrans;
                    out_haddr <= out_haddr;
                    temp_inst <= temp_inst;
                end
            STATE2:
                if(in_hready) begin
                    state <= IDLE;
                    out_htrans <= 0;
                    out_haddr <= 0;
                    temp_inst <= in_hrdata;
                end else begin
                    state <= STATE2;
                    out_htrans <= 0;
                    out_haddr <= 0;
                    temp_inst <= temp_inst;
                end
            default: begin
                state <= IDLE;
                out_htrans <= 0;
                out_haddr <= 0;
                temp_inst <= temp_inst;
            end
        endcase
    end
end

// Instruction update
always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst)
        out_inst <= 0;
    else if(out_cycle_cnt == 0)
        out_inst <= temp_inst;
    else
        out_inst <= out_inst;
end

// out_hwrite
assign out_hwrite = 0;

// out_hsize
assign out_hsize = 2; //Word

// out_hburst
assign out_hburst = 0; //Single

// out_hmastlock
assign out_hmastlock = 0;

// out_hport
assign out_hport = 4'b0011;

endmodule