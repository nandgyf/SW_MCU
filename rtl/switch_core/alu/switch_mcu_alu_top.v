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
reg   [4:0]        mid_waddr       ;
reg                mid_wen         ;
reg   [31:0]       mid_wdata       ;
// Read 1
reg   [4:0]        mid_raddr_1     ;
reg                mid_ren_1       ;
wire  [31:0]       mid_rdata_1     ;
// Read 2
reg   [4:0]        mid_raddr_2     ;
reg                mid_ren_2       ;
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
wire [4:0]  mid_lui_waddr   ;
wire [31:0] mid_lui_wdata   ;
wire        mid_lui_wen     ;
switch_mcu_alu_lui switch_mcu_alu_lui_dut(
    .in_clk          (in_clk        ),
    .in_rst          (in_rst        ),
    .in_cycle_cnt    (in_cycle_cnt  ),
    .in_en           (in_lui        ),
    .in_imm_type_u   (in_imm_type_u ),
    .in_rd           (in_rd         ),
    .out_waddr       (mid_lui_waddr ),
    .out_wen         (mid_lui_wen   ),
    .out_wdata       (mid_lui_wdata )
);

// AUIPC
wire [4:0]  mid_auipc_waddr   ;
wire [31:0] mid_auipc_wdata   ;
wire        mid_auipc_wen     ;
switch_mcu_alu_auipc switch_mcu_alu_auipc_dut(
    .in_clk          (in_clk            ),
    .in_rst          (in_rst            ),
    .in_cycle_cnt    (in_cycle_cnt      ),
    .in_pc_reg       (in_pc_reg         ),
    .in_en           (in_auipc          ),
    .in_imm_type_u   (in_imm_type_u     ),
    .in_rd           (in_rd             ),
    .out_waddr       (mid_auipc_waddr   ),
    .out_wen         (mid_auipc_wen     ),
    .out_wdata       (mid_auipc_wdata   )
);

// ADDI
wire [4:0]  mid_addi_raddr_1 ;
wire        mid_addi_ren_1   ;
wire [4:0]  mid_addi_waddr   ;
wire [31:0] mid_addi_wdata   ;
wire        mid_addi_wen     ;
switch_mcu_alu_addi switch_mcu_alu_addi_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (in_addi           ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_addi_raddr_1  ),
  .out_ren_1         (mid_addi_ren_1    ),
  .out_waddr         (mid_addi_waddr    ),
  .out_wen           (mid_addi_wen      ),
  .out_wdata         (mid_addi_wdata    )
);

// SLTI
wire [4:0]  mid_slti_raddr_1 ;
wire        mid_slti_ren_1   ;
wire [4:0]  mid_slti_waddr   ;
wire [31:0] mid_slti_wdata   ;
wire        mid_slti_wen     ;
switch_mcu_alu_slti switch_mcu_alu_slti_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (in_slti           ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_slti_raddr_1  ),
  .out_ren_1         (mid_slti_ren_1    ),
  .out_waddr         (mid_slti_waddr    ),
  .out_wen           (mid_slti_wen      ),
  .out_wdata         (mid_slti_wdata    )
);

// SLTIU
wire [4:0]  mid_sltiu_raddr_1 ;
wire        mid_sltiu_ren_1   ;
wire [4:0]  mid_sltiu_waddr   ;
wire [31:0] mid_sltiu_wdata   ;
wire        mid_sltiu_wen     ;
switch_mcu_alu_sltiu switch_mcu_alu_sltiu_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (in_sltiu          ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_sltiu_raddr_1 ),
  .out_ren_1         (mid_sltiu_ren_1   ),
  .out_waddr         (mid_sltiu_waddr   ),
  .out_wen           (mid_sltiu_wen     ),
  .out_wdata         (mid_sltiu_wdata   )
);

// XORI
wire [4:0]  mid_xori_raddr_1 ;
wire        mid_xori_ren_1   ;
wire [4:0]  mid_xori_waddr   ;
wire [31:0] mid_xori_wdata   ;
wire        mid_xori_wen     ;
switch_mcu_alu_xori switch_mcu_alu_xori_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (in_xori           ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_xori_raddr_1  ),
  .out_ren_1         (mid_xori_ren_1    ),
  .out_waddr         (mid_xori_waddr    ),
  .out_wen           (mid_xori_wen      ),
  .out_wdata         (mid_xori_wdata    )
);

// ORI
wire [4:0]  mid_ori_raddr_1 ;
wire        mid_ori_ren_1   ;
wire [4:0]  mid_ori_waddr   ;
wire [31:0] mid_ori_wdata   ;
wire        mid_ori_wen     ;
switch_mcu_alu_ori switch_mcu_alu_ori_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (in_ori            ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_ori_raddr_1   ),
  .out_ren_1         (mid_ori_ren_1     ),
  .out_waddr         (mid_ori_waddr     ),
  .out_wen           (mid_ori_wen       ),
  .out_wdata         (mid_ori_wdata     )
);

// ANDI
wire [4:0]  mid_andi_raddr_1 ;
wire        mid_andi_ren_1   ;
wire [4:0]  mid_andi_waddr   ;
wire [31:0] mid_andi_wdata   ;
wire        mid_andi_wen     ;
switch_mcu_alu_andi switch_mcu_alu_andi_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (in_andi           ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_andi_raddr_1  ),
  .out_ren_1         (mid_andi_ren_1    ),
  .out_waddr         (mid_andi_waddr    ),
  .out_wen           (mid_andi_wen      ),
  .out_wdata         (mid_andi_wdata    )
);

// SLLI
wire [4:0]  mid_slli_raddr_1 ;
wire        mid_slli_ren_1   ;
wire [4:0]  mid_slli_waddr   ;
wire [31:0] mid_slli_wdata   ;
wire        mid_slli_wen     ;
switch_mcu_alu_slli switch_mcu_alu_slli_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (in_slli           ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_slli_raddr_1  ),
  .out_ren_1         (mid_slli_ren_1    ),
  .out_waddr         (mid_slli_waddr    ),
  .out_wen           (mid_slli_wen      ),
  .out_wdata         (mid_slli_wdata    )
);

// SRLI
wire [4:0]  mid_srli_raddr_1 ;
wire        mid_srli_ren_1   ;
wire [4:0]  mid_srli_waddr   ;
wire [31:0] mid_srli_wdata   ;
wire        mid_srli_wen     ;
switch_mcu_alu_srli switch_mcu_alu_srli_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (in_srli           ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_srli_raddr_1  ),
  .out_ren_1         (mid_srli_ren_1    ),
  .out_waddr         (mid_srli_waddr    ),
  .out_wen           (mid_srli_wen      ),
  .out_wdata         (mid_srli_wdata    )
);

// SRAI
wire [4:0]  mid_srai_raddr_1 ;
wire        mid_srai_ren_1   ;
wire [4:0]  mid_srai_waddr   ;
wire [31:0] mid_srai_wdata   ;
wire        mid_srai_wen     ;
switch_mcu_alu_srai switch_mcu_alu_srai_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (in_srai           ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_srai_raddr_1  ),
  .out_ren_1         (mid_srai_ren_1    ),
  .out_waddr         (mid_srai_waddr    ),
  .out_wen           (mid_srai_wen      ),
  .out_wdata         (mid_srai_wdata    )
);

// Type R Ex-unit regfile operation signals
wire [4:0]  mid_type_r_raddr_1 ;
wire        mid_type_r_ren_1   ;
wire [4:0]  mid_type_r_raddr_2 ;
wire        mid_type_r_ren_2   ;
wire [4:0]  mid_type_r_waddr   ;
wire [31:0] mid_type_r_wdata   ;
wire        mid_type_r_wen     ;
// Type R Ex-unit enable signal
wire        mid_type_r_en      ;


// Ex-unit enable signals
assign mid_type_r_en =  in_add  | in_sub | in_sll | in_slt | 
                        in_sltu | in_xor | in_srl | in_sra |
                        in_or   | in_and ;

switch_mcu_ex_type_r switch_mcu_ex_type_r_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (mid_type_r_en     ),
  .in_add            (in_add            ),
  .in_sub            (in_sub            ),
  .in_sll            (in_sll            ),
  .in_slt            (in_slt            ),
  .in_sltu           (in_sltu           ),
  .in_xor            (in_xor            ),
  .in_srl            (in_srl            ),
  .in_sra            (in_sra            ),
  .in_or             (in_or             ),
  .in_and            (in_and            ),
  .in_rs1            (in_rs1            ),
  .in_rs2            (in_rs2            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_type_r_raddr_1),
  .out_ren_1         (mid_type_r_ren_1  ),
  .in_rdata_2        (mid_rdata_2       ),
  .out_raddr_2       (mid_type_r_raddr_2),
  .out_ren_2         (mid_type_r_ren_2  ),
  .out_waddr         (mid_type_r_waddr  ),
  .out_wen           (mid_type_r_wen    ),
  .out_wdata         (mid_type_r_wdata  )
);



// Write/Read signals selection
always @(posedge in_clk or negedge in_rst) begin
    if(!in_rst) begin
        mid_wen <= 0;
        mid_wdata <= 0;
        mid_waddr <= 0;
        mid_ren_1 <= 0;
        mid_raddr_1 <= 0;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_lui) begin
        mid_wen <= mid_lui_wen;
        mid_wdata <= mid_lui_wdata;
        mid_waddr <= mid_lui_waddr;
        mid_ren_1 <= 0;
        mid_raddr_1 <= 0;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_auipc) begin
        mid_wen <= mid_auipc_wen;
        mid_wdata <= mid_auipc_wdata;
        mid_waddr <= mid_auipc_waddr;
        mid_ren_1 <= 0;
        mid_raddr_1 <= 0;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_addi) begin
        mid_wen <= mid_addi_wen;
        mid_wdata <= mid_addi_wdata;
        mid_waddr <= mid_addi_waddr;
        mid_ren_1 <= mid_addi_ren_1;
        mid_raddr_1 <= mid_addi_raddr_1;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_slti) begin
        mid_wen <= mid_slti_wen;
        mid_wdata <= mid_slti_wdata;
        mid_waddr <= mid_slti_waddr;
        mid_ren_1 <= mid_slti_ren_1;
        mid_raddr_1 <= mid_slti_raddr_1;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_sltiu) begin
        mid_wen <= mid_sltiu_wen;
        mid_wdata <= mid_sltiu_wdata;
        mid_waddr <= mid_sltiu_waddr;
        mid_ren_1 <= mid_sltiu_ren_1;
        mid_raddr_1 <= mid_sltiu_raddr_1;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_xori) begin
        mid_wen <= mid_xori_wen;
        mid_wdata <= mid_xori_wdata;
        mid_waddr <= mid_xori_waddr;
        mid_ren_1 <= mid_xori_ren_1;
        mid_raddr_1 <= mid_xori_raddr_1;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_ori) begin
        mid_wen <= mid_ori_wen;
        mid_wdata <= mid_ori_wdata;
        mid_waddr <= mid_ori_waddr;
        mid_ren_1 <= mid_ori_ren_1;
        mid_raddr_1 <= mid_ori_raddr_1;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_andi) begin
        mid_wen <= mid_andi_wen;
        mid_wdata <= mid_andi_wdata;
        mid_waddr <= mid_andi_waddr;
        mid_ren_1 <= mid_andi_ren_1;
        mid_raddr_1 <= mid_andi_raddr_1;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_slli) begin
        mid_wen <= mid_slli_wen;
        mid_wdata <= mid_slli_wdata;
        mid_waddr <= mid_slli_waddr;
        mid_ren_1 <= mid_slli_ren_1;
        mid_raddr_1 <= mid_slli_raddr_1;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_srli) begin
        mid_wen <= mid_srli_wen;
        mid_wdata <= mid_srli_wdata;
        mid_waddr <= mid_srli_waddr;
        mid_ren_1 <= mid_srli_ren_1;
        mid_raddr_1 <= mid_srli_raddr_1;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(in_srai) begin
        mid_wen <= mid_srai_wen;
        mid_wdata <= mid_srai_wdata;
        mid_waddr <= mid_srai_waddr;
        mid_ren_1 <= mid_srai_ren_1;
        mid_raddr_1 <= mid_srai_raddr_1;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end else if(mid_type_r_en) begin
        mid_wen     <= mid_type_r_wen;
        mid_wdata   <= mid_type_r_wdata;
        mid_waddr   <= mid_type_r_waddr;
        mid_ren_1   <= mid_type_r_ren_1;
        mid_raddr_1 <= mid_type_r_raddr_1;
        mid_ren_2   <= mid_type_r_ren_2;
        mid_raddr_2 <= mid_type_r_raddr_2;
    end else begin
        mid_wen <= 0;
        mid_wdata <= 0;
        mid_waddr <= 0;
        mid_ren_1 <= 0;
        mid_raddr_1 <= 0;
        mid_ren_2 <= 0;
        mid_raddr_2 <= 0;
    end
end

endmodule