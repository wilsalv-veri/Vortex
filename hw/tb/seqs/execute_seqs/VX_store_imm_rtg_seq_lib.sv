class VX_store_imm_rtg_seq_lib extends VX_store_imm_doa_seq_lib;

    `uvm_object_utils(VX_store_imm_rtg_seq_lib)
    `uvm_sequence_library_utils(VX_store_imm_rtg_seq_lib)

    function new(string name="VX_store_imm_rtg_seq_lib");
        super.new(name);
        message_id = "VX_STORE_IMM_RTG_SEQ_LIB";
    endfunction

    virtual function void add_store_sequence();
        VX_risc_v_base_seq_lib::add_typewide_sequence(VX_store_imm_rtg_seq::get_type());
    endfunction

endclass