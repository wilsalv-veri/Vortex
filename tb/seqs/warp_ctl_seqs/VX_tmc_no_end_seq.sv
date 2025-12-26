class VX_tmc_no_end_seq extends VX_tmc_doa_seq;

    `uvm_object_utils(VX_tmc_no_end_seq)

    function new (string name="VX_tmc_no_end_seq");
        super.new(name);
    endfunction

    virtual function void post_add_instructions();
        //Remove the last instruction (TMC) which kills the warps
        //Must be careful. This will only work in the case of use of
        //sequence library which has another sequence after this
        //Without another sequence running after, this will run forever
        instr_queue.pop_back();
    endfunction
    
endclass