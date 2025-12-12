`ifndef VX_SCOREBOARD_PKG_VH
`define VX_SCOREBOARD_PKG_VH

package VX_scoreboard_pkg;

    import uvm_pkg::*;
    import VX_gpu_pkg::*;
    import VX_tb_common_pkg::*;
   
    `include "VX_ibuffer_txn_item.sv"
    `include "VX_scoreboard_txn_item.sv"
    `include "VX_writeback_txn_item.sv"

    `include "VX_scoreboard_monitor.sv"
    `include "VX_scoreboard_agent.sv"
    `include "VX_scoreboard_scbd.sv"
    
endpackage

`endif