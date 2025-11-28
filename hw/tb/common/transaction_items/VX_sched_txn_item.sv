class VX_sched_tb_txn_item extends uvm_transaction;

    bit                                    sched_info_valid;
    bit                                    wspawn_valid;
    bit                                    curr_single_warp;
    bit [`NUM_WARPS-1:0]                   active_warps; // updated when a warp is activated or disabled
    bit [`NUM_WARPS-1:0]                   stalled_warps;  // set when branch/gpgpu instructions are issued

    bit [`NUM_WARPS-1:0][`NUM_THREADS-1:0] thread_masks;
    bit [`NUM_WARPS-1:0][PC_BITS-1:0]      warp_pcs;
    bit [PC_BITS-1:0]                      result_pc;
    bit [NW_WIDTH-1:0]                     wid;
    bit [`UP( `CLOG2(`NUM_SFU_LANES))-1:0] last_tid;
    
    `uvm_object_utils_begin(VX_sched_tb_txn_item)
        `uvm_field_int   (sched_info_valid, UVM_DEFAULT)
        `uvm_field_sarray_int (active_warps, UVM_DEFAULT)
        `uvm_field_sarray_int (stalled_warps, UVM_DEFAULT)
        `uvm_field_sarray_int (thread_masks, UVM_DEFAULT)
        `uvm_field_sarray_int (warp_pcs, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name="VX_sched_tb_txn_item");
        super.new(name); 
    endfunction
    
endclass