//Include Files under $VORTEX/hw/tb
+incdir+$VORTEX/hw/tb

$VORTEX/hw/tb/VX_tb_top_pkg.sv
//Include Files under $VORTEX/hw/tb/common
+incdir+$VORTEX/hw/tb/common

$VORTEX/hw/tb/common/VX_tb_common_pkg.sv
//Include Files under $VORTEX/hw/tb/common/seq_items
+incdir+$VORTEX/hw/tb/common/seq_items



//Include Files under $VORTEX/hw/tb/interfaces
+incdir+$VORTEX/hw/tb/interfaces

$VORTEX/hw/tb/interfaces/VX_risc_v_inst_if.sv
$VORTEX/hw/tb/interfaces/VX_mem_load_if.sv
$VORTEX/hw/tb/interfaces/VX_tb_top_if.sv

//Include Files under $VORTEX/hw/tb/memory_model
+incdir+$VORTEX/hw/tb/memory_model

$VORTEX/hw/tb/memory_model/memory_loader.sv
$VORTEX/hw/tb/memory_model/memory_bfm.sv

//Include Files under $VORTEX/hw/tb/agents
+incdir+$VORTEX/hw/tb/agents

//Include Files under $VORTEX/hw/tb/agents/VX_risc_v_agent
+incdir+$VORTEX/hw/tb/agents/VX_risc_v_agent



//Include Files under $VORTEX/hw/tb/seqs
+incdir+$VORTEX/hw/tb/seqs

//Include Files under $VORTEX/hw/tb/seqs/base_seqs
+incdir+$VORTEX/hw/tb/seqs/base_seqs


//Include Files under $VORTEX/hw/tb/seqs/warp_ctl_seqs
+incdir+$VORTEX/hw/tb/seqs/warp_ctl_seqs

$VORTEX/hw/tb/seqs/warp_ctl_seqs/VX_tmc_doa_seq.sv


//Include Files under $VORTEX/hw/tb/tests
+incdir+$VORTEX/hw/tb/tests

//Include Files under $VORTEX/hw/tb/tests/base_tests
+incdir+$VORTEX/hw/tb/tests/base_tests

$VORTEX/hw/tb/tests/base_tests/VX_risc_v_base_test.sv
$VORTEX/hw/tb/tests/base_tests/VX_risc_v_base_instr_seq_test.sv

//Include Files under $VORTEX/hw/tb/tests/warp_ctl_tests
+incdir+$VORTEX/hw/tb/tests/warp_ctl_tests

$VORTEX/hw/tb/tests/warp_ctl_tests/VX_tmc_doa_test.sv


$VORTEX/hw/tb/tb_top.sv

