interface VX_risc_v_inst_if import VX_tb_common_pkg::*;();
    
    risc_v_seq_inst_type_t       inst_type;
    risc_v_seq_opcode_t          opcode;
    risc_v_seq_reg_num_t         rs1;
    risc_v_seq_reg_num_t         rs2;
    risc_v_seq_reg_num_t         rd;
    risc_v_seq_funct3_t          funct3;
    risc_v_seq_funct7_t          funct7;
    
    risc_v_seq_i_type_imm_t      i_type_imm;
    risc_v_seq_s_type_imm1_t     s_type_imm1;
    risc_v_seq_s_type_imm0_t     s_type_imm0;
    risc_v_seq_b_type_imm1_t     b_type_imm1;
    risc_v_seq_b_type_imm0_t     b_type_imm0;
    risc_v_seq_u_type_imm_t      u_type_imm;
    risc_v_seq_j_type_imm1_t     j_type_imm1;
    risc_v_seq_j_type_imm0_t     j_type_imm0;

    modport slave(
        input  inst_type,
        input  opcode,
        input  rs1,
        input  rs2,
        input  rd,
        input  funct3,
        input  funct7,
        input  i_type_imm,
        input  s_type_imm1,
        input  s_type_imm0,
        input  b_type_imm1,
        input  b_type_imm0,
        input  u_type_imm,
        input  j_type_imm1,
        input  j_type_imm0
    );

    modport master(
        output  inst_type,
        output  opcode,
        output  rs1,
        output  rs2,
        output  rd,
        output  funct3,
        output  funct7,
        output  i_type_imm,
        output  s_type_imm1,
        output  s_type_imm0,
        output  b_type_imm1,
        output  b_type_imm0,
        output  u_type_imm,
        output  j_type_imm1,
        output  j_type_imm0
    );
    
endinterface