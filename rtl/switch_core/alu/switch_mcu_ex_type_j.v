module switch_mcu_ex_type_j (
    in_clk                                  ,
    in_rst                                  ,
    in_cycle_cnt                            ,
    in_en                                   ,
    in_jal                                  ,
    in_jalr                                 ,
    in_imm_type_j                           ,
    in_imm_type_i                           ,
    in_rs1                                  ,
    in_rd                                   ,
    
    in_rdata_1                              ,
    out_raddr_1                             ,
    out_ren_1                               ,
    
    out_waddr                               ,
    out_wen                                 ,
    out_wdata                               ,

    in_pc_reg                               ,
    out_pc_override                         ,
    out_pc_write                            ,

    out_flush                               ,
);
// Global signals
input  wire             in_clk              ;
input  wire             in_rst              ;
input  wire [3:0]       in_cycle_cnt        ;
// Signals from decoder 
input  wire             in_en               ;
input  wire             in_jal              ;
input  wire             in_jalr             ;
input  wire [19:0]      in_imm_type_j       ;
input  wire [11:0]      in_imm_type_i       ;
input  wire [4:0]       in_rs1              ;
input  wire [4:0]       in_rd               ;
// Read port 1
input  wire [31:0]      in_rdata_1          ;
output reg              out_ren_1           ;
output reg  [4:0]       out_raddr_1         ;
// Write port    
output reg  [4:0]       out_waddr           ;
output reg              out_wen             ;
output reg  [31:0]      out_wdata           ;
// PC reg control signals
input  wire [31:0]      in_pc_reg           ;
output reg              out_pc_override     ;
output reg  [31:0]      out_pc_write        ;
// Flush pipeline signal
output reg  [1:0]       out_flush           ;
// Flush parameters
localparam FLUSH_DISABLE = 0, FLUSH_CYCLE1 = 1, FLUSH_CYCLE2 = 2;
// SEXT values
wire [31:0] sext_imm_type_j = {{12{in_imm_type_j[19]}}, in_imm_type_j};
wire [31:0] sext_imm_type_i = {{20{in_imm_type_i[11]}}, in_imm_type_i};

always@(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        out_raddr_1 <= 0;
        out_ren_1   <= 0;

        out_waddr   <= 0;
        out_wen     <= 0;
        out_wdata   <= 0;
    end else if(in_en) begin
        if(in_cycle_cnt == 1)begin
            if(in_jalr) begin
                out_raddr_1 <= in_rs1;
                out_ren_1   <= 1;
            end else begin
                out_raddr_1 <= 0;
                out_ren_1   <= 0;
            end

            out_waddr   <= 0;
            out_wen     <= 0;
            out_wdata   <= 0;
        end else if(in_cycle_cnt == 2)begin
            out_raddr_1 <= 0;
            out_ren_1   <= 0;

            out_waddr   <= 0;
            out_wen     <= 0;
            out_wdata   <= 0;
        end else if(in_cycle_cnt == 3)begin
            out_raddr_1 <= 0;
            out_ren_1   <= 0;

            out_waddr <= in_rd;
            out_wen   <= 1;
            if(in_jal || in_jalr)
                out_wdata <= in_pc_reg - 4;
            else
                out_wdata <= 0;
        end else begin
            out_raddr_1 <= 0;
            out_ren_1   <= 0;

            out_waddr <= 0;
            out_wen   <= 0;
            out_wdata <= 0;
        end
    end else begin
        out_raddr_1 <= 0;
        out_ren_1   <= 0;

        out_waddr <= 0;
        out_wen   <= 0;
        out_wdata <= 0;
    end
end

always@(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        out_flush <= 0;
    end else if(in_en) begin
        if(in_cycle_cnt == 1)begin
            if(in_jal) begin
                if(sext_imm_type_j == 4)
                    out_flush <= FLUSH_DISABLE;
                else if(sext_imm_type_j == 8)
                    out_flush <= FLUSH_CYCLE1;
                else
                    out_flush <= FLUSH_CYCLE2;
            end else if(in_jalr) begin
                out_flush <= FLUSH_CYCLE2;
            end else begin
                out_flush <= 0;
            end
        end else begin
            out_flush <= out_flush;
        end
    end else begin
        out_flush <= 0;
    end
end

always@(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        out_pc_override <= 0;
        out_pc_write    <= 0;
    end else if(in_en) begin
        if(in_cycle_cnt == 3)begin
            if(sext_imm_type_j == 4 && sext_imm_type_j == 8) begin
                out_pc_override <= 0;
                out_pc_write    <= 0;
            end else begin
                if(in_jal) begin
                    out_pc_override <= 1;
                    out_pc_write    <= in_pc_reg - 8 + sext_imm_type_j;
                end else if(in_jalr) begin
                    out_pc_override <= 1;
                    out_pc_write    <= (in_rs1 + sext_imm_type_i) & ~1;
                end else begin
                    out_pc_override <= 0;
                    out_pc_write    <= 0;
                end
            end
        end else begin
            out_pc_override <= out_pc_override;
            out_pc_write    <= out_pc_write;
        end
    end else begin
        out_pc_override <= 0;
        out_pc_write    <= 0;
    end
end


endmodule