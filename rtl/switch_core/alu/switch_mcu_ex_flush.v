module switch_mcu_ex_flush (
    in_clk                              ,
    in_rst                              ,
    in_cycle_cnt                        ,
    in_flush                            ,
    out_stall                           ,
);
// Inputs
input   wire        in_clk, in_rst      ;
input   wire [3:0]  in_cycle_cnt        ;
input   wire [1:0]  in_flush            ;
// Outputs      
output  reg         out_stall           ;
// States
reg          [2:0]  state               ;
// Flush parameters
localparam FLUSH_DISABLE = 0, FLUSH_CYCLE1 = 1, FLUSH_CYCLE2 = 2;
localparam IDLE = 0, PATH1_STATE1 = 1, PATH1_STATE2 = 2, PATH2_STATE1 = 3;

always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        state <= IDLE;
        out_stall <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(in_cycle_cnt == 4 && in_flush == FLUSH_CYCLE2) begin
                    state <= PATH1_STATE1;
                    out_stall <= 1;
                end else if(in_cycle_cnt == 4 && in_flush == FLUSH_CYCLE1) begin
                    state <= PATH2_STATE1;
                    out_stall <= 1;
                end else begin
                    state <= IDLE;
                    out_stall <= 0;
                end
            end
            PATH1_STATE1: begin
                if(in_cycle_cnt == 4) begin
                    state <= PATH1_STATE2;
                    out_stall <= 1;
                end else begin
                    state <= PATH1_STATE1;
                    out_stall <= 1;
                end
            end
            PATH1_STATE2: begin
                if(in_cycle_cnt == 4) begin
                    state <= IDLE;
                    out_stall <= 0;
                end else begin
                    state <= PATH1_STATE2;
                    out_stall <= 1;
                end
            end
            PATH2_STATE1: begin
                if(in_cycle_cnt == 4) begin
                    state <= IDLE;
                    out_stall <= 0;
                end else begin
                    state <= PATH2_STATE1;
                    out_stall <= 1;
                end
            end
        endcase
    end
end
    
endmodule