class VX_sched_tb_txn_item extends uvm_transaction;

    VX_core_id_t                                       core_id;
    bit                                                sched_info_valid;
    bit                                                bar_is_global;
    bit                                                wspawn_valid;
    bit                                                join_valid;
    VX_ipdom_wr_ptrs_t                                 ipdom_wr_ptrs;
    bit                                                curr_single_warp;
    bit [`NUM_WARPS-1:0]                               active_warps; // updated when a warp is activated or disabled
    bit [`NUM_WARPS-1:0]                               stalled_warps;  // set when branch/gpgpu instructions are issued

    bit [`NUM_WARPS-1:0][`NUM_THREADS-1:0]             thread_masks;
    bit [`NUM_WARPS-1:0][PC_BITS-1:0]                  warp_pcs;
    bit [PC_BITS-1:0]                                  result_pc;
    bit [NW_WIDTH-1:0]                                 wid;
    bit [`UP( `CLOG2(`NUM_SFU_LANES))-1:0]             last_tid;

    //BRANCH
    bit      [`NUM_ALU_BLOCKS-1:0]                     br_valid;
    VX_wid_t [`NUM_ALU_BLOCKS-1:0]                     br_wid;
    bit      [`NUM_ALU_BLOCKS-1:0]                     br_taken;
    risc_v_seq_instr_address_t  [`NUM_ALU_BLOCKS-1:0]  br_target;
    risc_v_seq_instr_address_t                         br_pc;
  

    `uvm_object_utils_begin(VX_sched_tb_txn_item)
        `uvm_field_int(core_id,               UVM_DEFAULT)   
        `uvm_field_int   (sched_info_valid,   UVM_DEFAULT)
        `uvm_field_sarray_int (active_warps,  UVM_DEFAULT)
        `uvm_field_sarray_int (stalled_warps, UVM_DEFAULT)
        `uvm_field_sarray_int (thread_masks,  UVM_DEFAULT)
        `uvm_field_sarray_int (warp_pcs,      UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name="VX_sched_tb_txn_item");
        super.new(name); 
    endfunction
    
endclass