`ifndef VX_TB_COMMON_PKG_VH
`define VX_TB_COMMON_PKG_VH


package VX_tb_common_pkg;

    import uvm_pkg::*;
    import VX_gpu_pkg::*;

    `include "VX_tb_define.svh"
    `include "VX_tb_types.svh"
     
    localparam INST_PER_CACHE_LINE = L2_MEM_DATA_WIDTH / PC_BITS; 

    `include "VX_sequence_items.sv"
    `include "VX_risc_v_sequencer.sv"
    `include "VX_risc_v_driver.sv"
    `include "VX_risc_v_monitor.sv"
    `include "VX_risc_v_agent.sv"
    `include "VX_tb_environment.sv"
    
endpackage

`endif // VX_TB_COMMON_PKG_VH
