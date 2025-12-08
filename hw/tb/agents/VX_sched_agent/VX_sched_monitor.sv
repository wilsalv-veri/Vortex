class VX_sched_monitor extends uvm_monitor;
    
    `uvm_component_utils(VX_sched_monitor)

    uvm_analysis_port #(VX_sched_tb_txn_item) sched_info_analysis_port;

    VX_sched_tb_txn_item                      sched_info;
    virtual VX_sched_tb_if                    sched_tb_if;
  
    function new(string name="VX_sched_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sched_info_analysis_port = new("SCHED_INFO_ANALYSIS_PORT", this);
        sched_info = VX_sched_tb_txn_item::type_id::create("SCHED_INFO", this);

        if(!uvm_config_db #(virtual VX_sched_tb_if)::get(this, "", "sched_tb_if", sched_tb_if))
            `VX_error("VX_SCHED_MONITOR","Failed to get access to VX_sched_tb_if")

        if(!uvm_config_db #(virtual VX_warp_ctl_if)::get(this, "", "warp_ctl_if", warp_ctl_if))
            `VX_error("VX_SCHED_MONITOR", "Failed to get access to warp_ctl_if")
    
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork 
            //Scoreboard
            get_warp_ctl_info();
            get_wspawn_info();
            get_join_info();
            get_branch_info();
        join_none
    endtask

    virtual task get_warp_ctl_info();
        forever @ (sched_tb_if.wctl_cb)begin
            //Capture the info from IFC
            if (!sched_tb_if.wctl_cb.reset && sched_tb_if.wctl_cb.warp_ctl_valid)begin
            
                sched_info.active_warps  = sched_tb_if.wctl_cb.active_warps;
                sched_info.stalled_warps = sched_tb_if.wctl_cb.stalled_warps;
                sched_info.thread_masks  = sched_tb_if.wctl_cb.thread_masks;
                sched_info.result_pc     = sched_tb_if.wctl_cb.result_pc;
                sched_info.wid           = sched_tb_if.wctl_cb.wid;
                sched_info.last_tid      = sched_tb_if.wctl_cb.last_tid;
                sched_info.wspawn_valid  = 1'b0;
                sched_info.join_valid    = 1'b0;
                sched_info.br_valid      = 1'b0;
                sched_info.sched_info_valid = 1'b1;

                //Send Info to scoreboard
                sched_info_analysis_port.write(sched_info);
            end
        end
    endtask

    virtual task get_wspawn_info();
        forever @ (sched_tb_if.wspawn_cb)begin
            if(sched_tb_if.wspawn_cb.wspawn_valid)begin
                sched_info.active_warps  = sched_tb_if.wspawn_cb.active_warps;
                sched_info.warp_pcs      = sched_tb_if.wspawn_cb.warp_pcs;
                sched_info.curr_single_warp = sched_tb_if.wspawn_cb.curr_single_warp;
                sched_info.wspawn_valid  = 1'b1;
                sched_info.join_valid    = 1'b0;
                sched_info.br_valid      = 1'b0;
                sched_info.sched_info_valid = 1'b1;
                sched_info_analysis_port.write(sched_info);
            end
        end
    endtask

    virtual task get_join_info();
        forever  @ (sched_tb_if.join_cb)begin
            if (sched_tb_if.join_cb.join_valid) begin
                sched_info.thread_masks  = sched_tb_if.join_cb.thread_masks;
                sched_info.result_pc     = sched_tb_if.join_cb.result_pc;
                sched_info.ipdom_wr_ptrs = sched_tb_if.join_cb.ipdom_wr_ptrs;
                sched_info.wspawn_valid  = 1'b0;
                sched_info.join_valid    = 1'b1;
                sched_info.br_valid      = 1'b0;
                sched_info_analysis_port.write(sched_info);
            end
        end
    endtask

    virtual task get_branch_info();
        forever @(sched_tb_if.branch_cb)begin
            if(sched_tb_if.branch_cb.br_valid)begin
                sched_info.br_wid = sched_tb_if.branch_cb.br_wid; 
                sched_info.warp_pcs      = sched_tb_if.branch_cb.warp_pcs;
            
                sched_info.br_taken = sched_tb_if.branch_cb.br_taken; 
                sched_info.br_target = sched_tb_if.branch_cb.br_target;
                sched_info.br_pc     = sched_tb_if.branch_cb.br_pc; 
                sched_info.wspawn_valid  = 1'b0;
                sched_info.join_valid    = 1'b0;
                sched_info.br_valid      = 1'b1; 
                sched_info_analysis_port.write(sched_info);
            end
        end
    endtask

endclass