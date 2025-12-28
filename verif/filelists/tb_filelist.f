//Include Files under $VORTEX/tb
+incdir+$VORTEX/tb

$VORTEX/tb/VX_tb_top_pkg.sv
//Include Files under $VORTEX/tb/packages
+incdir+$VORTEX/tb/packages

$VORTEX/tb/packages/VX_tb_common_pkg.sv
$VORTEX/tb/packages/VX_gpr_pkg.sv
$VORTEX/tb/packages/VX_sched_pkg.sv
$VORTEX/tb/packages/VX_execute_pkg.sv
$VORTEX/tb/packages/VX_issue_pkg.sv

//Include Files under $VORTEX/tb/common
+incdir+$VORTEX/tb/common

$VORTEX/tb/common/VX_tb_environment.sv
//Include Files under $VORTEX/tb/common/transaction_items
+incdir+$VORTEX/tb/common/transaction_items


//Include Files under $VORTEX/tb/common/seq_items
+incdir+$VORTEX/tb/common/seq_items



//Include Files under $VORTEX/tb/interfaces
+incdir+$VORTEX/tb/interfaces

$VORTEX/tb/interfaces/VX_gpr_tb_if.sv
$VORTEX/tb/interfaces/VX_risc_v_inst_if.sv
$VORTEX/tb/interfaces/VX_mem_load_if.sv
$VORTEX/tb/interfaces/VX_tb_top_if.sv
$VORTEX/tb/interfaces/VX_sched_tb_if.sv
//Include Files under $VORTEX/tb/interfaces/interface_connections
+incdir+$VORTEX/tb/interfaces/interface_connections



//Include Files under $VORTEX/tb/memory_model
+incdir+$VORTEX/tb/memory_model

$VORTEX/tb/memory_model/memory_loader.sv
$VORTEX/tb/memory_model/memory_bfm.sv

//Include Files under $VORTEX/tb/agents
+incdir+$VORTEX/tb/agents

//Include Files under $VORTEX/tb/agents/VX_risc_v_agent
+incdir+$VORTEX/tb/agents/VX_risc_v_agent


//Include Files under $VORTEX/tb/agents/VX_sched_agent
+incdir+$VORTEX/tb/agents/VX_sched_agent


//Include Files under $VORTEX/tb/agents/VX_issue_agent
+incdir+$VORTEX/tb/agents/VX_issue_agent


//Include Files under $VORTEX/tb/agents/VX_execute_agent
+incdir+$VORTEX/tb/agents/VX_execute_agent


//Include Files under $VORTEX/tb/agents/VX_gpr_agent
+incdir+$VORTEX/tb/agents/VX_gpr_agent



//Include Files under $VORTEX/tb/scoreboards
+incdir+$VORTEX/tb/scoreboards


//Include Files under $VORTEX/tb/seqs
+incdir+$VORTEX/tb/seqs

//Include Files under $VORTEX/tb/seqs/warp_ctl_seqs
+incdir+$VORTEX/tb/seqs/warp_ctl_seqs

$VORTEX/tb/seqs/warp_ctl_seqs/VX_wspawn_doa_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_branch_doa_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_tmc_doa_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_pred_doa_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_split_join_doa_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_bar_doa_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_branch_rtg_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_pred_rtg_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_tmc_rtg_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_bar_rtg_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_wspawn_rtg_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_split_join_rtg_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_bar_doa_seq_lib.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_wspawn_doa_seq_lib.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_wspawn_seq_lib.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_bar_seq_lib.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_wspawn_twice_seq_lib.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_tmc_no_end_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_read_from_empty_ipdom_stack_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_full_ipdom_stack_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_write_to_full_ipdom_stack_seq.sv
$VORTEX/tb/seqs/warp_ctl_seqs/VX_non_dvg_join_seq.sv

//Include Files under $VORTEX/tb/seqs/execute_seqs
+incdir+$VORTEX/tb/seqs/execute_seqs

$VORTEX/tb/seqs/execute_seqs/VX_arithmetic_doa_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_store_imm_doa_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_vote_doa_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_shfl_doa_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_arithmetic_imm_doa_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_fence_doa_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_load_imm_doa_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_shfl_rtg_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_store_imm_rtg_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_vote_rtg_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_arithmetic_rtg_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_arithmetic_imm_rtg_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_load_imm_rtg_seq.sv
$VORTEX/tb/seqs/execute_seqs/VX_load_imm_doa_seq_lib.sv
$VORTEX/tb/seqs/execute_seqs/VX_store_imm_doa_seq_lib.sv
$VORTEX/tb/seqs/execute_seqs/VX_fence_doa_seq_lib.sv
$VORTEX/tb/seqs/execute_seqs/VX_store_imm_rtg_seq_lib.sv
$VORTEX/tb/seqs/execute_seqs/VX_arithmetic_seq_lib.sv
$VORTEX/tb/seqs/execute_seqs/VX_arithmetic_imm_seq_lib.sv
$VORTEX/tb/seqs/execute_seqs/VX_load_imm_rtg_seq_lib.sv

//Include Files under $VORTEX/tb/seqs/data_seqs
+incdir+$VORTEX/tb/seqs/data_seqs

$VORTEX/tb/seqs/data_seqs/VX_shifted_data_seq.sv

//Include Files under $VORTEX/tb/seqs/base_seqs
+incdir+$VORTEX/tb/seqs/base_seqs


//Include Files under $VORTEX/tb/seqs/data_hazard_seqs
+incdir+$VORTEX/tb/seqs/data_hazard_seqs

$VORTEX/tb/seqs/data_hazard_seqs/VX_data_hazard_base_seq.sv
$VORTEX/tb/seqs/data_hazard_seqs/VX_data_hazard_rtg_seq.sv


//Include Files under $VORTEX/tb/coverage
+incdir+$VORTEX/tb/coverage

$VORTEX/tb/coverage/VX_execute_cov.sv
$VORTEX/tb/coverage/VX_issue_cov.sv
$VORTEX/tb/coverage/VX_sched_cov.sv

//Include Files under $VORTEX/tb/assertions
+incdir+$VORTEX/tb/assertions

$VORTEX/tb/assertions/VX_sched_assert.sv
$VORTEX/tb/assertions/VX_issue_assert.sv
$VORTEX/tb/assertions/VX_execute_assert_.sv
$VORTEX/tb/tb_top.sv

