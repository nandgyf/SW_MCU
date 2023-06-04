module switch_mcu_ex_type_i (
    in_clk                              ,
    in_rst                              ,
    in_cycle_cnt                        ,

    in_en                               ,
    in_addi                             ,
    in_slti                             ,
    in_sltiu                            ,
    in_xori                             ,
    in_ori                              ,
    in_andi                             ,
    in_slli                             ,
    in_srli                             ,
    in_srai                             ,
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
input  wire          in_addi            ;
input  wire          in_slti            ;
input  wire          in_sltiu           ;
input  wire          in_xori            ;
input  wire          in_ori             ;
input  wire          in_andi            ;
input  wire          in_slli            ;
input  wire          in_srli            ;
input  wire          in_srai            ;
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
            if(in_addi)
                out_wdata <= {{20{in_imm_type_i[11]}}, in_imm_type_i} + in_rdata_1;
            else if(in_slti)
                out_wdata <= $signed(in_rdata_1) < $signed({{20{in_imm_type_i[11]}}, in_imm_type_i});
            else if(in_sltiu)
                out_wdata <= in_rdata_1 < {{20{in_imm_type_i[11]}}, in_imm_type_i};
            else if(in_xori)
                out_wdata <= in_rdata_1 ^ {{20{in_imm_type_i[11]}}, in_imm_type_i};
            else if(in_ori)
                out_wdata <= in_rdata_1 | {{20{in_imm_type_i[11]}}, in_imm_type_i};
            else if(in_andi)
                out_wdata <= in_rdata_1 & {{20{in_imm_type_i[11]}}, in_imm_type_i};
            else if(in_slli)
                out_wdata <= in_rdata_1 << in_imm_type_i[4:0];
            else if(in_srli)
                out_wdata <= in_rdata_1 >> in_imm_type_i[4:0];
            else if(in_srai)
                out_wdata <= $signed(in_rdata_1) >>> in_imm_type_i[4:0];
            else
                out_wdata <= 0;
            end else begin
                out_raddr_1 <= 0;
                out_ren_1 <= 0;
    
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

endmodule