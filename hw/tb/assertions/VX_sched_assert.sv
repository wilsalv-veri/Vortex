module VX_sched_assert( input logic                                   clk,
                        VX_warp_ctl_if.slave                          warp_ctl_if,
                        input logic                                   is_single_warp,
                        input logic [`NUM_WARPS-1:0]                  active_warps,
                        input logic [`NUM_WARPS-1:0]                  stalled_warps,
                        input logic [`NUM_WARPS-1:0][PC_BITS-1:0]     warp_pcs,
                        input logic [`NUM_BARRIERS-1:0][NW_WIDTH-1:0] barrier_ctrs_n
                        );

    logic [PC_BITS-1:0]   max_warp_pc = 0;
    logic [NB_WIDTH-1:0]  bar_id;

    always @(posedge clk)begin
        for(int warp_idx=0; warp_idx < `NUM_WARPS; warp_idx++)begin
            if (max_warp_pc < warp_pcs[warp_idx])
                max_warp_pc <= warp_pcs[warp_idx];
        end

        if (warp_ctl_if.valid & warp_ctl_if.barrier.valid)
            bar_id <=  warp_ctl_if.barrier.id;
    end

    sequence barrier_valid;
        ($rose(warp_ctl_if.valid) & warp_ctl_if.barrier.valid);
    endsequence

    property check_bar_pc (logic [NB_WIDTH-1:0]  bar_id, 
                           logic [NW_WIDTH-1:0]  wid);
        
        barrier_valid |-> (warp_pcs[wid] <= max_warp_pc) until ($fell(barrier_ctrs_n[bar_id]));
        
    endproperty

    property check_bar_counter (logic [NB_WIDTH-1:0]  bar_id, 
                                logic [NW_WIDTH-1:0]  wid);
                            

        barrier_valid |->  $changed(barrier_ctrs_n[bar_id])[= 1:`NUM_WARPS - 1]  ##[0:$]  $fell(barrier_ctrs_n[bar_id]);
    endproperty

    property check_warp_unlocked (logic [NW_WIDTH-1:0]  wid);
        $rose(stalled_warps[wid]) |-> s_eventually $fell(stalled_warps[wid]);
    endproperty

    wspawn_only_on_single_warp: assert property( @ (posedge clk) ($rose(warp_ctl_if.valid) & warp_ctl_if.wspawn.valid)  |->  is_single_warp  until $changed(active_warps) ) else `VX_sva_error("Warp Spawned When Multiple Warps Already Active"); 
            
    for(genvar wid=0; wid < `NUM_WARPS; wid++)begin
        wait_for_all_warps_on_bar:  assert property( @ (posedge clk) check_bar_pc(bar_id, wid) ) else `VX_sva_error("BARRIER Violated");
        wait_for_bar_cntr_to_reset: assert property( @ (posedge clk) check_bar_counter(bar_id, wid)) else `VX_sva_error($sformatf("BARRIER Counter Did Not Reset for BarID%0d", bar_id));
        all_warps_unlocked:         assert property( @ (posedge clk) check_warp_unlocked(wid)) else `VX_sva_error($sformatf("WARP %0d Is Locked Forever", wid));
    end
        
endmodule