class VX_wspawn_doa_seq_lib extends VX_risc_v_base_seq_lib;

    `uvm_object_utils(VX_wspawn_doa_seq_lib)
    `uvm_sequence_library_utils(VX_wspawn_doa_seq_lib)

    string message_id = "VX_WSPAWN_DOA_SEQ_LIB";

    parameter NUM_OF_SEQUENCES = 2;

    function new(string name="VX_wspawn_doa_seq");
        super.new(name);
        super.sequence_count = NUM_OF_SEQUENCES;
    endfunction

    virtual function void add_vx_sequences();
        add_wspawn_sequence();
        add_non_wspawn_sequence();
    endfunction

    virtual function void add_wspawn_sequence();
        super.add_typewide_sequence(VX_wspawn_doa_seq::get_type());
    endfunction

    virtual function void add_non_wspawn_sequence();
        super.add_typewide_sequence(VX_tmc_doa_seq::get_type());
    endfunction

endclass