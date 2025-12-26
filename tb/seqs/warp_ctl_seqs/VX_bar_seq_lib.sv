class VX_bar_seq_lib extends VX_bar_doa_seq_lib;

    `uvm_object_utils(VX_bar_seq_lib)
    `uvm_sequence_library_utils(VX_bar_seq_lib)

    function new(string name="VX_bar_seq_lib");
        super.new(name);
    endfunction

    virtual function void add_wspawn_sequence();
        VX_risc_v_base_seq_lib::add_typewide_sequence(VX_wspawn_rtg_seq::get_type());
    endfunction

    virtual function void add_bar_sequence();
        VX_risc_v_base_seq_lib::add_typewide_sequence(VX_bar_rtg_seq::get_type());
    endfunction

    virtual function void add_post_bar_sequence();
        VX_risc_v_base_seq_lib::add_typewide_sequence(VX_pred_rtg_seq::get_type());
    endfunction

endclass