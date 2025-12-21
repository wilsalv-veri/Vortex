class VX_load_imm_doa_seq_lib extends VX_risc_v_base_seq_lib;

    `uvm_object_utils(VX_load_imm_doa_seq_lib)
    `uvm_sequence_library_utils(VX_load_imm_doa_seq_lib)

    string message_id = "VX_LOAD_IMM_DOA_SEQ_LIB";

    function new(string name="VX_load_imm_doa_seq_lib");
        super.new(name);    
    endfunction

    virtual function void add_vx_sequences();
        add_data_sequence();
        add_load_sequence();
    endfunction

    virtual function void add_data_sequence();
        super.add_typewide_sequence(VX_shifted_data_seq::get_type());
    endfunction

    virtual function void add_load_sequence();
        super.add_typewide_sequence(VX_load_imm_doa_seq::get_type());
    endfunction

endclass