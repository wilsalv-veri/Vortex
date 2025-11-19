class VX_risc_v_base_instr_seq extends VX_risc_v_base_seq;

    `uvm_object_utils(VX_risc_v_base_instr_seq)

    VX_risc_v_inst_seq_item       instr_queue[$];

    function new(string name="VX_risc_v_base_instr_seq");
        super.new(name);
    endfunction

    task body(); 
        add_instructions();
        instr_queue.push_back(`EBREAK);  //END OF SEQUENCE INSTRUCTION
        num_of_words = instr_queue.size(); 
        super.body();
        send_instructions(); 
    endtask

    virtual function void add_instructions();
        //Do Nothing. Implement in derived classes
    endfunction

    virtual task send_instructions();
        foreach(instr_queue[idx])begin
            start_item(instr_queue[idx]);
            finish_item(instr_queue[idx]);
        end    
    endtask   

endclass
