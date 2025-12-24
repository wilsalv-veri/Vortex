class VX_seq_result_txn_item extends uvm_transaction;

    VX_core_id_t  core_id;
    VX_warp_num_t num_warps_spawned;

    `uvm_object_utils_begin(VX_seq_result_txn_item)
        `uvm_field_int(core_id,           UVM_DEFAULT)     
        `uvm_field_int(num_warps_spawned, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name="VX_seq_result_txn_item");
        super.new(name);
    endfunction

endclass