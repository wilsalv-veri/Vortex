class VX_gpr_tb_txn_item extends uvm_transaction;

    `uvm_object_utils(VX_gpr_tb_txn_item)
    
    VX_seq_gpr_bank_num_t       bank_num;
    VX_seq_gpr_bank_set_t       bank_set;
    VX_seq_gpr_entry_byteen     byteen;
    VX_gpr_seq_data_entry_t     gpr_data_entry;

    function new(string name="VX_gpr_tb_txn_item");
        super.new(name);
    endfunction

endclass