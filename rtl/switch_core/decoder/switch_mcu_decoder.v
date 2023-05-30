module switch_mcu_decoder (
    in_clk,
    in_rst,
    in_inst,
    in_cycle_cnt,

    out_lui,
    out_auipc,
    out_jal,
    out_jalr,
    out_beq,
    out_bne,
    out_blt,
    out_bge,
    out_bltu,
    out_bgeu,
    out_lb,
    out_lh,
    out_lw,
    out_lbu,
    out_lhu,
    out_sb,
    out_sh,
    out_sw,
    out_addi,
    out_slti,
    out_sltiu,
    out_xori,
    out_ori,
    out_andi,
    out_slli,
    out_srli,
    out_srai,
    out_add,
    out_sub,
    out_sll,
    out_slt,
    out_sltu,
    out_xor,
    out_srl,
    out_sra,
    out_or,
    out_and,
    out_fence,
    out_fence_i,
    out_ecall,
    out_ebreak,
    out_csrrw,
    out_csrrs,
    out_csrrc,
    out_csrrwi,
    out_csrrsi,
    out_csrrci,
    out_rs2,
    out_rs1,
    out_rd,
    out_imm_type_i,
    out_imm_type_s,
    out_imm_type_b,
    out_imm_type_u,
    out_imm_type_j
);
// Global singals
input wire in_clk            ;
input wire in_rst            ;
// Cycle counter
input wire [3:0] in_cycle_cnt; 
// Input wires
input wire [31:0] in_inst;
// Output wires
output wire out_lui          ;
output wire out_auipc        ;
output wire out_jal          ;
output wire out_jalr         ;
output wire out_beq          ;
output wire out_bne          ;
output wire out_blt          ;
output wire out_bge          ;
output wire out_bltu         ;
output wire out_bgeu         ;
output wire out_lb           ;
output wire out_lh           ;
output wire out_lw           ;
output wire out_lbu          ;
output wire out_lhu          ;
output wire out_sb           ;
output wire out_sh           ;
output wire out_sw           ;
output wire out_addi         ;
output wire out_slti         ;
output wire out_sltiu        ;
output wire out_xori         ;
output wire out_ori          ;
output wire out_andi         ;
output wire out_slli         ;
output wire out_srli         ;
output wire out_srai         ;
output wire out_add          ;
output wire out_sub          ;
output wire out_sll          ;
output wire out_slt          ;
output wire out_sltu         ;
output wire out_xor          ;
output wire out_srl          ;
output wire out_sra          ;
output wire out_or           ;
output wire out_and          ;
output wire out_fence        ;
output wire out_fence_i      ;
output wire out_ecall        ;
output wire out_ebreak       ;
output wire out_csrrw        ;       
output wire out_csrrs        ;
output wire out_csrrc        ;
output wire out_csrrwi       ;
output wire out_csrrsi       ;
output wire out_csrrci       ;
output wire [4:0]   out_rs2         ;
output wire [4:0]   out_rs1         ;
output wire [4:0]   out_rd          ;
output wire [11:0]  out_imm_type_i  ;
output wire [11:0]  out_imm_type_s  ;
output wire [11:0]  out_imm_type_b  ;
output wire [19:0]  out_imm_type_u  ;
output wire [18:0]  out_imm_type_j  ;

// Regsiter to buffer instructions
reg [31:0] inst;

// Signals used for decoding
wire [3:0] inst_31_16 = inst[31:16];
wire [3:0] inst_31_28 = inst[31:28];
wire [3:0] inst_19_15 = inst[19:15];
wire [3:0] inst_11_7  = inst[11:7];
wire [6:0] inst_31_25 = inst[31:25];
wire [2:0] inst_14_12 = inst[14:12];
wire [6:0] inst_6_0   = inst[6:0];

// Intermediate decoder
// 31:16 bits decoder
wire inst_31_16_equal_000000000000 = (inst_31_16 == 'b000000000000);
wire inst_31_16_equal_000000000001 = (inst_31_16 == 'b000000000001);

// 31:28 bits decoder
wire inst_31_28_equal_0000 = (inst_31_28 == 'b0000);

// 19:15 bits decoder
wire inst_19_15_equal_00000 = (inst_19_15 == 'b00000);

// 11:7 bits decoder
wire inst_11_7_equal_00000 = (inst_11_7 == 'b00000);

// 31:25 bits decoder
wire inst_31_25_equal_0000000   = (inst_31_25 == 'b0000000);
wire inst_31_25_equal_0100000   = (inst_31_25 == 'b0100000);

// 14:12 bits decoder
wire inst_14_12_equal_000   = (inst_14_12 == 'b000);
wire inst_14_12_equal_001   = (inst_14_12 == 'b001);
wire inst_14_12_equal_010   = (inst_14_12 == 'b010);
wire inst_14_12_equal_011   = (inst_14_12 == 'b011);
wire inst_14_12_equal_100   = (inst_14_12 == 'b100);
wire inst_14_12_equal_101   = (inst_14_12 == 'b101);
wire inst_14_12_equal_110   = (inst_14_12 == 'b110);
wire inst_14_12_equal_111   = (inst_14_12 == 'b111);

// 6:0 bits decoder
wire inst_6_0_equal_1100111 = (inst_6_0 == 'b1100111);
wire inst_6_0_equal_0000011 = (inst_6_0 == 'b0000011);
wire inst_6_0_equal_0100011 = (inst_6_0 == 'b0100011);
wire inst_6_0_equal_0010011 = (inst_6_0 == 'b0010011);
wire inst_6_0_equal_0110111 = (inst_6_0 == 'b0110111);
wire inst_6_0_equal_0010111 = (inst_6_0 == 'b0010111);
wire inst_6_0_equal_1101111 = (inst_6_0 == 'b1101111);
wire inst_6_0_equal_0110011 = (inst_6_0 == 'b0110011);
wire inst_6_0_equal_0001111 = (inst_6_0 == 'b0001111);
wire inst_6_0_equal_1110011 = (inst_6_0 == 'b1110011);

// Refresh instruction every cycle
always@(posedge in_clk or negedge in_rst) begin
    if(!in_rst)
        inst <= 0;
    else if(in_cycle_cnt == 0)
        inst <= in_inst;
    else
        inst <= inst;
end

// Decode with 6:0 bits
assign out_lui      = (inst_6_0_equal_0110111);
assign out_auipc    = (inst_6_0_equal_0010111);
assign out_jal      = (inst_6_0_equal_1101111);

// Decode with 14:12 and 6:0 bits
assign out_jalr     = (inst_14_12_equal_000 & inst_6_0_equal_1100111);
assign out_beq      = (inst_14_12_equal_000 & inst_6_0_equal_1100111);
assign out_bne      = (inst_14_12_equal_001 & inst_6_0_equal_1100111);
assign out_blt      = (inst_14_12_equal_010 & inst_6_0_equal_1100111);
assign out_bge      = (inst_14_12_equal_011 & inst_6_0_equal_1100111);
assign out_bltu     = (inst_14_12_equal_100 & inst_6_0_equal_1100111);
assign out_bgeu     = (inst_14_12_equal_111 & inst_6_0_equal_1100111);

assign out_lb       = (inst_14_12_equal_000 & inst_6_0_equal_0000011);
assign out_lh       = (inst_14_12_equal_001 & inst_6_0_equal_0000011);
assign out_lw       = (inst_14_12_equal_010 & inst_6_0_equal_0000011);
assign out_lbu      = (inst_14_12_equal_100 & inst_6_0_equal_0000011);
assign out_lhu      = (inst_14_12_equal_101 & inst_6_0_equal_0000011);

assign out_sb       = (inst_14_12_equal_000 & inst_6_0_equal_0100011);
assign out_sh       = (inst_14_12_equal_001 & inst_6_0_equal_0100011);
assign out_sw       = (inst_14_12_equal_010 & inst_6_0_equal_0100011);

assign out_addi     = (inst_14_12_equal_000 & inst_6_0_equal_0010011);
assign out_slti     = (inst_14_12_equal_010 & inst_6_0_equal_0010011);
assign out_sltiu    = (inst_14_12_equal_011 & inst_6_0_equal_0010011);
assign out_xori     = (inst_14_12_equal_100 & inst_6_0_equal_0010011);
assign out_ori      = (inst_14_12_equal_110 & inst_6_0_equal_0010011);
assign out_andi     = (inst_14_12_equal_111 & inst_6_0_equal_0010011);

assign out_csrrw    = (inst_14_12_equal_001 & inst_6_0_equal_1110011);
assign out_csrrs    = (inst_14_12_equal_010 & inst_6_0_equal_1110011);
assign out_csrrc    = (inst_14_12_equal_011 & inst_6_0_equal_1110011);
assign out_csrrwi   = (inst_14_12_equal_101 & inst_6_0_equal_1110011);
assign out_csrrsi   = (inst_14_12_equal_110 & inst_6_0_equal_1110011);
assign out_csrrci   = (inst_14_12_equal_111 & inst_6_0_equal_1110011);

// Decode with 31:25 , 14:12 and 6:0 bits
assign out_slli     = (inst_31_25_equal_0000000 & inst_14_12_equal_001 & inst_6_0_equal_0010011);
assign out_srli     = (inst_31_25_equal_0000000 & inst_14_12_equal_101 & inst_6_0_equal_0010011);
assign out_srai     = (inst_31_25_equal_0100000 & inst_14_12_equal_101 & inst_6_0_equal_0010011);
assign out_add      = (inst_31_25_equal_0000000 & inst_14_12_equal_000 & inst_6_0_equal_0110011);
assign out_sub      = (inst_31_25_equal_0100000 & inst_14_12_equal_000 & inst_6_0_equal_0110011);
assign out_sll      = (inst_31_25_equal_0000000 & inst_14_12_equal_001 & inst_6_0_equal_0110011);
assign out_slt      = (inst_31_25_equal_0000000 & inst_14_12_equal_010 & inst_6_0_equal_0110011);
assign out_sltu     = (inst_31_25_equal_0000000 & inst_14_12_equal_011 & inst_6_0_equal_0110011);
assign out_xor      = (inst_31_25_equal_0000000 & inst_14_12_equal_100 & inst_6_0_equal_0110011);
assign out_srl      = (inst_31_25_equal_0000000 & inst_14_12_equal_101 & inst_6_0_equal_0110011);
assign out_sra      = (inst_31_25_equal_0100000 & inst_14_12_equal_101 & inst_6_0_equal_0110011);
assign out_or       = (inst_31_25_equal_0000000 & inst_14_12_equal_110 & inst_6_0_equal_0110011);
assign out_and      = (inst_31_25_equal_0000000 & inst_14_12_equal_111 & inst_6_0_equal_0110011);

// Decode with 31:25 , 19:15 , 14:12 , 11:7 and 6:0
assign out_fence    = (inst_31_28_equal_0000 & inst_19_15_equal_00000 & inst_14_12_equal_000 & inst_11_7_equal_00000 & inst_6_0_equal_0001111);

// Decode with ALL bits
assign out_fence_i  = (inst_31_16_equal_000000000000 & inst_19_15_equal_00000 & inst_14_12_equal_001 & inst_11_7_equal_00000 & inst_6_0_equal_0001111);
assign out_ecall    = (inst_31_16_equal_000000000000 & inst_19_15_equal_00000 & inst_14_12_equal_000 & inst_11_7_equal_00000 & inst_6_0_equal_1110011);
assign out_ebreak   = (inst_31_16_equal_000000000001 & inst_19_15_equal_00000 & inst_14_12_equal_000 & inst_11_7_equal_00000 & inst_6_0_equal_1110011);

// Generate data for ALUs
assign out_rs2        = inst [24:20]  ;
assign out_rs1        = inst [19:15]  ;
assign out_rd         = inst [11:7]   ;
assign out_imm_type_i = inst [31:20]  ;
assign out_imm_type_s = {inst[31:25], inst[11:7]};
assign out_imm_type_b = {inst[31], inst[7], inst[30:25], inst[11:8]};
assign out_imm_type_u = inst [31:12]  ;
assign out_imm_type_j = {inst[31], inst[19:12], inst[20], inst[30:20]};

endmodule