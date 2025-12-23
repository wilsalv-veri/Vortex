class VX_store_imm_doa_seq_lib extends VX_risc_v_base_seq_lib;

    `uvm_object_utils(VX_store_imm_doa_seq_lib)
    `uvm_sequence_library_utils(VX_store_imm_doa_seq_lib)

    string message_id = "VX_STORE_IMM_DOA_SEQ_LIB";

    function new(string name="VX_STORE_imm_doa_seq_lib");
        super.new(name);    
    endfunction

    virtual function void add_vx_sequences();
        add_data_sequence();
        add_store_sequence();
    endfunction

    virtual function void add_data_sequence();
        super.add_typewide_sequence(VX_shifted_data_seq::get_type());
    endfunction

    virtual function void add_store_sequence();
        super.add_typewide_sequence(VX_store_imm_doa_seq::get_type());
    endfunction

endclass