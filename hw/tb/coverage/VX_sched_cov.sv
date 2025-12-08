module VX_sched_cov(input logic                                         clk,
                    input logic                                         reset,
                    input logic                                         sched_busy,
                    input logic [NW_WIDTH-1:0]                          wid,

                    input logic                                         warp_ctl_valid,
                    input logic                                         tmc_valid,
                    input logic                                         wspawn_valid,
                    input logic                                         bar_valid,
                    input logic                                         split_valid,

                    input logic                                         join_valid,
                    input logic                                         join_is_dvg,
                    input logic                                         join_is_else,
   
                    input logic                                         ipdom_push,
                    input logic                                         ipdom_pop,
                    input logic [DV_STACK_SIZEW-1:0][`NUM_WARPS-1:0]    ipdom_wr_ptrs, 

                    input logic [`NUM_WARPS-1:0][`NUM_THREADS-1:0]      thread_masks,
                    input logic [`NUM_WARPS-1:0]                        active_warps,
                    input logic [`NUM_WARPS-1:0]                        stalled_warps,
                    input logic                                         is_single_warp,

                    input logic                                         br_valid,
                    input logic                                         br_taken,
                    input logic [NW_WIDTH-1:0]                          br_wid
                    );

                        
    covergroup warp_ctl_cg @(posedge clk);
        option.per_instance = 1;

        coverpoint reset;
        coverpoint sched_busy;

        coverpoint wid{
            bins wid_num            = {[0:`NUM_WARPS-1]};
        }
        coverpoint is_single_warp;
   
        coverpoint thread_masks {
            bins no_thread_active   = {0};
            bins all_threads_active = {`NUM_THREADS'hf};
        }

        coverpoint active_warps {
            bins no_warp_active     = {0};
            bins all_warps_active   = {`NUM_WARPS'hf};
        }

        coverpoint stalled_warps {
            bins no_stalled_warp    = {0};
            bins all_warps_stalled  = {`NUM_WARPS'hf};
        }

        coverpoint warp_ctl_valid{
            bins warp_ctl_not_valid = {0};
            bins warp_ctl_assert    = {1};
        }

        coverpoint tmc_valid{
            bins tmc_not_valid      = {0};
            bins tmc_assert         = {1};
        }
        
        coverpoint wspawn_valid{
            bins wspawn_not_valid   = {0};
            bins wspawn_assert      = {1};
        }
        
        coverpoint split_valid{
            bins split_not_valid    = {0};
            bins split_assert       = {1};
        }
        
        coverpoint join_valid{
            bins join_not_valid     = {0};
            bins join_assert        = {1};
        }

        coverpoint join_is_dvg{
            bins non_dvg            = {0};
            bins dvg                = {1};
        }

        coverpoint join_is_else{
            bins postdom_join       = {0};
            bins else_join          = {1}; 

        }
        
        coverpoint bar_valid{
            bins bar_not_valid      = {0};
            bins bar_assert         = {1};
        }
   
        coverpoint br_valid{
            bins br_not_valid       = {0};
            bins br_assert          = {1};
        }
        coverpoint br_wid{
            bins wid                = {[0:`NUM_WARPS-1]};
        }
        coverpoint br_taken{
            bins not_taken          = {0};
            bins taken              = {1};
        }
          
        coverpoint ipdom_wr_ptrs{
            bins ipdom_stack_full   = {`NUM_WARPS - 1};
            bins ipdom_stack_empty  = {0}; 
        }

        coverpoint ipdom_push;
        coverpoint ipdom_pop;

        branch_cross : cross br_valid, br_wid, br_taken;
        
        warp_ctl_w_tmc: cross warp_ctl_valid, tmc_valid{
            ignore_bins warp_ctl_not_valid = binsof (warp_ctl_valid) intersect {0};
        }

        warp_ctl_w_split: cross warp_ctl_valid, split_valid{
            ignore_bins warp_ctl_not_valid = binsof (warp_ctl_valid) intersect {0};
        }

        warp_ctl_w_join: cross warp_ctl_valid, join_valid{
            ignore_bins warp_ctl_not_valid = binsof (warp_ctl_valid) intersect {0};
        }

        warp_ctl_w_wspawn : cross warp_ctl_valid, wspawn_valid{
            ignore_bins warp_ctl_not_valid = binsof (warp_ctl_valid) intersect {0};
        }

        warp_ctl_w_bar : cross warp_ctl_valid, bar_valid{
            ignore_bins warp_ctl_not_valid = binsof (warp_ctl_valid) intersect {0};
        }

    endgroup

    warp_ctl_cg warp_cg = new();
    
endmodule
