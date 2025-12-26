class VX_wspawn_twice_seq_lib extends VX_wspawn_seq_lib;

    `uvm_object_utils(VX_wspawn_twice_seq_lib)
    `uvm_sequence_library_utils(VX_wspawn_twice_seq_lib)

    function new(string name="VX_wspawn_twice_seq_lib");
        super.new(name);
    endfunction

    virtual function void add_non_wspawn_sequence();
        VX_risc_v_base_seq_lib::add_typewide_sequence(VX_wspawn_rtg_seq::get_type());
    endfunction

endclass
