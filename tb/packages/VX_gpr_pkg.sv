`ifndef VX_GPR_PKG_VH
`define VX_GPR_PKG_VH

package VX_gpr_pkg;

    import uvm_pkg::*;
    import VX_gpu_pkg::*;
    import VX_tb_common_pkg::*;
    
    `include "VX_gpr_txn_item.sv"
    `include "VX_gpr_monitor.sv"
    `include "VX_gpr_agent.sv"

    function automatic void write_gpr_entry(VX_gpr_tb_txn_item gpr_info, ref VX_gpr_seq_block_t gpr_block); 
        for(int tid=0; tid < `NUM_THREADS; tid++)begin
            for(int gpr_byte=0; gpr_byte < `SIMD_WIDTH; gpr_byte++)begin
                if(gpr_info.byteen[tid][gpr_byte])
                    gpr_block[gpr_info.bank_num][gpr_info.bank_set][tid][gpr_byte] = gpr_info.gpr_data_entry[tid][gpr_byte];
            end
        end    
    endfunction

endpackage

`endif // VX_GPR_PKG_VH
