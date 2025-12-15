import uvm_pkg::*;
import VX_tb_top_pkg::*;
import VX_gpu_pkg::*;

`include "uvm_macros.svh"
//`include "VX_types.vh"
import VX_tb_common_pkg::*;
import VX_sched_pkg::*;

module VX_tb_top;
   
    //Interfaces
    VX_tb_top_if             tb_top_if();
    VX_tb_top_dcr_if         tb_top_dcr_if();
    virtual VX_tb_top_if     tb_top_if_v;
    virtual VX_tb_top_dcr_if tb_top_dcr_if_v;
    
    //Simulation Interfaces
    VX_sched_tb_if           sched_tb_if();
    VX_gpr_tb_if             gpr_tb_if();

    VX_uvm_test_if           uvm_test_ifc();
    VX_mem_load_if           mem_load_ifc();
    VX_risc_v_inst_if        riscv_inst_ifc();


    VX_dcr_bus_if            dcr_bus_if();
    VX_dcr_bus_if            core_dcr_bus_if();
    VX_gbar_bus_if           gbar_bus_if(); // Barrier

    //DCR Signals
    logic write_valid;
    logic [VX_DCR_ADDR_WIDTH-1:0] write_addr;
    logic [VX_DCR_DATA_WIDTH-1:0] write_data;
 
    
    //Clk Gen
    always #1 tb_top_if.clk = ~tb_top_if.clk;

    //Initialization Flow
    initial begin
        tb_top_if_v     = tb_top_if;
        tb_top_dcr_if_v = tb_top_dcr_if;
        VX_init_tb_top_if(tb_top_if_v);
        //VX_load_mem(tb_top_if_v);
        
        @(posedge tb_top_if.clk);
        VX_init_tb_top_dcr_if(tb_top_dcr_if_v);
        VX_toggle_reset_tb_top(tb_top_if_v);      
    end

    assign dcr_bus_if.write_valid = tb_top_dcr_if.write_valid;
    assign dcr_bus_if.write_addr  = tb_top_dcr_if.write_addr;
    assign dcr_bus_if.write_data  = tb_top_dcr_if.write_data;

    assign mem_load_ifc.clk       = tb_top_if.clk;

    `BUFFER_DCR_BUS_IF (core_dcr_bus_if, dcr_bus_if, 1'b1, (`SOCKET_SIZE > 1))

    //Instantiations  
    VX_mem_bus_if #(
        .DATA_SIZE (`L1_LINE_SIZE),
        .TAG_WIDTH (L1_MEM_ARB_TAG_WIDTH)
    ) per_socket_mem_bus_if[NUM_SOCKETS * `L1_MEM_PORTS]();


    VX_mem_bus_if #(
        .DATA_SIZE (ICACHE_WORD_SIZE),
        .TAG_WIDTH (ICACHE_TAG_WIDTH)
    ) per_core_icache_bus_if[`SOCKET_SIZE]();

    VX_mem_bus_if #(
        .DATA_SIZE (ICACHE_LINE_SIZE),
        .TAG_WIDTH (ICACHE_MEM_TAG_WIDTH)
    ) icache_mem_bus_if[1]();

    VX_mem_bus_if #(
        .DATA_SIZE (DCACHE_WORD_SIZE),
        .TAG_WIDTH (DCACHE_TAG_WIDTH)
    ) per_core_dcache_bus_if[`SOCKET_SIZE * DCACHE_NUM_REQS]();

    VX_mem_bus_if #(
        .DATA_SIZE (DCACHE_LINE_SIZE),
        .TAG_WIDTH (DCACHE_MEM_TAG_WIDTH)
    ) dcache_mem_bus_if[`L1_MEM_PORTS]();


    VX_mem_bus_if #(
        .DATA_SIZE (`L1_LINE_SIZE),
        .TAG_WIDTH (L1_MEM_TAG_WIDTH)
    ) l1_mem_bus_if[2]();

    VX_mem_bus_if #(
        .DATA_SIZE (`L1_LINE_SIZE),
        .TAG_WIDTH (L1_MEM_ARB_TAG_WIDTH)
    ) l1_mem_arb_bus_if[1]();

     VX_mem_bus_if #(
        .DATA_SIZE (`L1_LINE_SIZE),
        .TAG_WIDTH (L1_MEM_ARB_TAG_WIDTH)
    ) l1_mem_load_bus_if();

    `ASSIGN_VX_MEM_BUS_IF_EX (l1_mem_bus_if[0], icache_mem_bus_if[0], L1_MEM_TAG_WIDTH, ICACHE_MEM_TAG_WIDTH, UUID_WIDTH);
    `ASSIGN_VX_MEM_BUS_IF_EX (l1_mem_bus_if[1], dcache_mem_bus_if[0], L1_MEM_TAG_WIDTH, DCACHE_MEM_TAG_WIDTH, UUID_WIDTH);

    VX_mem_arb #(
        .NUM_INPUTS (2),
        .NUM_OUTPUTS(1),
        .DATA_SIZE  (`L1_LINE_SIZE),
        .TAG_WIDTH  (L1_MEM_TAG_WIDTH),
        .TAG_SEL_IDX(0),
        .ARBITER    ("P"), // prioritize the icache
        .REQ_OUT_BUF(3),
        .RSP_OUT_BUF(3)
    ) mem_arb (
        .clk        (tb_top_if.clk),
        .reset      (tb_top_if.mem_arb_reset),
        .bus_in_if  (l1_mem_bus_if),
        .bus_out_if (l1_mem_arb_bus_if)
    );

    `ASSIGN_VX_MEM_BUS_IF (per_socket_mem_bus_if[0], l1_mem_arb_bus_if[0]);

    VX_mem_loader  vx_mem_loader(.clk(tb_top_if.clk), .reset(tb_top_if.mem_load_reset), .mem_load_bus_if (l1_mem_load_bus_if), .mem_load_if(mem_load_ifc) ); //.start_loading(tb_top_if.start_mem_loader) , .done_loading (tb_top_if.mem_loader_done)
    Memory_BFM     vx_mem_model (.clk(tb_top_if.clk), .reset(tb_top_if.mem_reset), .uvm_test_if (uvm_test_ifc), .load_if (l1_mem_load_bus_if), .mem_bus_if (l1_mem_arb_bus_if[0])); //.load (tb_top_if.load_mem)

    `ifdef SCOPE
        localparam scope_core = 0;
        `SCOPE_IO_SWITCH (`SOCKET_SIZE);
    `endif
    
    `ifdef GBAR_ENABLE
        VX_gbar_bus_if per_core_gbar_bus_if[`SOCKET_SIZE]();

        VX_gbar_arb #(
            .NUM_REQS (`SOCKET_SIZE),
            .OUT_BUF  ((`SOCKET_SIZE > 1) ? 2 : 0)
        ) gbar_arb (
            .clk        (tb_top_if.clk),
            .reset      (tb_top_if.gbar_reset),
            .bus_in_if  (per_core_gbar_bus_if),
            .bus_out_if (gbar_bus_if)
        );
    `endif

    //D-Cache
    VX_cache_cluster #(
        .INSTANCE_ID    (`SFORMATF(("%s-dcache", INSTANCE_ID))),
        .NUM_UNITS      (`NUM_DCACHES),
        .NUM_INPUTS     (`SOCKET_SIZE),
        .TAG_SEL_IDX    (0),
        .CACHE_SIZE     (`DCACHE_SIZE),
        .LINE_SIZE      (DCACHE_LINE_SIZE),
        .NUM_BANKS      (`DCACHE_NUM_BANKS),
        .NUM_WAYS       (`DCACHE_NUM_WAYS),
        .WORD_SIZE      (DCACHE_WORD_SIZE),
        .NUM_REQS       (DCACHE_NUM_REQS),
        .MEM_PORTS      (`L1_MEM_PORTS),
        .CRSQ_SIZE      (`DCACHE_CRSQ_SIZE),
        .MSHR_SIZE      (`DCACHE_MSHR_SIZE),
        .MRSQ_SIZE      (`DCACHE_MRSQ_SIZE),
        .MREQ_SIZE      (`DCACHE_WRITEBACK ? `DCACHE_MSHR_SIZE : `DCACHE_MREQ_SIZE),
        .TAG_WIDTH      (DCACHE_TAG_WIDTH),
        .WRITE_ENABLE   (1), 
        .WRITEBACK      (`DCACHE_WRITEBACK),
        .DIRTY_BYTES    (`DCACHE_DIRTYBYTES),
        .REPL_POLICY    (`DCACHE_REPL_POLICY),
        .NC_ENABLE      (1), 
        .CORE_OUT_BUF   (3),
        .MEM_OUT_BUF    (2)
    ) dcache (
    `ifdef PERF_ENABLE
        .cache_perf     (dcache_perf),
    `endif
        .clk            (tb_top_if.clk),
        .reset          (tb_top_if.dcache_reset),
        .core_bus_if    (per_core_dcache_bus_if),
        .mem_bus_if     (dcache_mem_bus_if)
    );

    //I-Cache
    VX_cache_cluster #(
        .INSTANCE_ID    (`SFORMATF(("%s-icache", INSTANCE_ID))),
        .NUM_UNITS      (`NUM_ICACHES),
        .NUM_INPUTS     (`SOCKET_SIZE),
        .TAG_SEL_IDX    (0),
        .CACHE_SIZE     (`ICACHE_SIZE),
        .LINE_SIZE      (ICACHE_LINE_SIZE),
        .NUM_BANKS      (1),
        .NUM_WAYS       (`ICACHE_NUM_WAYS),
        .WORD_SIZE      (ICACHE_WORD_SIZE),
        .NUM_REQS       (1),
        .MEM_PORTS      (1),
        .CRSQ_SIZE      (`ICACHE_CRSQ_SIZE),
        .MSHR_SIZE      (`ICACHE_MSHR_SIZE),
        .MRSQ_SIZE      (`ICACHE_MRSQ_SIZE),
        .MREQ_SIZE      (`ICACHE_MREQ_SIZE),
        .TAG_WIDTH      (ICACHE_TAG_WIDTH),
        .WRITE_ENABLE   (0),
        .REPL_POLICY    (`ICACHE_REPL_POLICY),
        .NC_ENABLE      (0),
        .CORE_OUT_BUF   (3),
        .MEM_OUT_BUF    (2)
    ) icache (
    `ifdef PERF_ENABLE
        .cache_perf     (icache_perf),
    `endif
        .clk            (tb_top_if.clk),
        .reset          (tb_top_if.icache_reset),
        .core_bus_if    (per_core_icache_bus_if),
        .mem_bus_if     (icache_mem_bus_if)
    );
  
    VX_core #(
            .CORE_ID  ((SOCKET_ID * `SOCKET_SIZE) + core_id),
            .INSTANCE_ID (`SFORMATF(("%s-core%0d", INSTANCE_ID, core_id)))
    ) core (
        `SCOPE_IO_BIND  (scope_core + core_id)

        .clk            (tb_top_if.clk),
        .reset          (tb_top_if.core_reset),

    `ifdef PERF_ENABLE
        .sysmem_perf    (sysmem_perf_tmp),
    `endif

        .dcr_bus_if     (core_dcr_bus_if),

        .dcache_bus_if  (per_core_dcache_bus_if[per_core_dcache_bus_if_start : per_core_dcache_bus_if_end]),

        .icache_bus_if  (per_core_icache_bus_if[core_id]),

    `ifdef GBAR_ENABLE
        .gbar_bus_if    (per_core_gbar_bus_if[core_id]),
    `endif

        .busy           (uvm_test_ifc.core_busy)
    );

    //SVA
    bind core.schedule VX_sched_assert sched_sva(.*);

    //COV
    bind core.schedule VX_sched_cov sched_cov(  .clk            (clk),
                                                .reset          (reset),
                                                .sched_busy     (busy),
                                                .wid            (schedule_wid),

                                                .warp_ctl_valid (warp_ctl_if.valid),
                                                .tmc_valid      (warp_ctl_if.tmc.valid),
                                                .wspawn_valid   (warp_ctl_if.wspawn.valid),
                                                .bar_valid      (warp_ctl_if.barrier.valid),
                                                .split_valid    (warp_ctl_if.split.valid),
                                                
                                                .join_valid     (join_valid),
                                                .join_is_dvg    (join_is_dvg),
                                                .join_is_else   (join_is_else),
   
                                                .ipdom_push     (split_join.g_enable.ipdom_push),  
                                                .ipdom_pop      (split_join.g_enable.ipdom_pop),
                                                .ipdom_wr_ptrs  (split_join.g_enable.ipdom_wr_ptr),

                                                .thread_masks   (thread_masks),
                                                .active_warps   (active_warps),
                                                .stalled_warps  (stalled_warps),

                                                .br_valid       (branch_valid),
                                                .br_taken       (branch_taken),
                                                .br_wid         (branch_wid)
                                                );




    
    //GPR Cov
    //genvar gpr_bank_num;

    for (genvar issue_id = 0; issue_id < `ISSUE_WIDTH; ++issue_id) begin : g_slices
        
        bind core.issue.g_slices[issue_id].issue_slice.scoreboard VX_scoreboard_assert scoreboard_sva(.*);
      
        bind core.issue.g_slices[issue_id].issue_slice.scoreboard VX_scoreboard_cov scoreboard_cov (.*);
        bind core.issue.g_slices[issue_id].issue_slice.operands   VX_opc_cov        opc_cov (.*);

        for (genvar opc_num = 0; opc_num < `NUM_OPCS; opc_num++)begin
            
            bind core.issue.g_slices[issue_id].issue_slice.operands.g_collectors[opc_num].opc_unit   VX_operands_assert   opc_sva (.*);

            for(genvar gpr_bank_num = 0; gpr_bank_num < `NUM_BANKS; gpr_bank_num++)begin
                
                bind core.issue.g_slices[issue_id].issue_slice.operands.g_collectors[opc_num].opc_unit.g_gpr_rams[gpr_bank_num]   VX_gpr_cov    gpr_cov (  .clk           (clk),
                                                                                                                                                           .gpr_read      (pipe_fire_st1),
                                                                                                                                                           .gpr_write     (gpr_wr_enabled), 
                                                                                                                                                           .gpr_wr_set    (gpr_wr_addr) ,
                                                                                                                                                           .gpr_rd_set    (gpr_rd_addr), 
                                                                                                                                                           .gpr_wr_byteen (gpr_wr_byteen)
                                                                                                                                                        );
            end
        end
    end
    
   
    initial begin
        uvm_config_db #(virtual VX_tb_top_if                        )::set(null, "*", "tb_top_if", tb_top_if);
        uvm_config_db #(virtual VX_uvm_test_if                      )::set(null, "*", "uvm_test_ifc", uvm_test_ifc);
        uvm_config_db #(virtual VX_mem_load_if                      )::set(null, "*", "mem_load_ifc", mem_load_ifc);
        uvm_config_db #(virtual VX_risc_v_inst_if                   )::set(null, "*", "riscv_inst_ifc", riscv_inst_ifc);   
       
        uvm_config_db #(virtual VX_sched_tb_if                      )::set(null, "*", "sched_tb_if", sched_tb_if);
        uvm_config_db #(virtual VX_gpr_tb_if                        )::set(null, "*", "gpr_tb_if", gpr_tb_if);

        //Core Interfaces          
        uvm_config_db #(virtual VX_schedule_if                      )::set(null, "*", "schedule_if", core.schedule_if);
        uvm_config_db #(virtual VX_fetch_if                         )::set(null, "*", "fetch_if", core.fetch_if);
        uvm_config_db #(virtual VX_fetch_if                         )::set(null, "*", "fetch_if", core.fetch_if);
        uvm_config_db #(virtual VX_decode_if                        )::set(null, "*", "decode_if", core.decode_if);
        uvm_config_db #(virtual VX_sched_csr_if                     )::set(null, "*", "sched_csr_if", core.sched_csr_if);
        uvm_config_db #(virtual VX_decode_sched_if                  )::set(null, "*", "decode_sched_if", core.decode_sched_if);
        uvm_config_db #(virtual VX_commit_sched_if                  )::set(null, "*", "commit_sched_if", core.commit_sched_if);
        uvm_config_db #(virtual VX_commit_csr_if                    )::set(null, "*", "commit_csr_if", core.commit_csr_if);
        uvm_config_db #(virtual VX_warp_ctl_if                      )::set(null, "*", "warp_ctl_if", core.warp_ctl_if);
    end

    `include "VX_sched_tb_if_connections.sv"
    `include "VX_gpr_tb_if_connections.sv"

    genvar idx, jdx;
    generate 
        
        for( idx=0; idx < `ISSUE_WIDTH; idx++) begin
            
            for(jdx=0; jdx < PER_ISSUE_WARPS; jdx++)begin
                initial begin
                    uvm_config_db #(virtual VX_ibuffer_if               )::set(null, "*", $sformatf("ibuffer_if[%0d][%0d]", idx,jdx), core.issue.g_slices[idx].issue_slice.ibuffer_if[jdx]);
                end
            end
            
            initial begin
                uvm_config_db #(virtual VX_issue_sched_if               )::set(null, "*", $sformatf("issue_sched_if[%0d]", idx), core.issue_sched_if[idx]);
                uvm_config_db #(virtual VX_scoreboard_if                )::set(null, "*", $sformatf("scoreboard_if[%0d]",  idx), core.issue.g_slices[idx].issue_slice.scoreboard_if);
                uvm_config_db #(virtual VX_writeback_if                 )::set(null, "*", $sformatf("writeback_if[%0d]",   idx), core.writeback_if[idx]);
                uvm_config_db #(virtual VX_operands_if                  )::set(null, "*", $sformatf("operands_if[%0d]", idx),    core.issue.g_slices[idx].issue_slice.operands_if);
            end
        end

        for(idx=0; idx < `NUM_ALU_BLOCKS; idx++)begin
            initial begin
                uvm_config_db #(virtual VX_branch_ctl_if                )::set(null, "*", "branch_ctl_if", core.branch_ctl_if[idx]);
            end
        end
        for(idx=0; idx < NUM_EX_UNITS * `ISSUE_WIDTH; idx++)begin
            initial begin
                uvm_config_db #(virtual VX_dispatch_if                  )::set(null, "*", $sformatf("dispatch_if[%0d]",idx) , core.dispatch_if[idx]);
                uvm_config_db #(virtual VX_commit_if                    )::set(null, "*", $sformatf("commit_if[%0d]",idx), core.commit_if[idx]);
            end
        end
        
    endgenerate

    //Run Test 
    initial begin
        $display("TB_TOP running at time %0t", $time);   
        
        run_test();
        $dumpvars(0, VX_tb_top);
        $display("TB_TOP finished at time %0t", $time);
        $finish();
    end

endmodule

