class VX_vote_rtg_test extends VX_risc_v_base_instr_seq_test;

    `uvm_component_utils(VX_vote_rtg_test)

    function new(string name="VX_vote_rtg_test", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        set_type_override_by_type(VX_risc_v_base_instr_seq::get_type(), VX_vote_rtg_seq::get_type());
        super.build_phase(phase);
    endfunction

endclass