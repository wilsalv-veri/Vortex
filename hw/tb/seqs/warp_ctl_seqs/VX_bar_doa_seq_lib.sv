class VX_bar_doa_seq_lib extends VX_risc_v_base_seq_lib;

    `uvm_object_utils(VX_bar_doa_seq_lib)
    `uvm_sequence_library_utils(VX_bar_doa_seq_lib)

    function new(string name="VX_bar_doa_seq_lib");
        super.new(name);
        num_of_sequences = 3;
        super.sequence_count = num_of_sequences;
    endfunction

    virtual function void add_vx_sequences();
        add_wspawn_sequence();
        add_bar_sequence();
        add_post_bar_sequence();
    endfunction

    virtual function void add_wspawn_sequence();
        super.add_typewide_sequence(VX_wspawn_doa_seq::get_type());
    endfunction

    virtual function void add_bar_sequence();
        super.add_typewide_sequence(VX_bar_doa_seq::get_type());
    endfunction

    virtual function void add_post_bar_sequence();
        super.add_typewide_sequence(VX_pred_doa_seq::get_type());
    endfunction

endclass