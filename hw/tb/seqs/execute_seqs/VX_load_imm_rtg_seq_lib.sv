class VX_load_imm_rtg_seq_lib extends VX_load_imm_doa_seq_lib;

    `uvm_object_utils(VX_load_imm_rtg_seq_lib)
    `uvm_sequence_library_utils(VX_load_imm_rtg_seq_lib)

    function new(string name="VX_load_imm_rtg_seq_lib");
        super.new(name);
        message_id = "VX_LOAD_IMM_RTG_SEQ_LIB";
    endfunction

    virtual function void add_load_sequence();
        VX_risc_v_base_seq_lib::add_typewide_sequence(VX_load_imm_rtg_seq::get_type());
    endfunction

endclass