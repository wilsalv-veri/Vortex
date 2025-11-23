`ifndef VX_GPR_PKG_VH
`define VX_GPR_PKG_VH

package VX_gpr_pkg;

    import uvm_pkg::*;
    import VX_gpu_pkg::*;
    import VX_tb_common_pkg::*;
    
    `include "VX_gpr_txn_item.sv"
    `include "VX_gpr_monitor.sv"
    `include "VX_gpr_agent.sv"

endpackage

`endif // VX_GPR_PKG_VH
