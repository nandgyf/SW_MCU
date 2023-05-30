module switch_mcu_alu_ori (
    in_clk                              ,
    in_rst                              ,
    in_cycle_cnt                        ,

    in_en                               ,
    in_imm_type_i                       ,
    in_rs1                              ,
    in_rd                               ,

    in_rdata_1                          ,
    out_raddr_1                         ,
    out_ren_1                           ,

    out_waddr                           ,
    out_wen                             ,
    out_wdata                           ,
);
// Global signals
input  wire          in_clk             ;
input  wire          in_rst             ;
input  wire [3:0]    in_cycle_cnt       ;
// Signals from decoder 
input  wire          in_en              ;
input  wire [11:0]   in_imm_type_i      ;
input  wire [4:0]    in_rs1             ;
input  wire [4:0]    in_rd              ;
// Read port    
input  wire [31:0]   in_rdata_1         ;
output reg           out_ren_1          ;
output reg [4:0]     out_raddr_1        ;
// Write port   
output reg [4:0]     out_waddr          ;
output reg           out_wen            ;
output reg [31:0]    out_wdata          ;

always@(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        out_raddr_1 <= 0;
        out_ren_1   <= 0;
        
        out_waddr <= 0;
        out_wen   <= 0;
        out_wdata <= 0;
    end else if(in_en)begin
        if(in_cycle_cnt == 1) begin
            out_raddr_1 <= in_rs1;
            out_ren_1 <= 1;

            out_waddr <= 0;
            out_wen   <= 0;
            out_wdata <= 0;
        end else if(in_cycle_cnt == 2) begin
            out_raddr_1 <= 0;
            out_ren_1 <= 0;

            out_waddr <= 0;
            out_wen   <= 0;
            out_wdata <= 0;
        end else if(in_cycle_cnt == 3) begin
            out_raddr_1 <= 0;
            out_ren_1 <= 0;

            out_waddr <= 0;
            out_wen   <= 0;
            out_wdata <= 0;
        end else if(in_cycle_cnt == 4)begin
            out_raddr_1 <= 0;
            out_ren_1 <= 0;

            out_waddr <= in_rd;
            out_wen   <= 1;
            out_wdata <= in_rdata_1 | {{20{in_imm_type_i[11]}}, in_imm_type_i};
        end
    end else begin
        out_raddr_1 <= 0;
        out_ren_1   <= 0;

        out_waddr <= 0;
        out_wen   <= 0;
        out_wdata <= 0;
    end
end

endmodule