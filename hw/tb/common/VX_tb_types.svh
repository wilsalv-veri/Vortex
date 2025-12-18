`ifndef VX_TB_TYPES_VH
`define VX_TB_TYPES_VH

    `define CACHE_LINE_WIDTH  L2_MEM_DATA_WIDTH
    
    typedef enum {R_TYPE=0,R4_TYPE=1,I_TYPE=2,S_TYPE=3,B_TYPE=4,
                  U_TYPE=5, J_TYPE=6,F_TYPE=7,V_TYPE=8}                  risc_v_seq_instr_type_t;
    typedef enum {INST=0, DATA=1}                                        risc_v_data_type_t;
    typedef enum {GET_INSTR=0, PROCESS_INSTR=1, SEND_INSTR=2}            risc_v_driver_state_t;

    //RISC_V Instruction Macros
    `define OPCODE_WIDTH      7
    `define REG_NUM_WIDTH     5
    `define FUNCT2_WIDTH      2
    `define FUNCT3_WIDTH      3
    `define FUNCT7_WIDTH      7

    `define I_TYPE_IMM_WIDTH  12
    `define I_TYPE_SHIFT_IMM_WIDTH 5
    
    `define S_TYPE_IMM1_WIDTH `I_TYPE_IMM_WIDTH
    `define S_TYPE_IMM0_WIDTH 5
   
    `define IMM_WIDTH 32
    `define B_TYPE_IMM1_WIDTH 6
    `define B_TYPE_IMM0_WIDTH 4
    
    `define U_TYPE_IMM_WIDTH 20
    `define J_TYPE_IMM_WIDTH 20

    `define J_TYPE_IMM1_WIDTH 10
    `define J_TYPE_IMM0_WIDTH 8

    `define SEQ_RAW_DATA_WIDTH  PC_BITS
    `define INSTR_ADDRESS_WIDTH PC_BITS

    `define GPR_DATA_WIDTH       `SEQ_RAW_DATA_WIDTH
    `define GPR_DATA_ENTRY_WIDTH (`XLEN * `SIMD_WIDTH)
    `define GPR_PER_OPC_WARPS    PER_ISSUE_WARPS / `NUM_OPCS         
    `define GPR_BANK_SIZE       (NUM_REGS * SIMD_COUNT * `GPR_PER_OPC_WARPS) / `NUM_GPR_BANKS
    `define GPR_ADDR_WIDTH      `CLOG2(GPR_BANK_SIZE)                  
    `define SFU_LANE_BITS `CLOG2(`NUM_SFU_LANES)

    `define IMM_11 11
    `define IMM_12 12
    `define IMM_20 20

    //Fence Insts
    `define FM_WIDTH 4
    `define PI_WIDTH 1
    `define PO_WIDTH `PI_WIDTH
    `define PR_WIDTH `PI_WIDTH
    `define PW_WIDTH `PI_WIDTH
    `define SI_WIDTH `PI_WIDTH
    `define SO_WIDTH `PI_WIDTH
    `define SR_WIDTH `PI_WIDTH
    `define SW_WIDTH `PI_WIDTH

    //Vec Insts

    `define VF_UNARY_WIDTH  6    
    `define VF_VM_WIDTH     1
    `define VF_NCVT_WIDTH   `REG_NUM_WIDTH    
    `define VF_OPFVV_WIDTH  `FUNCT3_WIDTH  
    
    //Sequence Use
    typedef bit [`INSTR_ADDRESS_WIDTH -1:0]  risc_v_seq_instr_address_t;
    
    typedef bit [`OPCODE_WIDTH - 1:0 ]       risc_v_seq_opcode_t;
    typedef bit [`REG_NUM_WIDTH -1:0 ]       risc_v_seq_reg_num_t;
    typedef bit [`FUNCT2_WIDTH - 1:0 ]       risc_v_seq_funct2_t;
    typedef bit [`FUNCT3_WIDTH - 1:0 ]       risc_v_seq_funct3_t;
    typedef bit [`FUNCT7_WIDTH - 1:0 ]       risc_v_seq_funct7_t;
    typedef bit [`IMM_WIDTH - 1:0    ]       risc_v_seq_imm_t;
    typedef bit [`FM_WIDTH - 1:0     ]       risc_v_seq_fm_t;

    typedef struct packed {
        bit [REG_TYPE_BITS-1:0] reg_type;
        risc_v_seq_reg_num_t    reg_num;
    } VX_pipeline_reg_num_t;

    typedef struct packed {
        bit use_rs3;
        bit use_rs2;
        bit use_rs1;
    } VX_pipeline_used_rs_t;


    typedef bit [`I_TYPE_IMM_WIDTH - 1:0]    risc_v_seq_i_type_imm_t;
    typedef bit [`S_TYPE_IMM1_WIDTH - 1:0]   risc_v_seq_s_type_imm1_t;
    typedef bit [`S_TYPE_IMM0_WIDTH - 1:0]   risc_v_seq_s_type_imm0_t;
    
    typedef bit [`IMM_12 - 1:0]              risc_v_seq_imm12_t;
    typedef bit [`B_TYPE_IMM1_WIDTH - 1:0]   risc_v_seq_b_type_imm1_t;
    typedef bit [`B_TYPE_IMM0_WIDTH - 1:0]   risc_v_seq_b_type_imm0_t;
    
    typedef bit [`U_TYPE_IMM_WIDTH - 1:0]    risc_v_seq_u_type_imm_t;
    
    typedef bit [`J_TYPE_IMM1_WIDTH - 1:0]   risc_v_seq_j_type_imm1_t;
    typedef bit [`J_TYPE_IMM0_WIDTH - 1:0]   risc_v_seq_j_type_imm0_t;

    typedef bit [`PI_WIDTH - 1:0]            risc_v_seq_fence_pi_t;
    typedef bit [`PO_WIDTH - 1:0]            risc_v_seq_fence_po_t;
    typedef bit [`PR_WIDTH - 1:0]            risc_v_seq_fence_pr_t;
    typedef bit [`PW_WIDTH - 1:0]            risc_v_seq_fence_pw_t;
    typedef bit [`SI_WIDTH - 1:0]            risc_v_seq_fence_si_t;
    typedef bit [`SO_WIDTH - 1:0]            risc_v_seq_fence_so_t;
    typedef bit [`SR_WIDTH - 1:0]            risc_v_seq_fence_sr_t;
    typedef bit [`SW_WIDTH - 1:0]            risc_v_seq_fence_sw_t;

    typedef bit [`VF_UNARY_WIDTH - 1:0]      risc_v_vfunary_seq_t;
    typedef bit [`VF_VM_WIDTH - 1:0]         risc_v_vm_seq_t;
    typedef bit [`VF_NCVT_WIDTH - 1:0]       risc_v_vfncvt_seq_t;
    typedef bit [`VF_OPFVV_WIDTH - 1:0]      risc_v_opfvv_seq_t;
    
    typedef bit [`NUM_GPR_BANKS - 1 : 0]     VX_seq_gpr_bank_num_t;
    typedef bit [0:`GPR_BANK_SIZE - 1]       VX_seq_gpr_bank_set_t;
    
    typedef bit [`SIMD_WIDTH - 1:0]          VX_seq_gpr_byteen;
    typedef VX_seq_gpr_byteen [XLENB - 1:0]  VX_seq_gpr_entry_byteen;

    typedef bit [7:0]                                         VX_seq_gpr_byte_t;
    typedef VX_seq_gpr_byte_t [XLENB - 1:0]                   VX_seq_gpr_t;
    typedef VX_seq_gpr_t [`SIMD_WIDTH - 1:0]                  VX_gpr_seq_data_entry_t;
    typedef VX_gpr_seq_data_entry_t [0: `GPR_BANK_SIZE - 1]   VX_gpr_seq_bank_t;
    typedef VX_gpr_seq_bank_t [`NUM_GPR_BANKS - 1:0]          VX_gpr_seq_block_t;

    typedef bit [NUM_REGS-1:0]                                VX_seq_gpr_reg_mask;
    typedef bit  [`ISSUE_WIDTH-1:0]                           VX_pipeline_issue_slice_num_t;

    typedef bit [`NUM_THREADS - 1 :0]          VX_tmask_t;
    typedef  VX_tmask_t [`NUM_WARPS - 1: 0]    VX_core_tmasks_t;//Default initial TMASK is 1
    typedef bit [`UP(`SFU_LANE_BITS)-1:0]      VX_tid_t;

    typedef bit [`NUM_WARPS-1:0]               VX_warp_mask_t;
    typedef bit [`CLOG2(`NUM_WARPS) - 1:0]     VX_warp_num_t; 
    typedef bit [NW_WIDTH-1:0]                 VX_wid_t;
    
   
    typedef struct packed{
        risc_v_seq_fence_pi_t                   pi;
        risc_v_seq_fence_po_t                   po;
        risc_v_seq_fence_pr_t                   pr;
        risc_v_seq_fence_pw_t                   pw;
       
    }risc_v_seq_pred_t;

    typedef struct packed{
        risc_v_seq_fence_si_t                   si;
        risc_v_seq_fence_so_t                   so;
        risc_v_seq_fence_sr_t                   sr;
        risc_v_seq_fence_sw_t                   sw;
       
    }risc_v_seq_succ_t;

    typedef struct packed {

        VX_tmask_t    join_tmask;
        VX_tmask_t    non_dvg_tmask;
        bit           join_is_else;

    } VX_tb_ipdom_stack_entry_t;

    typedef bit [DV_STACK_SIZEW-1:0]           VX_ipdom_wr_ptr_t;
    typedef VX_ipdom_wr_ptr_t [`NUM_WARPS-1:0] VX_ipdom_wr_ptrs_t; 
    
    typedef bit [`SEQ_RAW_DATA_WIDTH - 1:0]    risc_v_seq_data_t;
    typedef enum { BEQ, BNE, BLTU, BGEU, BLT, BGE } br_instr_type_t; 

    typedef enum {RAW, WAW, WAR}      data_hazard_type_t;
    
    typedef enum {ADD,  SUB,  SLL,  SLT,   SLTU,    XOR,    SRL,  SRA,
                  OR,   AND,  MUL,  MULH,  MULHSU,  MULHU,  DIV,  DIVU,
                  REM,  REMU} arith_instr_type_t;


    typedef enum {ADDI,  SLTI,  SLTIU,  XORI,  ORI,  ANDI,
                  SLLI,  SRLI,  SRAI} arith_instr_imm_type_t;

    typedef enum {VOTE_ALL, VOTE_ANY, VOTE_UNI, VOTE_BAL} vote_instr_type_t;
    //********************************************************** */
    //Top Level Use  
    typedef logic [`INSTR_ADDRESS_WIDTH -1:0]  risc_v_instr_address_t;
    
    typedef logic [`CACHE_LINE_WIDTH - 1: 0]  risc_v_cacheline_t;
    typedef logic [`SEQ_RAW_DATA_WIDTH - 1:0] risc_v_cacheline_data_t; 

    typedef logic [`OPCODE_WIDTH - 1:0 ]      risc_v_opcode_t;
    typedef logic [`REG_NUM_WIDTH - 1:0]      risc_v_reg_num_t;
    typedef logic [`FUNCT2_WIDTH - 1:0 ]      risc_v_funct2_t;
    typedef logic [`FUNCT3_WIDTH - 1:0 ]      risc_v_funct3_t;
    typedef logic [`FUNCT7_WIDTH - 1:0 ]      risc_v_funct7_t;
    typedef logic [`FM_WIDTH - 1:0     ]      risc_v_fm_t;


    typedef logic [`I_TYPE_IMM_WIDTH - 1:0]   risc_v_i_type_imm_t;
    typedef logic [`S_TYPE_IMM1_WIDTH - 1:0]  risc_v_s_type_imm1_t;
    typedef logic [`S_TYPE_IMM0_WIDTH - 1:0]  risc_v_s_type_imm0_t;
    typedef logic [`B_TYPE_IMM1_WIDTH - 1:0]  risc_v_b_type_imm1_t;
    typedef logic [`B_TYPE_IMM0_WIDTH - 1:0]  risc_v_b_type_imm0_t;
    typedef logic [`U_TYPE_IMM_WIDTH - 1:0]   risc_v_u_type_imm_t;
    typedef logic [`J_TYPE_IMM_WIDTH - 1:0]   risc_v_j_type_imm_t;

    typedef logic [`PI_WIDTH - 1:0]           risc_v_fence_pi_t;
    typedef logic [`PO_WIDTH - 1:0]           risc_v_fence_po_t;
    typedef logic [`PR_WIDTH - 1:0]           risc_v_fence_pr_t;
    typedef logic [`PW_WIDTH - 1:0]           risc_v_fence_pw_t;
    typedef logic [`SI_WIDTH - 1:0]           risc_v_fence_si_t;
    typedef logic [`SO_WIDTH - 1:0]           risc_v_fence_so_t;
    typedef logic [`SR_WIDTH - 1:0]           risc_v_fence_sr_t;
    typedef logic [`SW_WIDTH - 1:0]           risc_v_fence_sw_t;


    typedef logic [`NUM_GPR_BANKS - 1 : 0]     VX_gpr_bank_num_t;
    typedef logic [0:`GPR_BANK_SIZE - 1]       VX_gpr_bank_set_t;
    
    typedef logic [`SIMD_WIDTH - 1:0]                           VX_gpr_byteen;
    typedef VX_gpr_byteen [XLENB - 1:0]                         VX_gpr_entry_byteen;
    
    typedef logic [7:0]                                         VX_gpr_byte_t;
    typedef VX_gpr_byte_t [XLENB - 1:0]                         VX_gpr_t;
    typedef logic [`GPR_DATA_WIDTH - 1:0] [`SIMD_WIDTH - 1:0]   VX_gpr_data_entry_t;
    typedef VX_gpr_data_entry_t [0: `GPR_BANK_SIZE - 1]         VX_gpr_bank_t;
    typedef VX_gpr_bank_t [`NUM_GPR_BANKS - 1:0]                VX_gpr_block_t;

    typedef struct packed{
        risc_v_fence_pi_t                   pi;
        risc_v_fence_po_t                   po;
        risc_v_fence_pr_t                   pr;
        risc_v_fence_pw_t                   pw;
       
    }risc_v_pred_t;

    typedef struct packed{
        risc_v_fence_si_t                   si;
        risc_v_fence_so_t                   so;
        risc_v_fence_sr_t                   sr;
        risc_v_fence_sw_t                   sw;
       
    }risc_v_succ_t;

    typedef bit [`VF_UNARY_WIDTH - 1:0]       risc_v_vfunary_t;
    typedef bit [`VF_VM_WIDTH - 1:0]          risc_v_vm_t;
    typedef bit [`VF_NCVT_WIDTH - 1:0]        risc_v_vfncvt_t;
    typedef bit [`VF_OPFVV_WIDTH - 1:0]       risc_v_opfvv_t;
   

     //********************Instruction Types*********************************/
    
    typedef struct packed{
        risc_v_funct7_t                      funct7;
        risc_v_reg_num_t                     rs2;
        risc_v_reg_num_t                     rs1;
        risc_v_funct3_t                      funct3;
        risc_v_reg_num_t                     rd;
        risc_v_opcode_t                      opcode;
    } r_type_inst_t;

    typedef struct packed{
        risc_v_reg_num_t                     rs3;
        risc_v_funct2_t                      funct2;
        risc_v_reg_num_t                     rs2;
        risc_v_reg_num_t                     rs1;
        risc_v_funct3_t                      funct3;
        risc_v_reg_num_t                     rd;
        risc_v_opcode_t                      opcode;
    } r4_type_inst_t;

    typedef struct packed{
        risc_v_i_type_imm_t                  imm;
        risc_v_reg_num_t                     rs1;
        risc_v_funct3_t                      funct3;
        risc_v_reg_num_t                     rd;
        risc_v_opcode_t                      opcode;
    } i_type_inst_t;
    
    typedef struct packed{
        risc_v_s_type_imm1_t                 imm1;
        risc_v_reg_num_t                     rs1;
        risc_v_funct3_t                      funct3;
        risc_v_s_type_imm0_t                 imm0;
        risc_v_opcode_t                      opcode;
    } s_type_inst_t;
    
    typedef struct packed{
        logic                                twelve;
        risc_v_b_type_imm1_t                 imm1;
        risc_v_reg_num_t                     rs2;
        risc_v_reg_num_t                     rs1;
        risc_v_funct3_t                      funct3;
        risc_v_b_type_imm0_t                 imm0;
        logic                                eleven;
        risc_v_opcode_t                      opcode;
    } b_type_inst_t;

    typedef struct packed{
        risc_v_u_type_imm_t                 imm;
        risc_v_reg_num_t                    rd;
        risc_v_opcode_t                     opcode;
    } u_type_inst_t;

    typedef struct packed{
        risc_v_j_type_imm_t                 imm;
        risc_v_reg_num_t                    rd;
        risc_v_opcode_t                     opcode;
    } j_type_inst_t;

    typedef struct packed{
        risc_v_fm_t                         fm;
        risc_v_pred_t                       pred;
        risc_v_succ_t                       succ;
        risc_v_reg_num_t                    rs1;
        risc_v_funct3_t                     funct3;
        risc_v_reg_num_t                    rd;
    }f_type_inst_t;

    typedef struct packed{
        risc_v_vfunary_t                  vfunary; 
        risc_v_vm_t                         vm;
        risc_v_reg_num_t                    vs2;
        risc_v_vfncvt_t                     vfncvtbf16;
        risc_v_opfvv_t                      opfvv;
        risc_v_reg_num_t                    vd;
    }v_type_inst_t;
    
    typedef union {
        r_type_inst_t                       r_type_inst;
        i_type_inst_t                       i_type_inst;
        s_type_inst_t                       s_type_inst;
        b_type_inst_t                       b_type_inst;
        u_type_inst_t                       u_type_inst;
        j_type_inst_t                       j_type_inst;
        f_type_inst_t                       f_type_inst;
        v_type_inst_t                       v_type_inst;
        risc_v_cacheline_data_t             data;
    }risc_v_inst_t;
    
`endif // VX_TB_TYPES_VH
