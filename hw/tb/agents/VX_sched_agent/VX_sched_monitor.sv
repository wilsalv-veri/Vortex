class VX_sched_monitor extends uvm_monitor;
    
    `uvm_component_utils(VX_sched_monitor)

    string message_id = "VX_SCHED_MONITOR";
    uvm_analysis_port #(VX_sched_tb_txn_item) sched_info_analysis_port[`SOCKET_SIZE];

    VX_sched_tb_txn_item                      sched_info[`SOCKET_SIZE];
    virtual VX_sched_tb_if                    sched_tb_if[`SOCKET_SIZE];
    virtual VX_warp_ctl_if                    warp_ctl_if[`SOCKET_SIZE];
    
    function new(string name="VX_sched_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        for(int core_id=0; core_id < `SOCKET_SIZE; core_id++)begin
      
            sched_info_analysis_port[core_id] = new($sformatf("core[%0d].SCHED_INFO_ANALYSIS_PORT", core_id), this);
            sched_info[core_id] = VX_sched_tb_txn_item::type_id::create($sformatf("core[%0d].SCHED_INFO", core_id), this);

            if(!uvm_config_db #(virtual VX_sched_tb_if)::get(this, "", $sformatf("core[%0d].sched_tb_if", core_id),sched_tb_if[core_id]))
                `VX_error(message_id, $sformatf("Failed to get access to core[%0d].sched_tb_if", core_id))

            if(!uvm_config_db #(virtual VX_warp_ctl_if)::get(this, "", $sformatf("core[%0d].warp_ctl_if", core_id), warp_ctl_if[core_id]))
                `VX_error(message_id, $sformatf("Failed to get access to core[%0d].warp_ctl_if", core_id))
        
        end

    endfunction

    virtual task run_phase(uvm_phase phase);
        
        for(int id=0; id < `SOCKET_SIZE; id++)begin
            automatic int core_id = id;
            fork 
                //Scoreboard
                get_warp_ctl_info(core_id);
                get_wspawn_info(core_id);
                get_join_info(core_id);
                get_branch_info(core_id);
            join_none
        end
    endtask

    virtual task get_warp_ctl_info(int core_id);
        forever @ (sched_tb_if[core_id].wctl_cb)begin
            //Capture the info from IFC
            if (!sched_tb_if[core_id].wctl_cb.reset && sched_tb_if[core_id].wctl_cb.warp_ctl_valid)begin
                sched_info[core_id].core_id       = core_id;
                sched_info[core_id].active_warps  = sched_tb_if[core_id].wctl_cb.active_warps;
                sched_info[core_id].stalled_warps = sched_tb_if[core_id].wctl_cb.stalled_warps;
                sched_info[core_id].thread_masks  = sched_tb_if[core_id].wctl_cb.thread_masks;
                sched_info[core_id].result_pc     = sched_tb_if[core_id].wctl_cb.result_pc;
                sched_info[core_id].wid           = sched_tb_if[core_id].wctl_cb.wid;
                sched_info[core_id].last_tid      = sched_tb_if[core_id].wctl_cb.last_tid;
                sched_info[core_id].wspawn_valid  = 1'b0;
                sched_info[core_id].join_valid    = 1'b0;
                sched_info[core_id].br_valid      = 1'b0;
                sched_info[core_id].sched_info_valid = 1'b1;

                //Send Info to scoreboard
                sched_info_analysis_port[core_id].write(sched_info[core_id]);
            end
        end
    endtask

    virtual task get_wspawn_info(int core_id);
        forever @ (sched_tb_if[core_id].wspawn_cb)begin
            if(sched_tb_if[core_id].wspawn_cb.wspawn_valid)begin
                sched_info[core_id].core_id       = core_id;
                sched_info[core_id].active_warps  = sched_tb_if[core_id].wspawn_cb.active_warps;
                sched_info[core_id].warp_pcs      = sched_tb_if[core_id].wspawn_cb.warp_pcs;
                sched_info[core_id].curr_single_warp = sched_tb_if[core_id].wspawn_cb.curr_single_warp;
                sched_info[core_id].wspawn_valid  = 1'b1;
                sched_info[core_id].join_valid    = 1'b0;
                sched_info[core_id].br_valid      = 1'b0;
                sched_info[core_id].sched_info_valid = 1'b1;
                sched_info_analysis_port[core_id].write(sched_info[core_id]);
            end
        end
    endtask

    virtual task get_join_info(int core_id);
        forever  @ (sched_tb_if[core_id].join_cb)begin
            if (sched_tb_if[core_id].join_cb.join_valid) begin
                sched_info[core_id].core_id       = core_id;
                sched_info[core_id].thread_masks  = sched_tb_if[core_id].join_cb.thread_masks;
                sched_info[core_id].result_pc     = sched_tb_if[core_id].join_cb.result_pc;
                sched_info[core_id].ipdom_wr_ptrs = sched_tb_if[core_id].join_cb.ipdom_wr_ptrs;
                sched_info[core_id].wspawn_valid  = 1'b0;
                sched_info[core_id].join_valid    = 1'b1;
                sched_info[core_id].br_valid      = 1'b0;
                sched_info_analysis_port[core_id].write(sched_info[core_id]);
            end
        end
    endtask

    virtual task get_branch_info(int core_id);
        forever @(sched_tb_if[core_id].branch_cb)begin
            if(sched_tb_if[core_id].branch_cb.br_valid)begin
                sched_info[core_id].core_id       = core_id;
                sched_info[core_id].br_wid = sched_tb_if[core_id].branch_cb.br_wid; 
                sched_info[core_id].warp_pcs      = sched_tb_if[core_id].branch_cb.warp_pcs;
            
                sched_info[core_id].br_taken = sched_tb_if[core_id].branch_cb.br_taken; 
                sched_info[core_id].br_target = sched_tb_if[core_id].branch_cb.br_target;
                sched_info[core_id].br_pc     = sched_tb_if[core_id].branch_cb.br_pc; 
                sched_info[core_id].wspawn_valid  = 1'b0;
                sched_info[core_id].join_valid    = 1'b0;
                sched_info[core_id].br_valid      = 1'b1; 
                sched_info_analysis_port[core_id].write(sched_info[core_id]);
            end
        end
    endtask

endclass