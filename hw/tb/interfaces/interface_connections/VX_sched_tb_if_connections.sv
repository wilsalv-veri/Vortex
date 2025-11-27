assign sched_tb_if.clk            =  `VX_CORE.clk;
assign sched_tb_if.reset          =  `VX_CORE.reset;
assign sched_tb_if.warp_ctl_valid =  `VX_EXECUTE.warp_ctl_if.valid;
assign sched_tb_if.wspawn_valid   =  `VX_SCHED.wspawn.valid;
assign sched_tb_if.last_tid       =  `VX_EXECUTE.sfu_unit.wctl_unit.last_tid;
assign sched_tb_if.wid            =  `VX_EXECUTE.warp_ctl_if.wid;
assign sched_tb_if.result_pc      =  `VX_EXECUTE.sfu_unit.pe_result_if[0].data.PC;
assign sched_tb_if.active_warps   =  `VX_SCHED.active_warps_n;
assign sched_tb_if.stalled_warps  =  `VX_SCHED.stalled_warps_n;
assign sched_tb_if.thread_masks   =  `VX_SCHED.thread_masks_n;
assign sched_tb_if.warp_pcs       =  `VX_SCHED.warp_pcs_n;

