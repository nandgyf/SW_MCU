module switch_mcu_alu_auipc (
    in_clk          ,
    in_rst          ,
    in_cycle_cnt    ,
    in_pc_reg       ,
    in_en           ,
    in_imm_type_u   ,
    in_rd           ,

    out_waddr       ,
    out_wen         ,
    out_wdata       ,
);
// Global signals
input wire          in_clk           ;
input wire          in_rst           ;
input wire [3:0]    in_cycle_cnt     ;
// Signals from decoder
input wire [31:0]   in_pc_reg        ;
input wire          in_en            ;
input wire [19:0]   in_imm_type_u    ;
input wire [4:0]    in_rd            ;
// Write port
output reg [4:0]    out_waddr        ;
output reg          out_wen          ;
output reg [31:0]   out_wdata        ;

always@(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        out_waddr <= 0;
        out_wen   <= 0;
        out_wdata <= 0;
    end else if(in_en) begin
        if(in_cycle_cnt == 1)begin
            out_waddr <= in_rd;
            out_wen   <= 1;
            out_wdata <= (in_imm_type_u << 12) + (in_pc_reg - 4);
        end else begin
            out_waddr <= 0;
            out_wen   <= 0;
            out_wdata <= 0;
        end
    end else begin
        out_waddr <= 0;
        out_wen   <= 0;
        out_wdata <= 0;
    end
end

endmodule