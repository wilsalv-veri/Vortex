`ifndef VX_TB_COMMON_PKG_VH
`define VX_TB_COMMON_PKG_VH

package VX_tb_common_pkg;

    import uvm_pkg::*;
    import VX_gpu_pkg::*;
    import VX_tb_top_pkg::*;

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
    `include "VX_risc_v_instr_queue.sv"
    `include "VX_seq_result_txn_item.sv"

    `include "VX_risc_v_sequencer.sv"
    `include "VX_risc_v_driver.sv"
    `include "VX_risc_v_monitor.sv"
    `include "VX_risc_v_agent.sv"
   
    `include "VX_risc_v_base_seq.sv"
    `include "VX_risc_v_base_instr_seq.sv"
    `include "VX_risc_v_base_data_seq.sv"
    `include "VX_risc_v_base_seq_lib.sv"

    function VX_tmask_t get_max_possible_tmask();
        
        VX_tmask_t max_tmask;
        max_tmask  = VX_tmask_t'(1);

        for(int i=0; i< `NUM_THREADS; i++)begin
            max_tmask  = (max_tmask << 1) | 1;
        end
        
        return max_tmask;
    endfunction
    
endpackage

`endif // VX_TB_COMMON_PKG_VH
