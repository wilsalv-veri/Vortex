class VX_arithmetic_imm_seq_lib extends VX_arithmetic_seq_lib;

    `uvm_object_utils(VX_arithmetic_imm_seq_lib)
    `uvm_sequence_library_utils(VX_arithmetic_imm_seq_lib)

    string message_id ="VX_ARITHMETIC_IMM_SEQ_LIB";

    function new(string name="VX_arithmetic_imm_seq_lib");
        super.new(name);
    endfunction

    virtual function void add_arithmetic_sequence();
        VX_risc_v_base_seq_lib::add_typewide_sequence(VX_arithmetic_imm_rtg_seq::get_type());
    endfunction

endclass