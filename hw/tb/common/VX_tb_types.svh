`ifndef VX_TB_TYPES_VH
`define VX_TB_TYPES_VH

    typedef enum {R_TYPE=0,I_TYPE=1,S_TYPE=2,B_TYPE=3,U_TYPE=4,J_TYPE=5} risc_v_seq_inst_type_t;

    //RISC_V Instruction Macros
    `define OPCODE_WIDTH      8
    `define REG_NUM_WIDTH     5
    `define FUNCT3_WIDTH      3
    `define FUNCT7_WIDTH      7

    `define I_TYPE_IMM_WIDTH  12
    
    `define S_TYPE_IMM1_WIDTH `I_TYPE_IMM_WIDTH
    `define S_TYPE_IMM0_WIDTH 5
    
    `define B_TYPE_IMM1_WIDTH 7
    `define B_TYPE_IMM0_WIDTH 4
    
    `define U_TYPE_IMM_WIDTH 20
    
    `define J_TYPE_IMM1_WIDTH 10
    `define J_TYPE_IMM0_WIDTH 8

    //Sequence Use
    typedef bit [`OPCODE_WIDTH - 1:0 ]       risc_v_seq_opcode_t;
    typedef bit [`REG_NUM_WIDTH - 1:0]       risc_v_seq_reg_num_t;
    typedef bit [`FUNCT3_WIDTH - 1:0 ]       risc_v_seq_funct3_t;
    typedef bit [`FUNCT7_WIDTH - 1:0 ]       risc_v_seq_funct7_t;

    typedef bit [`I_TYPE_IMM_WIDTH - 1:0]    risc_v_seq_i_type_imm_t;
    typedef bit [`S_TYPE_IMM1_WIDTH - 1:0]   risc_v_seq_s_type_imm1_t;
    typedef bit [`S_TYPE_IMM0_WIDTH - 1:0]   risc_v_seq_s_type_imm0_t;
    typedef bit [`B_TYPE_IMM1_WIDTH - 1:0]   risc_v_seq_b_type_imm1_t;
    typedef bit [`B_TYPE_IMM0_WIDTH - 1:0]   risc_v_seq_b_type_imm0_t;
    typedef bit [`U_TYPE_IMM_WIDTH - 1:0]    risc_v_seq_u_type_imm_t;
    typedef bit [`J_TYPE_IMM1_WIDTH - 1:0]   risc_v_seq_j_type_imm1_t;
    typedef bit [`J_TYPE_IMM0_WIDTH - 1:0]   risc_v_seq_j_type_imm0_t;

    //Top Level Use
    typedef logic [`OPCODE_WIDTH - 1:0 ]     risc_v_opcode_t;
    typedef logic [`REG_NUM_WIDTH - 1:0]     risc_v_reg_num_t;
    typedef logic [`FUNCT3_WIDTH - 1:0 ]     risc_v_funct3_t;
    typedef logic [`FUNCT7_WIDTH - 1:0 ]     risc_v_funct7_t;

    typedef logic [`I_TYPE_IMM_WIDTH - 1:0]  risc_v_i_type_imm_t;
    typedef logic [`S_TYPE_IMM1_WIDTH - 1:0] risc_v_s_type_imm1_t;
    typedef logic [`S_TYPE_IMM0_WIDTH - 1:0] risc_v_s_type_imm0_t;
    typedef logic [`B_TYPE_IMM1_WIDTH - 1:0] risc_v_b_type_imm1_t;
    typedef logic [`B_TYPE_IMM0_WIDTH - 1:0] risc_v_b_type_imm0_t;
    typedef logic [`U_TYPE_IMM_WIDTH - 1:0]  risc_v_u_type_imm_t;
    typedef logic [`J_TYPE_IMM1_WIDTH - 1:0] risc_v_j_type_imm1_t;
    typedef logic [`J_TYPE_IMM0_WIDTH - 1:0] risc_v_j_type_imm0_t;

    typedef struct packed{
        risc_v_funct7_t                      funct7;
        risc_v_reg_num_t                     rs2;
        risc_v_reg_num_t                     rs1;
        risc_v_funct3_t                      funct3;
        risc_v_reg_num_t                     rd;
        risc_v_opcode_t                      opcode;
    } r_type_inst_t;
    
    typedef struct packed{
        risc_v_i_type_imm_t                  immediate;
        risc_v_reg_num_t                     rs1;
        risc_v_funct3_t                      funct3;
        risc_v_reg_num_t                     rd;
        risc_v_opcode_t                      opcode;
    } i_type_inst_t;
    
    typedef struct packed{
        risc_v_s_type_imm1_t                 immediate1;
        risc_v_reg_num_t                     rs1;
        risc_v_funct3_t                      funct3;
        risc_v_s_type_imm0_t                 immediate0;
        risc_v_opcode_t                      opcode;
    } s_type_inst_t;
    
    typedef struct packed{
        logic                                twelve;
        risc_v_b_type_imm1_t                 immediate1;
        risc_v_reg_num_t                     rs2;
        risc_v_reg_num_t                     rs1;
        risc_v_funct3_t                      funct3;
        risc_v_b_type_imm0_t                 immediate0;
        logic                                eleven;
        risc_v_opcode_t                      opcode;
    } b_type_inst_t;

    typedef struct packed{
        risc_v_u_type_imm_t                 immediate;
        risc_v_reg_num_t                    rd;
        risc_v_opcode_t                     opcode;
    } u_type_inst_t;

    typedef struct packed{
        logic                               twenty;
        risc_v_j_type_imm1_t                immediate1;
        logic                               eleven;
        risc_v_j_type_imm0_t                immediate0;
        risc_v_reg_num_t                    rd;
        risc_v_opcode_t                     opcode;
    } j_type_inst_t;

    typedef union {
        r_type_inst_t r_type_inst;
        i_type_inst_t i_type_inst;
        s_type_inst_t s_type_inst;
        b_type_inst_t b_type_inst;
        u_type_inst_t u_type_inst;
        j_type_inst_t j_type_inst;
    } risc_v_inst_t;
    
`endif // VX_TB_TYPES_VH
