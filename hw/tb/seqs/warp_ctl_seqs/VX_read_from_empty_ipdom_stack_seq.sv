class VX_read_from_empty_ipdom_stack_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_read_from_empty_ipdom_stack_seq)
 
    function new(string name="VX_read_from_empty_ipdom_stack_seq");
        super.new(name);
    endfunction
 
    virtual function void add_instructions();  
        instr_queue.push_back(`JOIN(`RS1(0)));
    endfunction

endclass
