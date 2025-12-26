class VX_alu_tb_txn_item extends uvm_transaction;

    VX_core_id_t                   core_id;
    risc_v_seq_instr_address_t     pc;
    risc_v_seq_reg_num_t           rd;
    VX_wid_t                       wid;
    VX_tmask_t                     tmask;
    VX_gpr_seq_data_entry_t        data;
    bit                            wb;

    `uvm_object_utils_begin(VX_alu_tb_txn_item)
        `uvm_field_int(core_id,    UVM_DEFAULT)   
        `uvm_field_int(pc,         UVM_DEFAULT)
        `uvm_field_int(rd,         UVM_DEFAULT)
        `uvm_field_int(wid,        UVM_DEFAULT)
        `uvm_field_int(tmask,      UVM_DEFAULT)
        `uvm_field_int(wb,         UVM_DEFAULT)
        `uvm_object_utils_end

    function new(string name="VX_alu_tb_txn_item");
        super.new(name);
    endfunction

endclass