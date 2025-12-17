class VX_arithmetic_seq_lib extends VX_risc_v_base_seq_lib;

    `uvm_object_utils(VX_arithmetic_seq_lib)
    `uvm_sequence_library_utils(VX_arithmetic_seq_lib)

    string message_id = "VX_ARITMETIC_SEQ_LIB";

    function new(string name="VX_arithmetic_seq_lib");
        super.new(name);    
    endfunction

    virtual function void add_vx_sequences();
        add_tmc_sequence();
        add_arithmetic_sequence();
    endfunction

    virtual function void add_tmc_sequence();
        super.add_typewide_sequence(VX_tmc_no_end_seq::get_type());
    endfunction

    virtual function void add_arithmetic_sequence();
        super.add_typewide_sequence(VX_arithmetic_rtg_seq::get_type());
    endfunction

endclass
        