class VX_non_dvg_join_seq extends VX_split_join_doa_seq;

    `uvm_object_utils(VX_non_dvg_join_seq)

    function new(string name="VX_non_dvg_join_seq");
        super.new(name);
        ipdom_top_stack_reg = extra_stack_ptr_reg;
        extra_ptr_val       = DV_STACK_SIZEW;
    endfunction

endclass