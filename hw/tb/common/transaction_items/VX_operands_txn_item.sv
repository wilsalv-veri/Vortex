class VX_operands_tb_txn_item extends uvm_transaction;

    `uvm_object_utils(VX_operands_tb_txn_item)

    VX_core_id_t             core_id;
    VX_gpr_seq_data_entry_t  rs1_data;
    VX_gpr_seq_data_entry_t  rs2_data;
    VX_gpr_seq_data_entry_t  rs3_data;
        
    function new(string name="VX_operands_tb_txn_item");
        super.new(name);
    endfunction

endclass