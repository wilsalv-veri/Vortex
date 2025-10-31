+incdir+$VORTEX/sim/common


+incdir+$VORTEX/hw/dpi
$VORTEX/hw/dpi/float_dpi.cpp
$VORTEX/hw/dpi/util_dpi.cpp

$VORTEX/hw/dpi/float_dpi.vh
$VORTEX/hw/dpi/util_dpi.vh



//Include Files under $VORTEX/hw/rtl
+incdir+$VORTEX/hw/rtl

$VORTEX/hw/rtl/VX_scope.vh
$VORTEX/hw/rtl/VX_types.vh
$VORTEX/hw/rtl/VX_define.vh
$VORTEX/hw/rtl/VX_platform.vh
$VORTEX/hw/rtl/VX_config.vh
$VORTEX/hw/rtl/Vortex.sv
$VORTEX/hw/rtl/VX_trace_pkg.sv
$VORTEX/hw/rtl/Vortex_axi.sv
$VORTEX/hw/rtl/VX_socket.sv
$VORTEX/hw/rtl/VX_cluster.sv
$VORTEX/hw/rtl/VX_gpu_pkg.sv

//Include Files under $VORTEX/hw/rtl/mem
+incdir+$VORTEX/hw/rtl/mem

$VORTEX/hw/rtl/mem/VX_local_mem.sv
$VORTEX/hw/rtl/mem/VX_gbar_bus_if.sv
$VORTEX/hw/rtl/mem/VX_mem_bus_if.sv
$VORTEX/hw/rtl/mem/VX_lsu_adapter.sv
$VORTEX/hw/rtl/mem/VX_lsu_mem_arb.sv
$VORTEX/hw/rtl/mem/VX_lsu_mem_if.sv
$VORTEX/hw/rtl/mem/VX_gbar_arb.sv
$VORTEX/hw/rtl/mem/VX_lmem_switch.sv
$VORTEX/hw/rtl/mem/VX_gbar_unit.sv
$VORTEX/hw/rtl/mem/VX_local_mem_top.sv
$VORTEX/hw/rtl/mem/VX_mem_arb.sv
$VORTEX/hw/rtl/mem/VX_mem_switch.sv

//Include Files under $VORTEX/hw/rtl/interfaces
+incdir+$VORTEX/hw/rtl/interfaces

$VORTEX/hw/rtl/interfaces/VX_decode_if.sv
$VORTEX/hw/rtl/interfaces/VX_commit_csr_if.sv
$VORTEX/hw/rtl/interfaces/VX_writeback_if.sv
$VORTEX/hw/rtl/interfaces/VX_operands_if.sv
$VORTEX/hw/rtl/interfaces/VX_warp_ctl_if.sv
$VORTEX/hw/rtl/interfaces/VX_decode_sched_if.sv
$VORTEX/hw/rtl/interfaces/VX_ibuffer_if.sv
$VORTEX/hw/rtl/interfaces/VX_commit_if.sv
$VORTEX/hw/rtl/interfaces/VX_result_if.sv
$VORTEX/hw/rtl/interfaces/VX_execute_if.sv
$VORTEX/hw/rtl/interfaces/VX_issue_sched_if.sv
$VORTEX/hw/rtl/interfaces/VX_fetch_if.sv
$VORTEX/hw/rtl/interfaces/VX_commit_sched_if.sv
$VORTEX/hw/rtl/interfaces/VX_dispatch_if.sv
$VORTEX/hw/rtl/interfaces/VX_fpu_csr_if.sv
$VORTEX/hw/rtl/interfaces/VX_schedule_if.sv
$VORTEX/hw/rtl/interfaces/VX_branch_ctl_if.sv
$VORTEX/hw/rtl/interfaces/VX_sched_csr_if.sv
$VORTEX/hw/rtl/interfaces/VX_scoreboard_if.sv
$VORTEX/hw/rtl/interfaces/VX_dcr_bus_if.sv

//Include Files under $VORTEX/hw/rtl/fpu
+incdir+$VORTEX/hw/rtl/fpu

$VORTEX/hw/rtl/fpu/VX_fpu_define.vh
$VORTEX/hw/rtl/fpu/VX_fpu_dpi.sv
$VORTEX/hw/rtl/fpu/VX_fpu_fpnew.sv
$VORTEX/hw/rtl/fpu/VX_fncp_unit.sv
$VORTEX/hw/rtl/fpu/VX_fp_rounding.sv
$VORTEX/hw/rtl/fpu/VX_fpu_cvt.sv
$VORTEX/hw/rtl/fpu/VX_fpu_sqrt.sv
$VORTEX/hw/rtl/fpu/VX_fpu_fma.sv
$VORTEX/hw/rtl/fpu/VX_fpu_div.sv
$VORTEX/hw/rtl/fpu/VX_fcvt_unit.sv
$VORTEX/hw/rtl/fpu/VX_fpu_ncp.sv
$VORTEX/hw/rtl/fpu/VX_fpu_dsp.sv
$VORTEX/hw/rtl/fpu/VX_fpu_pkg.sv
$VORTEX/hw/rtl/fpu/VX_fp_classifier.sv


//Include Files under $VORTEX/hw/rtl/tcu
+incdir+$VORTEX/hw/rtl/tcu

$VORTEX/hw/rtl/tcu/VX_tcu_fp.sv
$VORTEX/hw/rtl/tcu/VX_tcu_fedp_dsp.sv
$VORTEX/hw/rtl/tcu/VX_tcu_fedp_bhf.sv
$VORTEX/hw/rtl/tcu/VX_tcu_pkg.sv
$VORTEX/hw/rtl/tcu/VX_tcu_fedp_int.sv
$VORTEX/hw/rtl/tcu/VX_tcu_int.sv
$VORTEX/hw/rtl/tcu/VX_tcu_unit.sv
$VORTEX/hw/rtl/tcu/VX_tcu_uops.sv
$VORTEX/hw/rtl/tcu/VX_tcu_fedp_dpi.sv

//Include Files under $VORTEX/hw/rtl/tcu/bhf
+incdir+$VORTEX/hw/rtl/tcu/bhf

$VORTEX/hw/rtl/tcu/bhf/HardFloat_consts.vi
$VORTEX/hw/rtl/tcu/bhf/VX_tcu_bhf_fp16mul.sv
$VORTEX/hw/rtl/tcu/bhf/bsg_counting_leading_zeros.sv
$VORTEX/hw/rtl/tcu/bhf/VX_tcu_bhf_fp32add.sv
$VORTEX/hw/rtl/tcu/bhf/VX_tcu_bhf_fp8mul.sv
$VORTEX/hw/rtl/tcu/bhf/HardFloat_localFuncs.vi
$VORTEX/hw/rtl/tcu/bhf/VX_tcu_bhf_bf16mul.sv
$VORTEX/hw/rtl/tcu/bhf/VX_tcu_bhf_fp16add.sv
$VORTEX/hw/rtl/tcu/bhf/VX_tcu_bhf_tf32mul.sv

//Include Files under $VORTEX/hw/rtl/core
+incdir+$VORTEX/hw/rtl/core

$VORTEX/hw/rtl/core/VX_commit.sv
$VORTEX/hw/rtl/core/VX_core.sv
$VORTEX/hw/rtl/core/VX_mem_unit.sv
$VORTEX/hw/rtl/core/VX_fpu_unit.sv
$VORTEX/hw/rtl/core/VX_gather_unit.sv
$VORTEX/hw/rtl/core/VX_mem_unit_top.sv
$VORTEX/hw/rtl/core/VX_uuid_gen.sv
$VORTEX/hw/rtl/core/VX_csr_data.sv
$VORTEX/hw/rtl/core/VX_operands.sv
$VORTEX/hw/rtl/core/VX_issue_top.sv
$VORTEX/hw/rtl/core/VX_opc_unit.sv
$VORTEX/hw/rtl/core/VX_uop_sequencer.sv
$VORTEX/hw/rtl/core/VX_issue.sv
$VORTEX/hw/rtl/core/VX_dcr_data.sv
$VORTEX/hw/rtl/core/VX_pe_switch.sv
$VORTEX/hw/rtl/core/VX_schedule.sv
$VORTEX/hw/rtl/core/VX_core_top.sv
$VORTEX/hw/rtl/core/VX_dispatch_unit.sv
$VORTEX/hw/rtl/core/VX_split_join.sv
$VORTEX/hw/rtl/core/VX_fetch.sv
$VORTEX/hw/rtl/core/VX_scoreboard.sv
$VORTEX/hw/rtl/core/VX_ibuffer.sv
$VORTEX/hw/rtl/core/VX_alu_int.sv
$VORTEX/hw/rtl/core/VX_alu_unit.sv
$VORTEX/hw/rtl/core/VX_sfu_unit.sv
$VORTEX/hw/rtl/core/VX_execute.sv
$VORTEX/hw/rtl/core/VX_ipdom_stack.sv
$VORTEX/hw/rtl/core/VX_wctl_unit.sv
$VORTEX/hw/rtl/core/VX_lsu_unit.sv
$VORTEX/hw/rtl/core/VX_dispatch.sv
$VORTEX/hw/rtl/core/VX_lsu_slice.sv
$VORTEX/hw/rtl/core/VX_alu_muldiv.sv
$VORTEX/hw/rtl/core/VX_decode.sv
$VORTEX/hw/rtl/core/VX_csr_unit.sv
$VORTEX/hw/rtl/core/VX_issue_slice.sv


//Include Files under $VORTEX/hw/rtl/libs
+incdir+$VORTEX/hw/rtl/libs

$VORTEX/hw/rtl/libs/VX_reset_relay.sv
$VORTEX/hw/rtl/libs/VX_fifo_queue.sv
$VORTEX/hw/rtl/libs/VX_skid_buffer.sv
$VORTEX/hw/rtl/libs/VX_onehot_shift.sv
$VORTEX/hw/rtl/libs/VX_pe_serializer.sv
$VORTEX/hw/rtl/libs/VX_stream_buffer.sv
$VORTEX/hw/rtl/libs/VX_priority_encoder.sv
$VORTEX/hw/rtl/libs/VX_bits_insert.sv
$VORTEX/hw/rtl/libs/VX_scope_switch.sv
$VORTEX/hw/rtl/libs/VX_pending_size.sv
$VORTEX/hw/rtl/libs/VX_sp_ram.sv
$VORTEX/hw/rtl/libs/VX_mem_scheduler.sv
$VORTEX/hw/rtl/libs/VX_pipe_buffer.sv
$VORTEX/hw/rtl/libs/VX_bypass_buffer.sv
$VORTEX/hw/rtl/libs/VX_shift_register.sv
$VORTEX/hw/rtl/libs/VX_mux.sv
$VORTEX/hw/rtl/libs/VX_transpose.sv
$VORTEX/hw/rtl/libs/VX_nz_iterator.sv
$VORTEX/hw/rtl/libs/VX_axi_write_ack.sv
$VORTEX/hw/rtl/libs/VX_elastic_buffer.sv
$VORTEX/hw/rtl/libs/VX_edge_trigger.sv
$VORTEX/hw/rtl/libs/VX_onehot_encoder.sv
$VORTEX/hw/rtl/libs/VX_allocator.sv
$VORTEX/hw/rtl/libs/VX_elastic_adapter.sv
$VORTEX/hw/rtl/libs/VX_mem_data_adapter.sv
$VORTEX/hw/rtl/libs/VX_demux.sv
$VORTEX/hw/rtl/libs/VX_rr_arbiter.sv
$VORTEX/hw/rtl/libs/VX_stream_xpoint.sv
$VORTEX/hw/rtl/libs/VX_generic_arbiter.sv
$VORTEX/hw/rtl/libs/VX_stream_unpack.sv
$VORTEX/hw/rtl/libs/VX_pipe_register.sv
$VORTEX/hw/rtl/libs/VX_stream_xbar.sv
$VORTEX/hw/rtl/libs/VX_mem_bank_adapter.sv
$VORTEX/hw/rtl/libs/VX_bits_remove.sv
$VORTEX/hw/rtl/libs/VX_dp_ram.sv
$VORTEX/hw/rtl/libs/VX_reduce_tree.sv
$VORTEX/hw/rtl/libs/VX_scope_tap.sv
$VORTEX/hw/rtl/libs/VX_ticket_lock.sv
$VORTEX/hw/rtl/libs/VX_stream_pack.sv
$VORTEX/hw/rtl/libs/VX_index_buffer.sv
$VORTEX/hw/rtl/libs/VX_matrix_arbiter.sv
$VORTEX/hw/rtl/libs/VX_mem_coalescer.sv
$VORTEX/hw/rtl/libs/VX_divider.sv
$VORTEX/hw/rtl/libs/VX_serial_mul.sv
$VORTEX/hw/rtl/libs/VX_placeholder.sv
$VORTEX/hw/rtl/libs/VX_priority_arbiter.sv
$VORTEX/hw/rtl/libs/VX_lzc.sv
$VORTEX/hw/rtl/libs/VX_bits_concat.sv
$VORTEX/hw/rtl/libs/VX_async_ram_patch.sv
$VORTEX/hw/rtl/libs/VX_cyclic_arbiter.sv
$VORTEX/hw/rtl/libs/VX_avs_adapter.sv
$VORTEX/hw/rtl/libs/VX_index_queue.sv
$VORTEX/hw/rtl/libs/VX_axi_adapter.sv
$VORTEX/hw/rtl/libs/VX_popcount.sv
$VORTEX/hw/rtl/libs/VX_serial_div.sv
$VORTEX/hw/rtl/libs/VX_find_first.sv
$VORTEX/hw/rtl/libs/VX_stream_switch.sv
$VORTEX/hw/rtl/libs/VX_toggle_buffer.sv
$VORTEX/hw/rtl/libs/VX_multiplier.sv
$VORTEX/hw/rtl/libs/VX_onehot_mux.sv
$VORTEX/hw/rtl/libs/VX_scan.sv
$VORTEX/hw/rtl/libs/VX_stream_omega.sv
$VORTEX/hw/rtl/libs/VX_stream_arb.sv


//Include Files under $VORTEX/hw/rtl/cache
+incdir+$VORTEX/hw/rtl/cache

$VORTEX/hw/rtl/cache/VX_cache_define.vh
$VORTEX/hw/rtl/cache/VX_cache_mshr.sv
$VORTEX/hw/rtl/cache/VX_cache_tags.sv
$VORTEX/hw/rtl/cache/VX_cache_wrap.sv
$VORTEX/hw/rtl/cache/VX_cache_bypass.sv
$VORTEX/hw/rtl/cache/VX_cache_init.sv
$VORTEX/hw/rtl/cache/VX_cache_data.sv
$VORTEX/hw/rtl/cache/VX_cache_cluster.sv
$VORTEX/hw/rtl/cache/VX_cache.sv
$VORTEX/hw/rtl/cache/VX_cache_repl.sv
$VORTEX/hw/rtl/cache/VX_cache_flush.sv
$VORTEX/hw/rtl/cache/VX_cache_bank.sv
$VORTEX/hw/rtl/cache/VX_cache_top.sv

//Include Files under $VORTEX/hw/rtl/afu
+incdir+$VORTEX/hw/rtl/afu


//Include Files under $VORTEX/hw/rtl/afu/opae
+incdir+$VORTEX/hw/rtl/afu/opae


//Include Files under $VORTEX/hw/rtl/afu/xrt
+incdir+$VORTEX/hw/rtl/afu/xrt

$VORTEX/hw/rtl/afu/xrt/vortex_afu_xrt.vh
$VORTEX/hw/rtl/afu/xrt/vortex_afu.v
$VORTEX/hw/rtl/afu/xrt/VX_afu_ctrl.sv
$VORTEX/hw/rtl/afu/xrt/VX_afu_wrap.sv













