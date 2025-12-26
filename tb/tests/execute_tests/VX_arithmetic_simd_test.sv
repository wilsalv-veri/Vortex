class VX_arithmetic_simd_test extends VX_risc_v_base_seq_lib_test;

    `uvm_component_utils(VX_arithmetic_simd_test)

    function new(string name="VX_arithmetic_simd_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        set_type_override_by_type(VX_risc_v_base_seq_lib::get_type(), VX_arithmetic_seq_lib::get_type());
        super.build_phase(phase);
    endfunction

endclass