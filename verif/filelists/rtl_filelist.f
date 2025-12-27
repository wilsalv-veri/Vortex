//Include Files under $VORTEX/rtl
+incdir+$VORTEX/rtl

$VORTEX/rtl/VX_scope.vh
$VORTEX/rtl/VX_types.vh
$VORTEX/rtl/VX_define.vh
$VORTEX/rtl/VX_platform.vh
$VORTEX/rtl/VX_config.vh
$VORTEX/rtl/VX_gpu_pkg.sv
$VORTEX/rtl/VX_trace_pkg.sv
$VORTEX/rtl/Vortex.sv
$VORTEX/rtl/Vortex_axi.sv
$VORTEX/rtl/VX_socket.sv
$VORTEX/rtl/VX_cluster.sv
//Include Files under $VORTEX/rtl/mem
+incdir+$VORTEX/rtl/mem

$VORTEX/rtl/mem/VX_local_mem.sv
$VORTEX/rtl/mem/VX_gbar_bus_if.sv
$VORTEX/rtl/mem/VX_mem_bus_if.sv
$VORTEX/rtl/mem/VX_lsu_adapter.sv
$VORTEX/rtl/mem/VX_lsu_mem_arb.sv
$VORTEX/rtl/mem/VX_lsu_mem_if.sv
$VORTEX/rtl/mem/VX_gbar_arb.sv
$VORTEX/rtl/mem/VX_lmem_switch.sv
$VORTEX/rtl/mem/VX_gbar_unit.sv
$VORTEX/rtl/mem/VX_local_mem_top.sv
$VORTEX/rtl/mem/VX_mem_arb.sv
$VORTEX/rtl/mem/VX_mem_switch.sv

//Include Files under $VORTEX/rtl/fpu
+incdir+$VORTEX/rtl/fpu

$VORTEX/rtl/fpu/VX_fpu_define.vh
$VORTEX/rtl/fpu/VX_fpu_pkg.sv
$VORTEX/rtl/fpu/VX_fpu_dpi.sv
$VORTEX/rtl/fpu/VX_fpu_fpnew.sv
$VORTEX/rtl/fpu/VX_fncp_unit.sv
$VORTEX/rtl/fpu/VX_fp_rounding.sv
$VORTEX/rtl/fpu/VX_fpu_cvt.sv
$VORTEX/rtl/fpu/VX_fpu_sqrt.sv
$VORTEX/rtl/fpu/VX_fpu_fma.sv
$VORTEX/rtl/fpu/VX_fpu_div.sv
$VORTEX/rtl/fpu/VX_fcvt_unit.sv
$VORTEX/rtl/fpu/VX_fpu_ncp.sv
$VORTEX/rtl/fpu/VX_fpu_dsp.sv
$VORTEX/rtl/fpu/VX_fp_classifier.sv

//Include Files under $VORTEX/rtl/interfaces
+incdir+$VORTEX/rtl/interfaces

$VORTEX/rtl/interfaces/VX_decode_if.sv
$VORTEX/rtl/interfaces/VX_commit_csr_if.sv
$VORTEX/rtl/interfaces/VX_writeback_if.sv
$VORTEX/rtl/interfaces/VX_operands_if.sv
$VORTEX/rtl/interfaces/VX_warp_ctl_if.sv
$VORTEX/rtl/interfaces/VX_decode_sched_if.sv
$VORTEX/rtl/interfaces/VX_ibuffer_if.sv
$VORTEX/rtl/interfaces/VX_commit_if.sv
$VORTEX/rtl/interfaces/VX_result_if.sv
$VORTEX/rtl/interfaces/VX_execute_if.sv
$VORTEX/rtl/interfaces/VX_issue_sched_if.sv
$VORTEX/rtl/interfaces/VX_fetch_if.sv
$VORTEX/rtl/interfaces/VX_commit_sched_if.sv
$VORTEX/rtl/interfaces/VX_dispatch_if.sv
$VORTEX/rtl/interfaces/VX_fpu_csr_if.sv
$VORTEX/rtl/interfaces/VX_schedule_if.sv
$VORTEX/rtl/interfaces/VX_branch_ctl_if.sv
$VORTEX/rtl/interfaces/VX_sched_csr_if.sv
$VORTEX/rtl/interfaces/VX_scoreboard_if.sv
$VORTEX/rtl/interfaces/VX_dcr_bus_if.sv

//Include Files under $VORTEX/rtl/tcu
+incdir+$VORTEX/rtl/tcu

$VORTEX/rtl/tcu/VX_tcu_pkg.sv
$VORTEX/rtl/tcu/VX_tcu_fp.sv
$VORTEX/rtl/tcu/VX_tcu_fedp_dsp.sv
$VORTEX/rtl/tcu/VX_tcu_fedp_bhf.sv
$VORTEX/rtl/tcu/VX_tcu_fedp_int.sv
$VORTEX/rtl/tcu/VX_tcu_int.sv
$VORTEX/rtl/tcu/VX_tcu_unit.sv
$VORTEX/rtl/tcu/VX_tcu_uops.sv
$VORTEX/rtl/tcu/VX_tcu_fedp_dpi.sv
//Include Files under $VORTEX/rtl/tcu/bhf
+incdir+$VORTEX/rtl/tcu/bhf

$VORTEX/rtl/tcu/bhf/VX_tcu_bhf_fp16mul.sv
$VORTEX/rtl/tcu/bhf/bsg_counting_leading_zeros.sv
$VORTEX/rtl/tcu/bhf/VX_tcu_bhf_fp32add.sv
$VORTEX/rtl/tcu/bhf/VX_tcu_bhf_fp8mul.sv
$VORTEX/rtl/tcu/bhf/VX_tcu_bhf_bf16mul.sv
$VORTEX/rtl/tcu/bhf/VX_tcu_bhf_fp16add.sv
$VORTEX/rtl/tcu/bhf/VX_tcu_bhf_tf32mul.sv


//Include Files under $VORTEX/rtl/core
+incdir+$VORTEX/rtl/core

$VORTEX/rtl/core/VX_commit.sv
$VORTEX/rtl/core/VX_core.sv
$VORTEX/rtl/core/VX_mem_unit.sv
$VORTEX/rtl/core/VX_fpu_unit.sv
$VORTEX/rtl/core/VX_gather_unit.sv
$VORTEX/rtl/core/VX_mem_unit_top.sv
$VORTEX/rtl/core/VX_uuid_gen.sv
$VORTEX/rtl/core/VX_csr_data.sv
$VORTEX/rtl/core/VX_operands.sv
$VORTEX/rtl/core/VX_issue_top.sv
$VORTEX/rtl/core/VX_opc_unit.sv
$VORTEX/rtl/core/VX_uop_sequencer.sv
$VORTEX/rtl/core/VX_issue.sv
$VORTEX/rtl/core/VX_dcr_data.sv
$VORTEX/rtl/core/VX_pe_switch.sv
$VORTEX/rtl/core/VX_schedule.sv
$VORTEX/rtl/core/VX_core_top.sv
$VORTEX/rtl/core/VX_dispatch_unit.sv
$VORTEX/rtl/core/VX_split_join.sv
$VORTEX/rtl/core/VX_fetch.sv
$VORTEX/rtl/core/VX_scoreboard.sv
$VORTEX/rtl/core/VX_ibuffer.sv
$VORTEX/rtl/core/VX_alu_int.sv
$VORTEX/rtl/core/VX_alu_unit.sv
$VORTEX/rtl/core/VX_sfu_unit.sv
$VORTEX/rtl/core/VX_execute.sv
$VORTEX/rtl/core/VX_ipdom_stack.sv
$VORTEX/rtl/core/VX_wctl_unit.sv
$VORTEX/rtl/core/VX_lsu_unit.sv
$VORTEX/rtl/core/VX_dispatch.sv
$VORTEX/rtl/core/VX_lsu_slice.sv
$VORTEX/rtl/core/VX_alu_muldiv.sv
$VORTEX/rtl/core/VX_decode.sv
$VORTEX/rtl/core/VX_csr_unit.sv
$VORTEX/rtl/core/VX_issue_slice.sv

//Include Files under $VORTEX/rtl/libs
+incdir+$VORTEX/rtl/libs

$VORTEX/rtl/libs/VX_reset_relay.sv
$VORTEX/rtl/libs/VX_fifo_queue.sv
$VORTEX/rtl/libs/VX_skid_buffer.sv
$VORTEX/rtl/libs/VX_onehot_shift.sv
$VORTEX/rtl/libs/VX_pe_serializer.sv
$VORTEX/rtl/libs/VX_stream_buffer.sv
$VORTEX/rtl/libs/VX_priority_encoder.sv
$VORTEX/rtl/libs/VX_bits_insert.sv
$VORTEX/rtl/libs/VX_scope_switch.sv
$VORTEX/rtl/libs/VX_pending_size.sv
$VORTEX/rtl/libs/VX_sp_ram.sv
$VORTEX/rtl/libs/VX_mem_scheduler.sv
$VORTEX/rtl/libs/VX_pipe_buffer.sv
$VORTEX/rtl/libs/VX_bypass_buffer.sv
$VORTEX/rtl/libs/VX_shift_register.sv
$VORTEX/rtl/libs/VX_mux.sv
$VORTEX/rtl/libs/VX_transpose.sv
$VORTEX/rtl/libs/VX_nz_iterator.sv
$VORTEX/rtl/libs/VX_axi_write_ack.sv
$VORTEX/rtl/libs/VX_elastic_buffer.sv
$VORTEX/rtl/libs/VX_edge_trigger.sv
$VORTEX/rtl/libs/VX_onehot_encoder.sv
$VORTEX/rtl/libs/VX_allocator.sv
$VORTEX/rtl/libs/VX_elastic_adapter.sv
$VORTEX/rtl/libs/VX_mem_data_adapter.sv
$VORTEX/rtl/libs/VX_demux.sv
$VORTEX/rtl/libs/VX_rr_arbiter.sv
$VORTEX/rtl/libs/VX_stream_xpoint.sv
$VORTEX/rtl/libs/VX_generic_arbiter.sv
$VORTEX/rtl/libs/VX_stream_unpack.sv
$VORTEX/rtl/libs/VX_pipe_register.sv
$VORTEX/rtl/libs/VX_stream_xbar.sv
$VORTEX/rtl/libs/VX_mem_bank_adapter.sv
$VORTEX/rtl/libs/VX_bits_remove.sv
$VORTEX/rtl/libs/VX_dp_ram.sv
$VORTEX/rtl/libs/VX_reduce_tree.sv
$VORTEX/rtl/libs/VX_scope_tap.sv
$VORTEX/rtl/libs/VX_ticket_lock.sv
$VORTEX/rtl/libs/VX_stream_pack.sv
$VORTEX/rtl/libs/VX_index_buffer.sv
$VORTEX/rtl/libs/VX_matrix_arbiter.sv
$VORTEX/rtl/libs/VX_mem_coalescer.sv
$VORTEX/rtl/libs/VX_divider.sv
$VORTEX/rtl/libs/VX_serial_mul.sv
$VORTEX/rtl/libs/VX_placeholder.sv
$VORTEX/rtl/libs/VX_priority_arbiter.sv
$VORTEX/rtl/libs/VX_lzc.sv
$VORTEX/rtl/libs/VX_bits_concat.sv
$VORTEX/rtl/libs/VX_async_ram_patch.sv
$VORTEX/rtl/libs/VX_cyclic_arbiter.sv
$VORTEX/rtl/libs/VX_avs_adapter.sv
$VORTEX/rtl/libs/VX_index_queue.sv
$VORTEX/rtl/libs/VX_axi_adapter.sv
$VORTEX/rtl/libs/VX_popcount.sv
$VORTEX/rtl/libs/VX_serial_div.sv
$VORTEX/rtl/libs/VX_find_first.sv
$VORTEX/rtl/libs/VX_stream_switch.sv
$VORTEX/rtl/libs/VX_toggle_buffer.sv
$VORTEX/rtl/libs/VX_multiplier.sv
$VORTEX/rtl/libs/VX_onehot_mux.sv
$VORTEX/rtl/libs/VX_scan.sv
$VORTEX/rtl/libs/VX_stream_omega.sv
$VORTEX/rtl/libs/VX_stream_arb.sv

//Include Files under $VORTEX/rtl/cache
+incdir+$VORTEX/rtl/cache

$VORTEX/rtl/cache/VX_cache_define.vh
$VORTEX/rtl/cache/VX_cache_mshr.sv
$VORTEX/rtl/cache/VX_cache_tags.sv
$VORTEX/rtl/cache/VX_cache_wrap.sv
$VORTEX/rtl/cache/VX_cache_bypass.sv
$VORTEX/rtl/cache/VX_cache_init.sv
$VORTEX/rtl/cache/VX_cache_data.sv
$VORTEX/rtl/cache/VX_cache_cluster.sv
$VORTEX/rtl/cache/VX_cache.sv
$VORTEX/rtl/cache/VX_cache_repl.sv
$VORTEX/rtl/cache/VX_cache_flush.sv
$VORTEX/rtl/cache/VX_cache_bank.sv
$VORTEX/rtl/cache/VX_cache_top.sv

//Include Files under $VORTEX/rtl/afu
+incdir+$VORTEX/rtl/afu

//Include Files under $VORTEX/rtl/afu/opae
+incdir+$VORTEX/rtl/afu/opae


//Include Files under $VORTEX/rtl/afu/xrt
+incdir+$VORTEX/rtl/afu/xrt

$VORTEX/rtl/afu/xrt/vortex_afu_xrt.vh
$VORTEX/rtl/afu/xrt/vortex_afu.v
$VORTEX/rtl/afu/xrt/VX_afu_ctrl.sv
$VORTEX/rtl/afu/xrt/VX_afu_wrap.sv


