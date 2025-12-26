assign sched_tb_if[core_id].clk            =  `VX_CORE(core_id).clk;
assign sched_tb_if[core_id].reset          =  `VX_CORE(core_id).reset;
assign sched_tb_if[core_id].warp_ctl_valid =  `VX_EXECUTE(core_id).warp_ctl_if.valid;
assign sched_tb_if[core_id].wspawn_valid   =  `VX_SCHED(core_id).wspawn.valid;
assign sched_tb_if[core_id].join_valid     =  `VX_SCHED(core_id).join_valid;
assign sched_tb_if[core_id].ipdom_wr_ptrs  =  `VX_SCHED(core_id).split_join.g_enable.ipdom_wr_ptr;
assign sched_tb_if[core_id].curr_single_warp = `VX_SCHED(core_id).is_single_warp;
assign sched_tb_if[core_id].last_tid       =  `VX_EXECUTE(core_id).sfu_unit.wctl_unit.last_tid;
assign sched_tb_if[core_id].wid            =  `VX_EXECUTE(core_id).warp_ctl_if.wid;
assign sched_tb_if[core_id].result_pc      =  `VX_EXECUTE(core_id).sfu_unit.pe_result_if[0].data.PC;
assign sched_tb_if[core_id].active_warps   =  `VX_SCHED(core_id).active_warps_n;
assign sched_tb_if[core_id].stalled_warps  =  `VX_SCHED(core_id).stalled_warps_n;
assign sched_tb_if[core_id].thread_masks   =  `VX_SCHED(core_id).thread_masks_n;
assign sched_tb_if[core_id].warp_pcs       =  `VX_SCHED(core_id).warp_pcs_n;

//Branch
assign sched_tb_if[core_id].br_valid       = `VX_SCHED(core_id).branch_valid;
assign sched_tb_if[core_id].br_wid         = `VX_SCHED(core_id).branch_wid;
assign sched_tb_if[core_id].br_pc          = `VX_EXECUTE(core_id).alu_unit.per_block_result_if[0].data.PC;
assign sched_tb_if[core_id].br_taken       = `VX_SCHED(core_id).branch_taken;
assign sched_tb_if[core_id].br_target      = `VX_SCHED(core_id).branch_dest;

//Cov-Only
assign sched_tb_if[core_id].sched_busy     = `VX_SCHED(core_id).busy;
assign sched_tb_if[core_id].tmc_valid      = `VX_CORE(core_id).warp_ctl_if.tmc.valid;
assign sched_tb_if[core_id].bar_valid      = `VX_CORE(core_id).warp_ctl_if.barrier.valid;
assign sched_tb_if[core_id].split_valid    = `VX_CORE(core_id).warp_ctl_if.split.valid;
assign sched_tb_if[core_id].ipdom_push     = `VX_SCHED(core_id).split_join.g_enable.ipdom_push;
assign sched_tb_if[core_id].ipdom_pop      = `VX_SCHED(core_id).split_join.g_enable.ipdom_pop;
