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

$VORTEX/hw/tb/seqs/VX_risc_v_base_seq.sv
$VORTEX/hw/tb/seqs/VX_risc_v_base_instr_seq.sv
$VORTEX/hw/tb/seqs/VX_risc_v_base_data_seq.sv

//Include Files under $VORTEX/hw/tb/tests
+incdir+$VORTEX/hw/tb/tests

$VORTEX/hw/tb/tests/VX_risc_v_base_test.sv
$VORTEX/hw/tb/tests/VX_risc_v_base_instr_seq_test.sv

$VORTEX/hw/tb/tb_top.sv

