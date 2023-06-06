module switch_mcu_core_top(
  in_clk          ,
  in_rst          ,

  in_init_done    ,

  in_hready       ,
  in_hresp        ,
  in_hrdata       ,
  out_haddr       ,
  out_hwrite      ,
  out_hsize       ,
  out_hport       ,
  out_hburst      ,
  out_htrans      ,
  out_hmastlock   ,
);
// Global signals
input  wire in_clk                   ;
input  wire in_rst                   ;
// IFU AHB Bus signals
input  wire          in_init_done    ;
input  wire          in_hready       ;
input  wire          in_hresp        ;
output wire [31:0]   in_hrdata       ;
output wire [31:0]   out_haddr       ;
output wire          out_hwrite      ;
output wire [3:0]    out_hsize       ;
output wire [3:0]    out_hport       ;
output wire [2:0]    out_hburst      ;
output wire [1:0]    out_htrans      ;
output wire          out_hmastlock   ;
// Decoeder signals
wire          mid_lui         ;
wire          mid_auipc       ;
wire          mid_jal         ;
wire          mid_jalr        ;
wire          mid_beq         ;
wire          mid_bne         ;
wire          mid_blt         ;
wire          mid_bge         ;
wire          mid_bltu        ;
wire          mid_bgeu        ;
wire          mid_lb          ;
wire          mid_lh          ;
wire          mid_lw          ;
wire          mid_lbu         ;
wire          mid_lhu         ;
wire          mid_sb          ;
wire          mid_sh          ;
wire          mid_sw          ;
wire          mid_addi        ;
wire          mid_slti        ;
wire          mid_sltiu       ;
wire          mid_xori        ;
wire          mid_ori         ;
wire          mid_andi        ;
wire          mid_slli        ;
wire          mid_srli        ;
wire          mid_srai        ;
wire          mid_add         ;
wire          mid_sub         ;
wire          mid_sll         ;
wire          mid_slt         ;
wire          mid_sltu        ;
wire          mid_xor         ;
wire          mid_srl         ;
wire          mid_sra         ;
wire          mid_or          ;
wire          mid_and         ;
wire          mid_fence       ;
wire          mid_fence_i     ;
wire          mid_ecall       ;
wire          mid_ebreak      ;
wire          mid_csrrw       ;
wire          mid_csrrs       ;
wire          mid_csrrc       ;
wire          mid_csrrwi      ;
wire          mid_csrrsi      ;
wire          mid_csrrci      ;
wire          mid_type_u_en   ;
wire          mid_type_i_en   ;
wire          mid_type_r_en   ;
wire          mid_type_j_en   ;
wire [4:0]    mid_rs2         ;
wire [4:0]    mid_rs1         ;
wire [4:0]    mid_rd          ;
wire [11:0]   mid_imm_type_i  ;
wire [11:0]   mid_imm_type_s  ;
wire [11:0]   mid_imm_type_b  ;
wire [19:0]   mid_imm_type_u  ;
wire [19:0]   mid_imm_type_j  ;
wire          mid_stall       ;
// Core cycle counter signals
wire [31:0]   mid_inst        ;
wire [3:0]    mid_cycle_cnt   ;
wire          mid_pc_override ;
// PC reg signals
wire [31:0]   mid_pc_write    ;
wire [31:0]   mid_pc_reg      ;

switch_mcu_ifu switch_mcu_ifu_dut (
.in_clk         (in_clk         ),
.in_rst         (in_rst         ),
.in_init_done   (in_init_done   ),
.in_hready      (in_hready      ),
.in_hresp       (in_hresp       ),
.in_hrdata      (in_hrdata      ),
.out_haddr      (out_haddr      ),
.out_hwrite     (out_hwrite     ),
.out_hsize      (out_hsize      ),
.out_hburst     (out_hburst     ),
.out_hport      (out_hport      ),
.out_htrans     (out_htrans     ),
.out_hmastlock  (out_hmastlock  ),
.out_inst       (mid_inst       ),
.out_cycle_cnt  (mid_cycle_cnt  ),
.out_pc_reg     (mid_pc_reg     ),
.in_pc_override (mid_pc_override),
.in_pc_write    (mid_pc_write   )
);

switch_mcu_decoder switch_mcu_decoder_dut (
.in_clk         (in_clk         ),
.in_rst         (in_rst         ),
.in_cycle_cnt   (mid_cycle_cnt  ),
.in_inst        (mid_inst       ),
.out_lui        (mid_lui        ),
.out_auipc      (mid_auipc      ),
.out_jal        (mid_jal        ),
.out_jalr       (mid_jalr       ),
.out_beq        (mid_beq        ),
.out_bne        (mid_bne        ),
.out_blt        (mid_blt        ),
.out_bge        (mid_bge        ),
.out_bltu       (mid_bltu       ),
.out_bgeu       (mid_bgeu       ),
.out_lb         (mid_lb         ),
.out_lh         (mid_lh         ),
.out_lw         (mid_lw         ),
.out_lbu        (mid_lbu        ),
.out_lhu        (mid_lhu        ),
.out_sb         (mid_sb         ),
.out_sh         (mid_sh         ),
.out_sw         (mid_sw         ),
.out_addi       (mid_addi       ),
.out_slti       (mid_slti       ),
.out_sltiu      (mid_sltiu      ),
.out_xori       (mid_xori       ),
.out_ori        (mid_ori        ),
.out_andi       (mid_andi       ),
.out_slli       (mid_slli       ),
.out_srli       (mid_srli       ),
.out_srai       (mid_srai       ),
.out_add        (mid_add        ),
.out_sub        (mid_sub        ),
.out_sll        (mid_sll        ),
.out_slt        (mid_slt        ),
.out_sltu       (mid_sltu       ),
.out_xor        (mid_xor        ),
.out_srl        (mid_srl        ),
.out_sra        (mid_sra        ),
.out_or         (mid_or         ),
.out_and        (mid_and        ),
.out_fence      (mid_fence      ),
.out_fence_i    (mid_fence_i    ),
.out_ecall      (mid_ecall      ),
.out_ebreak     (mid_ebreak     ),
.out_csrrw      (mid_csrrw      ),      
.out_csrrs      (mid_csrrs      ),
.out_csrrc      (mid_csrrc      ),
.out_csrrwi     (mid_csrrwi     ),
.out_csrrsi     (mid_csrrsi     ),
.out_csrrci     (mid_csrrci     ),
.out_type_u_en  (mid_type_u_en  ),
.out_type_i_en  (mid_type_i_en  ),
.out_type_r_en  (mid_type_r_en  ),
.out_type_j_en  (mid_type_j_en  ),
.out_rs2        (mid_rs2        ),
.out_rs1        (mid_rs1        ),
.out_rd         (mid_rd         ),
.out_imm_type_i (mid_imm_type_i ),
.out_imm_type_s (mid_imm_type_s ),
.out_imm_type_b (mid_imm_type_b ),
.out_imm_type_u (mid_imm_type_u ),
.out_imm_type_j (mid_imm_type_j ),
.in_stall       (mid_stall      )
);

switch_mcu_alu_top switch_mcu_alu_top_dut (
.in_clk         (in_clk         ),
.in_rst         (in_rst         ),
.in_cycle_cnt   (mid_cycle_cnt  ),
.in_lui         (mid_lui        ),
.in_auipc       (mid_auipc      ),
.in_jal         (mid_jal        ),
.in_jalr        (mid_jalr       ),
.in_beq         (mid_beq        ),
.in_bne         (mid_bne        ),
.in_blt         (mid_blt        ),
.in_bge         (mid_bge        ),
.in_bltu        (mid_bltu       ),
.in_bgeu        (mid_bgeu       ),
.in_lb          (mid_lb         ),
.in_lh          (mid_lh         ),
.in_lw          (mid_lw         ),
.in_lbu         (mid_lbu        ),
.in_lhu         (mid_lhu        ),
.in_sb          (mid_sb         ),
.in_sh          (mid_sh         ),
.in_sw          (mid_sw         ),
.in_addi        (mid_addi       ),
.in_slti        (mid_slti       ),
.in_sltiu       (mid_sltiu      ),
.in_xori        (mid_xori       ),
.in_ori         (mid_ori        ),
.in_andi        (mid_andi       ),
.in_slli        (mid_slli       ),
.in_srli        (mid_srli       ),
.in_srai        (mid_srai       ),
.in_add         (mid_add        ),
.in_sub         (mid_sub        ),
.in_sll         (mid_sll        ),
.in_slt         (mid_slt        ),
.in_sltu        (mid_sltu       ),
.in_xor         (mid_xor        ),
.in_srl         (mid_srl        ),
.in_sra         (mid_sra        ),
.in_or          (mid_or         ),
.in_and         (mid_and        ),
.in_fence       (mid_fence      ),
.in_fence_i     (mid_fence_i    ),
.in_ecall       (mid_ecall      ),
.in_ebreak      (mid_ebreak     ),
.in_csrrw       (mid_csrrw      ),      
.in_csrrs       (mid_csrrs      ),
.in_csrrc       (mid_csrrc      ),
.in_csrrwi      (mid_csrrwi     ),
.in_csrrsi      (mid_csrrsi     ),
.in_csrrci      (mid_csrrci     ),
.in_rs2         (mid_rs2        ),
.in_rs1         (mid_rs1        ),
.in_rd          (mid_rd         ),
.in_type_u_en   (mid_type_u_en  ),
.in_type_i_en   (mid_type_i_en  ),
.in_type_r_en   (mid_type_r_en  ),
.in_type_j_en   (mid_type_j_en  ),
.in_imm_type_i  (mid_imm_type_i ),
.in_imm_type_s  (mid_imm_type_s ),
.in_imm_type_b  (mid_imm_type_b ),
.in_imm_type_u  (mid_imm_type_u ),
.in_imm_type_j  (mid_imm_type_j ),
.in_pc_reg      (mid_pc_reg     ),
.out_pc_override(mid_pc_override),
.out_pc_write   (mid_pc_write   ),
.out_stall      (mid_stall      )
);

// initial begin
//   begin
//     in_rst = 1'b0;
//     mid_inst = 32'b0;
//     #10;
//     in_rst = 1'b1;
//     #10;
//     mid_inst = 32'b10101010101010101010_00001_0110111;
//     #30;
//     mid_inst = 32'b10101010101010101010_00010_0010111;
//     #30;
//     mid_inst = 32'b0;
//     #50;
//     $stop;
//   end
// end

// always
//   #5  in_clk = ! in_clk ;

// initial
// begin            
//     $dumpfile("wave.vcd");        //生成的vcd文件名称
//     $dumpvars(0, switch_mcu_exe_top);    //tb模块名称
// end

endmodule