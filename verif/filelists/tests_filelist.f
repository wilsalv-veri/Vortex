//Include Files under $VORTEX/tests
+incdir+$VORTEX/tests

//Include Files under $VORTEX/tests/base_tests
+incdir+$VORTEX/tests/base_tests

$VORTEX/tests/base_tests/VX_risc_v_base_test.sv
$VORTEX/tests/base_tests/VX_risc_v_base_instr_seq_test.sv
$VORTEX/tests/base_tests/VX_risc_v_base_seq_lib_test.sv

//Include Files under $VORTEX/tests/data_hazard_tests
+incdir+$VORTEX/tests/data_hazard_tests

$VORTEX/tests/data_hazard_tests/VX_data_hazard_rtg_test.sv
$VORTEX/tests/data_hazard_tests/VX_data_hazard_base_test.sv

//Include Files under $VORTEX/tests/execute_tests
+incdir+$VORTEX/tests/execute_tests

$VORTEX/tests/execute_tests/VX_arithmetic_imm_doa_test.sv
$VORTEX/tests/execute_tests/VX_vote_doa_test.sv
$VORTEX/tests/execute_tests/VX_arithmetic_rtg_test.sv
$VORTEX/tests/execute_tests/VX_fence_doa_test.sv
$VORTEX/tests/execute_tests/VX_arithmetic_imm_rtg_test.sv
$VORTEX/tests/execute_tests/VX_arithmetic_imm_simd_test.sv
$VORTEX/tests/execute_tests/VX_vote_rtg_test.sv
$VORTEX/tests/execute_tests/VX_arithmetic_simd_test.sv
$VORTEX/tests/execute_tests/VX_shfl_doa_test.sv
$VORTEX/tests/execute_tests/VX_store_imm_doa_test.sv
$VORTEX/tests/execute_tests/VX_load_imm_doa_test.sv
$VORTEX/tests/execute_tests/VX_arithmetic_doa_test.sv
$VORTEX/tests/execute_tests/VX_store_imm_rtg_test.sv
$VORTEX/tests/execute_tests/VX_shfl_rtg_test.sv
$VORTEX/tests/execute_tests/VX_load_imm_rtg_test.sv

//Include Files under $VORTEX/tests/warp_ctl_tests
+incdir+$VORTEX/tests/warp_ctl_tests

$VORTEX/tests/warp_ctl_tests/VX_wspawn_doa_test.sv
$VORTEX/tests/warp_ctl_tests/VX_read_from_empty_ipdom_stack_test.sv
$VORTEX/tests/warp_ctl_tests/VX_wspawn_twice_test.sv
$VORTEX/tests/warp_ctl_tests/VX_branch_doa_test.sv
$VORTEX/tests/warp_ctl_tests/VX_non_dvg_join_test.sv
$VORTEX/tests/warp_ctl_tests/VX_pred_doa_test.sv
$VORTEX/tests/warp_ctl_tests/VX_split_join_test.sv
$VORTEX/tests/warp_ctl_tests/VX_write_to_full_ipdom_stack_test.sv
$VORTEX/tests/warp_ctl_tests/VX_tmc_test.sv
$VORTEX/tests/warp_ctl_tests/VX_bar_test.sv
$VORTEX/tests/warp_ctl_tests/VX_wspawn_test.sv
$VORTEX/tests/warp_ctl_tests/VX_tmc_doa_test.sv
$VORTEX/tests/warp_ctl_tests/VX_pred_test.sv
$VORTEX/tests/warp_ctl_tests/VX_full_ipdom_stack_test.sv
$VORTEX/tests/warp_ctl_tests/VX_split_join_doa_test.sv
$VORTEX/tests/warp_ctl_tests/VX_branch_test.sv
$VORTEX/tests/warp_ctl_tests/VX_bar_doa_test.sv

