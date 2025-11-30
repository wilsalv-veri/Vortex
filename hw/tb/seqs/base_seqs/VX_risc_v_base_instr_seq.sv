class VX_risc_v_base_instr_seq extends VX_risc_v_base_seq;

    `uvm_object_utils(VX_risc_v_base_instr_seq)

    VX_risc_v_instr_queue       instr_queue;

    function new(string name="VX_risc_v_base_instr_seq");
        super.new(name);
        instr_queue  = VX_risc_v_instr_queue::type_id::create("VX_risc_v_instr_queue");
    endfunction

    task body(); 
        if (!p_sequencer.curr_pc)
            p_sequencer.curr_pc = CODE_CS_BASE_ADDR;
        else 
            instr_queue.current_address = p_sequencer.curr_pc;

        pre_add_instructions();
        add_instructions();
        instr_queue.push_back(`TMC(`RS1(0)));  //END OF SEQUENCE INSTRUCTION
        post_add_instructions();

        num_of_words = instr_queue.size();
        p_sequencer.curr_pc +=  (instr_queue.size() * XLENB);
        super.body();
        send_instructions(); 
    endtask

    virtual function void pre_add_instructions();
        //Do Nothing. Implement in derived classes
    endfunction

    virtual function void add_instructions();
        //Do Nothing. Implement in derived classes
    endfunction

    virtual function void post_add_instructions();
        //Do Nothing. Implement in derived classes
    endfunction

    virtual task send_instructions();
        VX_risc_v_instr_seq_item instr_item;

        for(int idx=0; idx<instr_queue.size(); idx++)begin
            instr_item = instr_queue.get(idx);
            start_item(instr_item);
            finish_item(instr_item);
        end    
    endtask   

endclass
