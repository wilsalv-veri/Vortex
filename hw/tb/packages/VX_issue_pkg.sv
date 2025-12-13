`ifndef VX_ISSUE_PKG_VH
`define VX_ISSUE_PKG_VH

package VX_issue_pkg;

    import uvm_pkg::*;
    import VX_gpu_pkg::*;
    import VX_gpr_pkg::*;
    import VX_tb_common_pkg::*;

   
    `include "VX_ibuffer_txn_item.sv"
    `include "VX_scoreboard_txn_item.sv"
    `include "VX_writeback_txn_item.sv"
    `include "VX_operands_txn_item.sv"

    `include "VX_issue_monitor.sv"
    `include "VX_issue_agent.sv"
    `include "VX_data_hazard_scbd.sv"
    `include "VX_operands_scbd.sv"
    
endpackage

`endif