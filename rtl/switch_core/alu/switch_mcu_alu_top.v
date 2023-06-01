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

// Type U Ex-unit regfile operation signals
wire [4:0]  mid_type_u_waddr   ;
wire [31:0] mid_type_u_wdata   ;
wire        mid_type_u_wen     ;
// Type I Ex-unit enable signal
wire        mid_type_u_en      ;

// Type I Ex-unit regfile operation signals
wire [4:0]  mid_type_i_raddr_1 ;
wire        mid_type_i_ren_1   ;
wire [4:0]  mid_type_i_waddr   ;
wire [31:0] mid_type_i_wdata   ;
wire        mid_type_i_wen     ;
// Type I Ex-unit enable signal
wire        mid_type_i_en      ;

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
assign mid_type_u_en =  in_lui | in_auipc ;

// Ex-unit enable signals
assign mid_type_i_en =  in_addi | in_slti | in_sltiu | in_xori |
                        in_ori  | in_andi | in_slli  | in_srli |
                        in_srai ;
// Ex-unit enable signals
assign mid_type_r_en =  in_add  | in_sub | in_sll | in_slt | 
                        in_sltu | in_xor | in_srl | in_sra |
                        in_or   | in_and ;

switch_mcu_ex_type_u switch_mcu_ex_type_u_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_pc_reg         (in_pc_reg         ),
  .in_lui            (in_lui            ),
  .in_auipc          (in_auipc          ),
  .in_en             (mid_type_u_en     ),
  .in_imm_type_u     (in_imm_type_u     ),
  .in_rd             (in_rd             ),
  .out_waddr         (mid_type_u_waddr  ),
  .out_wen           (mid_type_u_wen    ),
  .out_wdata         (mid_type_u_wdata  )
);
                      
switch_mcu_ex_type_i switch_mcu_ex_type_i_dut (
  .in_clk            (in_clk            ),
  .in_rst            (in_rst            ),
  .in_cycle_cnt      (in_cycle_cnt      ),
  .in_en             (mid_type_i_en     ),   
  .in_addi           (in_addi           ),
  .in_slti           (in_slti           ),
  .in_sltiu          (in_sltiu          ),
  .in_xori           (in_xori           ),
  .in_ori            (in_ori            ),
  .in_andi           (in_andi           ),
  .in_slli           (in_slli           ),
  .in_srli           (in_srli           ),
  .in_srai           (in_srai           ),
  .in_imm_type_i     (in_imm_type_i     ),
  .in_rs1            (in_rs1            ),
  .in_rd             (in_rd             ),
  .in_rdata_1        (mid_rdata_1       ),
  .out_raddr_1       (mid_type_i_raddr_1),
  .out_ren_1         (mid_type_i_ren_1  ),
  .out_waddr         (mid_type_i_waddr  ),
  .out_wen           (mid_type_i_wen    ),
  .out_wdata         (mid_type_i_wdata  )
);

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
    end else if(mid_type_u_en)begin
        mid_wen     <= mid_type_u_wen;
        mid_wdata   <= mid_type_u_wdata;
        mid_waddr   <= mid_type_u_waddr;
        mid_ren_1   <= 0;
        mid_raddr_1 <= 0;
        mid_ren_2   <= 0;
        mid_raddr_2 <= 0;
    end else if(mid_type_i_en)begin
        mid_wen     <= mid_type_i_wen;
        mid_wdata   <= mid_type_i_wdata;
        mid_waddr   <= mid_type_i_waddr;
        mid_ren_1   <= mid_type_i_ren_1;
        mid_raddr_1 <= mid_type_i_raddr_1;
        mid_ren_2   <= 0;
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