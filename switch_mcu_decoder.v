`timescale 1ps/1ps

module switch_mcu_decoder (
    input_inst,

    output_lui,
    output_auipc,
    output_jal,
    output_jalr,
    output_beq,
    output_bne,
    output_blt,
    output_bge,
    output_bltu,
    output_bgeu,
    output_lb,
    output_lh,
    output_lw,
    output_lbu,
    output_lhu,
    output_sb,
    output_sh,
    output_sw,
    output_addi,
    output_slti,
    output_sltiu,
    output_xori,
    output_ori,
    output_andi,
    output_slli,
    output_srli,
    output_srai,
    output_add,
    output_sub,
    output_sll,
    output_slt,
    output_sltu,
    output_xor,
    output_srl,
    output_sra,
    output_or,
    output_and,
    output_fence,
    output_fence_i,
    output_ecall,
    output_ebreak,
    output_csrrw,
    output_csrrs,
    output_csrrc,
    output_csrrwi,
    output_csrrsi,
    output_csrrci
);
// Input wires
input wire [31:0] input_inst;
// Output wires
output wire output_lui          ;
output wire output_auipc        ;
output wire output_jal          ;
output wire output_jalr         ;
output wire output_beq          ;
output wire output_bne          ;
output wire output_blt          ;
output wire output_bge          ;
output wire output_bltu         ;
output wire output_bgeu         ;
output wire output_lb           ;
output wire output_lh           ;
output wire output_lw           ;
output wire output_lbu          ;
output wire output_lhu          ;
output wire output_sb           ;
output wire output_sh           ;
output wire output_sw           ;
output wire output_addi         ;
output wire output_slti         ;
output wire output_sltiu        ;
output wire output_xori         ;
output wire output_ori          ;
output wire output_andi         ;
output wire output_slli         ;
output wire output_srli         ;
output wire output_srai         ;
output wire output_add          ;
output wire output_sub          ;
output wire output_sll          ;
output wire output_slt          ;
output wire output_sltu         ;
output wire output_xor          ;
output wire output_srl          ;
output wire output_sra          ;
output wire output_or           ;
output wire output_and          ;
output wire output_fence        ;
output wire output_fence_i      ;
output wire output_ecall        ;
output wire output_ebreak       ;
output wire output_csrrw        ;       
output wire output_csrrs        ;
output wire output_csrrc        ;
output wire output_csrrwi       ;
output wire output_csrrsi       ;
output wire output_csrrci       ;

// Signals used for decoding
wire [3:0] inst_31_16 = input_inst[31:16];
wire [3:0] inst_31_28 = input_inst[31:28];
wire [3:0] inst_19_15 = input_inst[19:15];
wire [3:0] inst_11_7  = input_inst[11:7];
wire [2:0] inst_31_25 = input_inst[31:25];
wire [2:0] inst_14_12 = input_inst[14:12];
wire [6:0] inst_6_0   = input_inst[6:0];

// Intermediate decoder
// 31:16 bits decoder
wire inst_31_16_equal_000000000000 = (inst_31_16 == 000000000000);
wire inst_31_16_equal_000000000001 = (inst_31_16 == 000000000001);

// 31:28 bits decoder
wire inst_31_28_equal_0000 = (inst_31_28 == 0000);

// 19:15 bits decoder
wire inst_19_15_equal_00000 = (inst_19_15 == 00000);

// 11:7 bits decoder
wire inst_11_7_equal_00000 = (inst_11_7 == 00000);

// 31:25 bits decoder
wire inst_31_25_equal_0000000   = (inst_14_12 == 0000000);
wire inst_31_25_equal_0100000   = (inst_14_12 == 0100000);

// 14:12 bits decoder
wire inst_14_12_equal_000   = (inst_14_12 == 000);
wire inst_14_12_equal_001   = (inst_14_12 == 001);
wire inst_14_12_equal_010   = (inst_14_12 == 010);
wire inst_14_12_equal_011   = (inst_14_12 == 011);
wire inst_14_12_equal_100   = (inst_14_12 == 100);
wire inst_14_12_equal_101   = (inst_14_12 == 101);
wire inst_14_12_equal_110   = (inst_14_12 == 110);
wire inst_14_12_equal_111   = (inst_14_12 == 111);

// 6:0 bits decoder
wire inst_6_0_equal_1100111 = (inst_6_0 == 1100111);
wire inst_6_0_equal_0000011 = (inst_6_0 == 0000011);
wire inst_6_0_equal_0100011 = (inst_6_0 == 0100011);
wire inst_6_0_equal_0010011 = (inst_6_0 == 0010011);
wire inst_6_0_equal_0110111 = (inst_6_0 == 0110111);
wire inst_6_0_equal_0010111 = (inst_6_0 == 0010111);
wire inst_6_0_equal_1101111 = (inst_6_0 == 1101111);
wire inst_6_0_equal_0110011 = (inst_6_0 == 0110011);
wire inst_6_0_equal_0001111 = (inst_6_0 == 0001111);
wire inst_6_0_equal_1110011 = (inst_6_0 == 1110011);

// Decode with 6:0 bits
assign output_lui      = (inst_6_0_equal_0110111);
assign output_auipc    = (inst_6_0_equal_0010111);
assign output_jal      = (inst_6_0_equal_1101111);

// Decode with 14:12 and 6:0 bits
assign output_jalr     = (inst_14_12_equal_000 & inst_6_0_equal_1100111);
assign output_beq      = (inst_14_12_equal_000 & inst_6_0_equal_1100111);
assign output_bne      = (inst_14_12_equal_001 & inst_6_0_equal_1100111);
assign output_blt      = (inst_14_12_equal_010 & inst_6_0_equal_1100111);
assign output_bge      = (inst_14_12_equal_011 & inst_6_0_equal_1100111);
assign output_bltu     = (inst_14_12_equal_100 & inst_6_0_equal_1100111);
assign output_bgeu     = (inst_14_12_equal_111 & inst_6_0_equal_1100111);

assign output_lb       = (inst_14_12_equal_000 & inst_6_0_equal_0000011);
assign output_lh       = (inst_14_12_equal_001 & inst_6_0_equal_0000011);
assign output_lw       = (inst_14_12_equal_010 & inst_6_0_equal_0000011);
assign output_lbu      = (inst_14_12_equal_100 & inst_6_0_equal_0000011);
assign output_lhu      = (inst_14_12_equal_101 & inst_6_0_equal_0000011);

assign output_sb       = (inst_14_12_equal_000 & inst_6_0_equal_0100011);
assign output_sh       = (inst_14_12_equal_001 & inst_6_0_equal_0100011);
assign output_sw       = (inst_14_12_equal_010 & inst_6_0_equal_0100011);

assign output_addi     = (inst_14_12_equal_000 & inst_6_0_equal_0010011);
assign output_slti     = (inst_14_12_equal_010 & inst_6_0_equal_0010011);
assign output_sltiu    = (inst_14_12_equal_011 & inst_6_0_equal_0010011);
assign output_xori     = (inst_14_12_equal_100 & inst_6_0_equal_0010011);
assign output_ori      = (inst_14_12_equal_110 & inst_6_0_equal_0010011);
assign output_andi     = (inst_14_12_equal_111 & inst_6_0_equal_0010011);

assign output_csrrw    = (inst_14_12_equal_001 & inst_6_0_equal_1110011);
assign output_csrrs    = (inst_14_12_equal_010 & inst_6_0_equal_1110011);
assign output_csrrc    = (inst_14_12_equal_011 & inst_6_0_equal_1110011);
assign output_csrrwi   = (inst_14_12_equal_101 & inst_6_0_equal_1110011);
assign output_csrrsi   = (inst_14_12_equal_110 & inst_6_0_equal_1110011);
assign output_csrrci   = (inst_14_12_equal_111 & inst_6_0_equal_1110011);

// Decode with 31:25 , 14:12 and 6:0 bits
assign output_slli     = (inst_31_25_equal_0000000 & inst_14_12_equal_001 & inst_6_0_equal_0010011);
assign output_srli     = (inst_31_25_equal_0000000 & inst_14_12_equal_101 & inst_6_0_equal_0010011);
assign output_srai     = (inst_31_25_equal_0100000 & inst_14_12_equal_101 & inst_6_0_equal_0010011);
assign output_add      = (inst_31_25_equal_0000000 & inst_14_12_equal_000 & inst_6_0_equal_0110011);
assign output_sub      = (inst_31_25_equal_0100000 & inst_14_12_equal_000 & inst_6_0_equal_0110011);
assign output_sll      = (inst_31_25_equal_0000000 & inst_14_12_equal_001 & inst_6_0_equal_0110011);
assign output_slt      = (inst_31_25_equal_0000000 & inst_14_12_equal_010 & inst_6_0_equal_0110011);
assign output_sltu     = (inst_31_25_equal_0000000 & inst_14_12_equal_011 & inst_6_0_equal_0110011);
assign output_xor      = (inst_31_25_equal_0000000 & inst_14_12_equal_100 & inst_6_0_equal_0110011);
assign output_srl      = (inst_31_25_equal_0000000 & inst_14_12_equal_101 & inst_6_0_equal_0110011);
assign output_sra      = (inst_31_25_equal_0100000 & inst_14_12_equal_101 & inst_6_0_equal_0110011);
assign output_or       = (inst_31_25_equal_0000000 & inst_14_12_equal_110 & inst_6_0_equal_0110011);
assign output_and      = (inst_31_25_equal_0000000 & inst_14_12_equal_111 & inst_6_0_equal_0110011);

// Decode with 31:25 , 19:15 , 14:12 , 11:7 and 6:0
assign output_fence    = (inst_31_28_equal_0000 & inst_19_15_equal_00000 & inst_14_12_equal_000 & inst_11_7_equal_00000 & inst_6_0_equal_0001111);

// Decode with ALL bits
assign output_fence_i  = (inst_31_16_equal_000000000000 & inst_19_15_equal_00000 & inst_14_12_equal_001 & inst_11_7_equal_00000 & inst_6_0_equal_0001111);
assign output_ecall    = (inst_31_16_equal_000000000000 & inst_19_15_equal_00000 & inst_14_12_equal_000 & inst_11_7_equal_00000 & inst_6_0_equal_1110011);
assign output_ebreak   = (inst_31_16_equal_000000000001 & inst_19_15_equal_00000 & inst_14_12_equal_000 & inst_11_7_equal_00000 & inst_6_0_equal_1110011);

// 

endmodule