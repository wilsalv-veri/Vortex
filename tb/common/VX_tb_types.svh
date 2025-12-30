`ifndef VX_TB_TYPES_VH
`define VX_TB_TYPES_VH

//------------------------------------------------------------------------------
// Core / warp / thread identifiers and masks
//------------------------------------------------------------------------------
    typedef bit [`CORE_ID_WIDTH - 1:0]         VX_core_id_t;
    typedef bit [`NUM_THREADS - 1 :0]          VX_tmask_t;
    typedef  VX_tmask_t [`NUM_WARPS - 1: 0]    VX_core_tmasks_t;//Default initial TMASK is 1
    typedef bit [`UP(`SIMD_BITS)-1:0]          VX_tid_t;
    typedef bit [`NUM_WARPS-1:0]               VX_warp_mask_t;
    typedef bit [`CLOG2(`NUM_WARPS) - 1:0]     VX_warp_num_t; 
    typedef bit [NW_WIDTH-1:0]                 VX_wid_t;

//------------------------------------------------------------------------------
// Pipeline / issue / operand collection / scoreboard helper types
//------------------------------------------------------------------------------
    typedef struct packed {
        bit [REG_TYPE_BITS-1:0] reg_type;
        risc_v_seq_reg_num_t    reg_num;
    } VX_pipeline_reg_num_t;

    typedef struct packed {
        bit use_rs3;
        bit use_rs2;
        bit use_rs1;
    } VX_pipeline_used_rs_t;

    typedef bit  [`ISSUE_WIDTH-1:0]                           VX_pipeline_issue_slice_num_t;

//------------------------------------------------------------------------------
// GPR / register-file modeling helpers
//------------------------------------------------------------------------------
    typedef bit [`NUM_GPR_BANKS - 1 : 0]                        VX_seq_gpr_bank_num_t; 
    typedef bit [0:`GPR_BANK_SIZE - 1]                          VX_seq_gpr_bank_set_t;
    typedef bit [`SIMD_WIDTH - 1:0]                             VX_seq_gpr_byteen;
    typedef VX_seq_gpr_byteen [XLENB - 1:0]                     VX_seq_gpr_entry_byteen;
    typedef bit [`B_WIDTH -1:0]                                 VX_seq_gpr_byte_t;
    typedef bit [`H_WIDTH- 1:0]                                 VX_seq_gpr_half_w_t;
    typedef bit [`W_WIDTH- 1:0]                                 VX_seq_gpr_word_t;
  
    typedef VX_seq_gpr_byte_t [XLENB - 1:0]                     VX_seq_gpr_t;
    typedef VX_seq_gpr_t [`SIMD_WIDTH - 1:0]                    VX_gpr_seq_data_entry_t;
    typedef VX_gpr_seq_data_entry_t [0: `GPR_BANK_SIZE - 1]     VX_gpr_seq_bank_t;
    typedef VX_gpr_seq_bank_t [`NUM_GPR_BANKS - 1:0]            VX_gpr_seq_block_t;
    typedef bit [NUM_REGS-1:0]                                  VX_seq_gpr_reg_mask;

    typedef logic [`NUM_GPR_BANKS - 1 : 0]                      VX_gpr_bank_num_t;
    typedef logic [0:`GPR_BANK_SIZE - 1]                        VX_gpr_bank_set_t;
    typedef logic [`SIMD_WIDTH - 1:0]                           VX_gpr_byteen;
    typedef VX_gpr_byteen [XLENB - 1:0]                         VX_gpr_entry_byteen;
    typedef logic [7:0]                                         VX_gpr_byte_t;

    typedef VX_gpr_byte_t [XLENB - 1:0]                         VX_gpr_t;
    typedef logic [`GPR_DATA_WIDTH - 1:0] [`SIMD_WIDTH - 1:0]   VX_gpr_data_entry_t;
    typedef VX_gpr_data_entry_t [0: `GPR_BANK_SIZE - 1]         VX_gpr_bank_t;
    typedef VX_gpr_bank_t [`NUM_GPR_BANKS - 1:0]                VX_gpr_block_t;

//------------------------------------------------------------------------------
// Post-dominator stack helpers (divergence / reconvergence)
//------------------------------------------------------------------------------
    typedef struct packed {

        VX_tmask_t    join_tmask;
        VX_tmask_t    non_dvg_tmask;
        bit           join_is_else;

    } VX_tb_ipdom_stack_entry_t;

    typedef bit [DV_STACK_SIZEW-1:0]           VX_ipdom_wr_ptr_t;
    typedef VX_ipdom_wr_ptr_t [`NUM_WARPS-1:0] VX_ipdom_wr_ptrs_t;

//------------------------------------------------------------------------------
// Misc / sequence plumbing
//------------------------------------------------------------------------------
    typedef enum { BEQ, BNE, BLTU, BGEU, BLT, BGE } br_instr_type_t; 
    typedef enum {RAW, WAW, WAR}      data_hazard_type_t;

    typedef enum {ADD,  SUB,  SLL,  SLT,   SLTU,    XOR,    SRL,  SRA,
                  OR,   AND,  MUL,  MULH,  MULHSU,  MULHU,  DIV,  DIVU,
                  REM,  REMU} arith_instr_type_t;

    typedef enum {ADDI,  SLTI,  SLTIU,  XORI,  ORI,  ANDI,
                  SLLI,  SRLI,  SRAI} arith_instr_imm_type_t;

    typedef enum {VOTE_ALL, VOTE_ANY, VOTE_UNI, VOTE_BAL} vote_instr_type_t;
    typedef enum {SHFL_UP, SHFL_DOWN, SHFL_BFLY, SHFL_IDX} shfl_instr_type_t;

    typedef enum {LB, LH, LW, LBU, LHU} load_instr_type_t;
    typedef enum {SB, SH, SW}           store_instr_type_t;

    typedef bit [`SHIFT_WIDTH - 1:0]    VX_shift_imm_t;

    typedef bit [`INSTR_ADDRESS_WIDTH - `CLOG2(XLENB) - 1:0] VX_lsu_req_addr_t;
    typedef  VX_lsu_req_addr_t          [`NUM_LSU_LANES-1:0] VX_lsu_req_addresses_t;
    typedef  VX_seq_gpr_byteen          [`NUM_LSU_LANES-1:0] VX_lsu_req_byteen_t;

    typedef  risc_v_seq_data_t          [`NUM_LSU_LANES-1:0] VX_lsu_data;
    typedef  risc_v_seq_data_t             [`SIMD_WIDTH-1:0] VX_commit_data;

`endif // VX_TB_TYPES_VH
