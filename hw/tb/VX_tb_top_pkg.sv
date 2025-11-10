
`ifndef VX_TB_TOP_PKG_VH
`define VX_TB_TOP_PKG_VH

import uvm_pkg::*;
import VX_gpu_pkg::*;

`include "VX_types.vh"

package VX_tb_top_pkg;

    //Note: For single socket single core simulation
    
    //Core Params
    localparam SOCKET_ID = 0;
    localparam core_id = 0;
    localparam string INSTANCE_ID = "socket0";
    
    localparam per_core_dcache_bus_if_start = core_id * VX_gpu_pkg::DCACHE_NUM_REQS;
    localparam per_core_dcache_bus_if_end   = per_core_dcache_bus_if_start + VX_gpu_pkg::DCACHE_NUM_REQS - 1;

    localparam RESET_ADDR = {`MEM_ADDR_WIDTH - `CLOG2(`L1_LINE_SIZE){1'b0}};
    localparam RESET_TAG  = {L1_MEM_ARB_TAG_WIDTH{1'b0}};
    localparam RESET_DATA = {16{32'hdeadbeef}};
    
    localparam BOOT_ADDR = `MEM_ADDR_WIDTH'h100;
    localparam MEM_LOAD_BOOT_ADDR = BOOT_ADDR >> `CLOG2(`L1_LINE_SIZE);

    typedef logic [`MEM_ADDR_WIDTH - `CLOG2(`L1_LINE_SIZE) - 1:0]  addr_t;
    typedef logic [L1_MEM_ARB_TAG_WIDTH - 1:0] tag_t;
    
    typedef enum logic  {MEM_LOAD_IDLE=0, MEM_LOAD_DONE=1} memory_load_state_t;
    typedef enum  logic [2:0] {LOAD_IDLE, CORE_REQ_IDLE, EXECUTE_OPERATION, EXECUTE_OPERATION_READ} memory_state_t;
    typedef enum {READ=0, WRITE=1} mem_operation_t;
    
    task VX_init_tb_top_if(virtual VX_tb_top_if tb_top_if);
        tb_top_if.clk               = 1'b0;
        tb_top_if.gbar_reset        = 1'b0;
        tb_top_if.mem_load_reset    = 1'b0;
        tb_top_if.mem_reset         = 1'b0;
        tb_top_if.mem_arb_reset     = 1'b0;
        tb_top_if.icache_reset      = 1'b0;
        tb_top_if.dcache_reset      = 1'b0;
        tb_top_if.core_reset        = 1'b0;

        //Mem Load
        tb_top_if.load_mem          = 1'b0;
        tb_top_if.start_mem_loader  = 1'b0;

    endtask

    task VX_init_tb_top_dcr_if(virtual VX_tb_top_dcr_if tb_top_dcr_if);
        tb_top_dcr_if.write_valid   = 1'b1;
        tb_top_dcr_if.write_addr    = `VX_DCR_BASE_STARTUP_ADDR0;
        tb_top_dcr_if.write_data    = BOOT_ADDR;
    endtask

    task VX_load_mem(virtual VX_tb_top_if tb_top_if);
        fork
            VX_toggle_mem_load_reset(tb_top_if);
            VX_toggle_mem_reset(tb_top_if);
        join
        //tb_top_if.start_mem_loader    = 1'b1;
        //tb_top_if.load_mem            = 1'b1;
        //wait(tb_top_if.mem_loader_done);
        //tb_top_if.start_mem_loader    = 1'b0;
        //tb_top_if.load_mem            = 1'b0;
    endtask

    task VX_toggle_mem_load_reset(virtual VX_tb_top_if tb_top_if);
        repeat(2) begin
            @ (posedge tb_top_if.clk);
            tb_top_if.mem_load_reset = ~ tb_top_if.mem_load_reset;
        end
    endtask

    task VX_toggle_mem_reset(virtual VX_tb_top_if tb_top_if);
        repeat(2) begin
            @ (posedge tb_top_if.clk);
            tb_top_if.mem_reset = ~ tb_top_if.mem_reset;
        end
    endtask

    task VX_toggle_mem_arb_reset(virtual VX_tb_top_if tb_top_if);
        repeat(2) begin
            @ (posedge tb_top_if.clk);
            tb_top_if.mem_arb_reset = ~ tb_top_if.mem_arb_reset;
        end
    endtask

    task VX_toggle_icache_reset(virtual VX_tb_top_if tb_top_if);
        repeat(2) begin
            @ (posedge tb_top_if.clk);
            tb_top_if.icache_reset = ~ tb_top_if.icache_reset;
        end
    endtask

    task VX_toggle_dcache_reset(virtual VX_tb_top_if tb_top_if);
        repeat(2) begin
            @ (posedge tb_top_if.clk);
            tb_top_if.dcache_reset = ~ tb_top_if.dcache_reset;
        end
    endtask

    task VX_toggle_core_reset(virtual VX_tb_top_if tb_top_if);
        repeat(2) begin
            @ (posedge tb_top_if.clk);
            tb_top_if.core_reset = ~ tb_top_if.core_reset;
        end
    endtask

    task VX_toggle_reset_tb_top(virtual VX_tb_top_if tb_top_if);
        fork
            VX_toggle_mem_arb_reset(tb_top_if);
            VX_toggle_icache_reset(tb_top_if);
            VX_toggle_dcache_reset(tb_top_if);
            VX_toggle_core_reset(tb_top_if);

            //Should add here?
            VX_toggle_mem_load_reset(tb_top_if);
            VX_toggle_mem_reset(tb_top_if);
        join
    endtask

    task VX_wait_n_clks(logic clk, int n);
        repeat(n) @(posedge clk);
    endtask

endpackage

`endif // VX_TB_TOP_PKG_VH

