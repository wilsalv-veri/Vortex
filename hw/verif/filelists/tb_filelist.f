//Include Files under $VORTEX/hw/tb
+incdir+$VORTEX/hw/tb

$VORTEX/hw/tb/VX_tb_top_pkg.sv
//Include Files under $VORTEX/hw/tb/packages
+incdir+$VORTEX/hw/tb/packages

$VORTEX/hw/tb/packages/VX_tb_common_pkg.sv
$VORTEX/hw/tb/packages/VX_gpr_pkg.sv
$VORTEX/hw/tb/packages/VX_sched_pkg.sv

//Include Files under $VORTEX/hw/tb/common
+incdir+$VORTEX/hw/tb/common

$VORTEX/hw/tb/common/VX_tb_environment.sv
//Include Files under $VORTEX/hw/tb/common/transaction_items
+incdir+$VORTEX/hw/tb/common/transaction_items


//Include Files under $VORTEX/hw/tb/common/seq_items
+incdir+$VORTEX/hw/tb/common/seq_items



//Include Files under $VORTEX/hw/tb/interfaces
+incdir+$VORTEX/hw/tb/interfaces

$VORTEX/hw/tb/interfaces/VX_gpr_tb_if.sv
$VORTEX/hw/tb/interfaces/VX_risc_v_inst_if.sv
$VORTEX/hw/tb/interfaces/VX_mem_load_if.sv
$VORTEX/hw/tb/interfaces/VX_tb_top_if.sv
$VORTEX/hw/tb/interfaces/VX_execute_tb_if.sv
$VORTEX/hw/tb/interfaces/VX_sched_tb_if.sv
//Include Files under $VORTEX/hw/tb/interfaces/interface_connections
+incdir+$VORTEX/hw/tb/interfaces/interface_connections



//Include Files under $VORTEX/hw/tb/memory_model
+incdir+$VORTEX/hw/tb/memory_model

$VORTEX/hw/tb/memory_model/memory_loader.sv
$VORTEX/hw/tb/memory_model/memory_bfm.sv

//Include Files under $VORTEX/hw/tb/agents
+incdir+$VORTEX/hw/tb/agents

//Include Files under $VORTEX/hw/tb/agents/VX_risc_v_agent
+incdir+$VORTEX/hw/tb/agents/VX_risc_v_agent


//Include Files under $VORTEX/hw/tb/agents/VX_sched_agent
+incdir+$VORTEX/hw/tb/agents/VX_sched_agent


//Include Files under $VORTEX/hw/tb/agents/VX_execute_agent
+incdir+$VORTEX/hw/tb/agents/VX_execute_agent


//Include Files under $VORTEX/hw/tb/agents/VX_gpr_agent
+incdir+$VORTEX/hw/tb/agents/VX_gpr_agent



//Include Files under $VORTEX/hw/tb/scoreboards
+incdir+$VORTEX/hw/tb/scoreboards


//Include Files under $VORTEX/hw/tb/seqs
+incdir+$VORTEX/hw/tb/seqs

//Include Files under $VORTEX/hw/tb/seqs/base_seqs
+incdir+$VORTEX/hw/tb/seqs/base_seqs


//Include Files under $VORTEX/hw/tb/seqs/warp_ctl_seqs
+incdir+$VORTEX/hw/tb/seqs/warp_ctl_seqs

$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_wspawn_doa_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_tmc_doa_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_pred_doa_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_split_join_doa_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_bar_doa_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_pred_rtg_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_tmc_rtg_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_bar_rtg_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_wspawn_rtg_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_split_join_rtg_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_bar_doa_seq_lib.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_wspawn_doa_seq_lib.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_wspawn_seq_lib.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_bar_seq_lib.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_wspawn_twice_seq_lib.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_full_ipdom_stack_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_write_to_full_ipdom_stack_seq.sv
$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_non_dvg_join_seq.sv


//Include Files under $VORTEX/hw/tb/tests
+incdir+$VORTEX/hw/tb/tests

//Include Files under $VORTEX/hw/tb/tests/base_tests
+incdir+$VORTEX/hw/tb/tests/base_tests

$VORTEX/hw/tb/tests/base_tests/VX_risc_v_base_test.sv
$VORTEX/hw/tb/tests/base_tests/VX_risc_v_base_instr_seq_test.sv
$VORTEX/hw/tb/tests/base_tests/VX_risc_v_base_seq_lib_test.sv

//Include Files under $VORTEX/hw/tb/tests/warp_ctl_tests
+incdir+$VORTEX/hw/tb/tests/warp_ctl_tests

$VORTEX/hw/tb/tests/warp_ctl_tests/VX_wspawn_doa_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_wspawn_twice_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_non_dvg_join_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_pred_doa_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_split_join_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_write_to_full_ipdom_stack_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_tmc_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_bar_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_wspawn_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_tmc_doa_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_pred_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_full_ipdom_stack_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_split_join_doa_test.sv
$VORTEX/hw/tb/tests/warp_ctl_tests/VX_bar_doa_test.sv

$VORTEX/hw/tb/tb_top.sv

