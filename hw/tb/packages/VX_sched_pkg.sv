`ifndef VX_SCHED_PKG_VH
`define VX_SCHED_PKG_VH

package VX_sched_pkg;

    import uvm_pkg::*;
    import VX_tb_common_pkg::*;
    import VX_gpu_pkg::*;
    import VX_gpr_pkg::*;
    
    `include "VX_sched_txn_item.sv"
    `include "VX_sched_monitor.sv"
    `include "VX_sched_agent.sv"
    `include "VX_warp_ctl_scbd.sv"
    
endpackage 

`endif // VX_SCHED_PKG_VH
