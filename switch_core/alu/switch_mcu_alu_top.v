module switch_mcu_alu_top(
    in_clk                      ,
    in_rst                      ,
    in_cycle_cnt                ,               
    in_pc_reg                   ,
    in_lui                      ,
    in_auipc                    ,
    in_jal                      ,
    in_jalr                     ,
    in_beq                      ,
    in_bne                      ,
    in_blt                      ,
    in_bge                      ,
    in_bltu                     ,
    in_bgeu                     ,
    in_lb                       ,
    in_lh                       ,
    in_lw                       ,
    in_lbu                      ,
    in_lhu                      ,
    in_sb                       ,
    in_sh                       ,
    in_sw                       ,
    in_addi                     ,
    in_slti                     ,
    in_sltiu                    ,
    in_xori                     ,
    in_ori                      ,
    in_andi                     ,
    in_slli                     ,
    in_srli                     ,
    in_srai                     ,
    in_add                      ,
    in_sub                      ,
    in_sll                      ,
    in_slt                      ,
    in_sltu                     ,
    in_xor                      ,
    in_srl                      ,
    in_sra                      ,
    in_or                       ,
    in_and                      ,
    in_fence                    ,
    in_fence_i                  ,
    in_ecall                    ,
    in_ebreak                   ,
    in_csrrw                    ,
    in_csrrs                    ,
    in_csrrc                    ,
    in_csrrwi                   ,
    in_csrrsi                   ,
    in_csrrci                   ,
    in_rs2                      ,
    in_rs1                      ,
    in_rd                       ,
    in_imm_type_i               ,
    in_imm_type_s               ,
    in_imm_type_b               ,
    in_imm_type_u               ,
    in_imm_type_j
);

// Inputs
input wire         in_clk         ;
input wire         in_rst         ;
input wire [3:0]   in_cycle_cnt   ;
input wire [31:0]  in_pc_reg      ;
input wire         in_lui         ;
input wire         in_auipc       ;
input wire         in_jal         ;
input wire         in_jalr        ;
input wire         in_beq         ;
input wire         in_bne         ;
input wire         in_blt         ;
input wire         in_bge         ;
input wire         in_bltu        ;
input wire         in_bgeu        ;
input wire         in_lb          ;
input wire         in_lh          ;
input wire         in_lw          ;
input wire         in_lbu         ;
input wire         in_lhu         ;
input wire         in_sb          ;
input wire         in_sh          ;
input wire         in_sw          ;
input wire         in_addi        ;
input wire         in_slti        ;
input wire         in_sltiu       ;
input wire         in_xori        ;
input wire         in_ori         ;
input wire         in_andi        ;
input wire         in_slli        ;
input wire         in_srli        ;
input wire         in_srai        ;
input wire         in_add         ;
input wire         in_sub         ;
input wire         in_sll         ;
input wire         in_slt         ;
input wire         in_sltu        ;
input wire         in_xor         ;
input wire         in_srl         ;
input wire         in_sra         ;
input wire         in_or          ;
input wire         in_and         ;
input wire         in_fence       ;
input wire         in_fence_i     ;
input wire         in_ecall       ;
input wire         in_ebreak      ;
input wire         in_csrrw       ;
input wire         in_csrrs       ;
input wire         in_csrrc       ;
input wire         in_csrrwi      ;
input wire         in_csrrsi      ;
input wire         in_csrrci      ;

input wire [4:0]   in_rs2         ;
input wire [4:0]   in_rs1         ;
input wire [4:0]   in_rd          ;
input wire [11:0]  in_imm_type_i  ;
input wire [11:0]  in_imm_type_s  ;
input wire [11:0]  in_imm_type_b  ;
input wire [19:0]  in_imm_type_u  ;
input wire [18:0]  in_imm_type_j  ;

// Wires for regfile operation
// Write
wire  [4:0]        mid_waddr       ;
wire               mid_wen         ;
wire  [31:0]       mid_wdata       ;
// Read 1
wire  [4:0]        mid_raddr_1     ;
wire               mid_ren_1       ;
wire  [31:0]       mid_rdata_1     ;
// Read 2
wire  [4:0]        mid_raddr_2     ;
wire               mid_ren_2       ;
wire  [31:0]       mid_rdata_2     ;

switch_mcu_regfile switch_mcu_regfile_dut (
    .in_clk      (in_clk        ),
    .in_rst      (in_rst        ),
    .in_waddr    (mid_waddr     ),
    .in_wen      (mid_wen       ),
    .in_wdata    (mid_wdata     ),
    .in_raddr_1  (mid_raddr_1   ),
    .in_ren_1    (mid_ren_1     ),
    .out_rdata_1 (mid_rdata_1   ),
    .in_raddr_2  (mid_raddr_2   ),
    .in_ren_2    (mid_ren_2     ),
    .out_rdata_2 (mid_rdata_2   )
);

// LUI
wire [4:0]  lui_waddr   ;
wire [31:0] lui_wdata   ;
wire        lui_wen     ;
switch_mcu_alu_lui switch_mcu_alu_lui_dut(
    .in_clk          (in_clk        ),
    .in_rst          (in_rst        ),
    .in_cycle_cnt    (in_cycle_cnt  ),
    .in_en           (in_lui        ),
    .in_imm_type_u   (in_imm_type_u ),
    .in_rd           (in_rd         ),
    .out_waddr       (lui_waddr     ),
    .out_wen         (lui_wen       ),
    .out_wdata       (lui_wdata     )
);

// AUIPC
wire [4:0]  auipc_waddr   ;
wire [31:0] auipc_wdata   ;
wire        auipc_wen     ;
switch_mcu_alu_auipc switch_mcu_alu_auipc_dut(
    .in_clk          (in_clk        ),
    .in_rst          (in_rst        ),
    .in_cycle_cnt    (in_cycle_cnt  ),
    .in_pc_reg       (in_pc_reg     ),
    .in_en           (in_auipc      ),
    .in_imm_type_u   (in_imm_type_u ),
    .in_rd           (in_rd         ),
    .out_waddr       (auipc_waddr   ),
    .out_wen         (auipc_wen     ),
    .out_wdata       (auipc_wdata   )
);

// Enable arbiter
assign mid_wen      =   lui_wen | auipc_wen;
// Write data arbiter
assign mid_wdata    =   lui_wen      ?   lui_wdata     :
                        auipc_wen    ?   auipc_wdata   :
                        0;
// Write address arbiter
assign mid_waddr    =   lui_wen      ?   lui_waddr     :
                        auipc_wen    ?   auipc_waddr   :
                        0;

endmodule