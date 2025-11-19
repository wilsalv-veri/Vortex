`ifndef VX_TB_COMMON_PKG_VH
`define VX_TB_COMMON_PKG_VH

package VX_tb_common_pkg;

    import uvm_pkg::*;
    import VX_gpu_pkg::*;

    virtual VX_schedule_if      schedule_if;
    virtual VX_fetch_if         fetch_if;
    virtual VX_decode_if        decode_if;
    virtual VX_sched_csr_if     sched_csr_if;
    virtual VX_decode_sched_if  decode_sched_if;
    virtual VX_issue_sched_if   issue_sched_if[`ISSUE_WIDTH];
    virtual VX_commit_sched_if  commit_sched_if;
    virtual VX_commit_csr_if    commit_csr_if;
    virtual VX_branch_ctl_if    branch_ctl_if[`NUM_ALU_BLOCKS];
    virtual VX_warp_ctl_if      warp_ctl_if;
    virtual VX_dispatch_if      dispatch_if[NUM_EX_UNITS * `ISSUE_WIDTH];
    virtual VX_commit_if        commit_if[NUM_EX_UNITS * `ISSUE_WIDTH];
    virtual VX_writeback_if     writeback_if[`ISSUE_WIDTH];
   
    localparam INST_PER_CACHE_LINE = L2_MEM_DATA_WIDTH / PC_BITS; 

    `include "VX_tb_types.svh"
    
    `include "VX_sequence_items.sv"
    `include "VX_risc_v_Rtype_seq_item.sv"
    `include "VX_risc_v_R4type_seq_item.sv"
    `include "VX_risc_v_Itype_seq_item.sv"
    `include "VX_risc_v_Btype_seq_item.sv"
    `include "VX_risc_v_Stype_seq_item.sv"
    `include "VX_risc_v_Utype_seq_item.sv"
    `include "VX_risc_v_Jtype_seq_item.sv"
    `include "VX_risc_v_Ftype_seq_item.sv"
    `include "VX_risc_v_Vtype_seq_item.sv"
     
    `include "VX_tb_define.svh"
    
    `include "VX_risc_v_sequencer.sv"
    `include "VX_risc_v_driver.sv"
    `include "VX_risc_v_monitor.sv"
    `include "VX_risc_v_agent.sv"
    `include "VX_tb_environment.sv"

    `include "VX_risc_v_base_seq.sv"
    `include "VX_risc_v_base_instr_seq.sv"
    `include "VX_risc_v_base_data_seq.sv"

    
endpackage

`endif // VX_TB_COMMON_PKG_VH
