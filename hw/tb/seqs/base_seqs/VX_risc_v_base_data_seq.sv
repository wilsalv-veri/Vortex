class VX_risc_v_base_data_seq extends VX_risc_v_base_seq;

    `uvm_object_utils(VX_risc_v_base_data_seq)

    VX_risc_v_seq_item       data_word_queue[$];

    function new(string name="VX_risc_v_base_data_seq");
        super.new(name);

        if (!this.randomize())
            `VX_info("VX_RISC_V_BASE_SEQ", $sformatf("Failed to Randomize VX_risc_v_base_data_seq object!"))
        
    endfunction

    task body(); 
        //if(!p_sequencer.curr_pc)
        //    p_sequencer.curr_pc = MEM_LOAD_DATA_BASE_ADDR;

        add_data();
        num_of_words = data_word_queue.size();
        //p_sequencer.curr_pc += (data_word_queue.size() * XLENB);
        super.body();
        
        send_data();  
    endtask

    virtual function void add_data();
        //Do Nothing: To be implemented in derived classes
    endfunction

    virtual task send_data();
        foreach(data_word_queue[idx])begin
            start_item(data_word_queue[idx]);
            `VX_info("VX_RISC_V_BASE_DATA_SEQ", "Sequencer Grant Received!")
            finish_item(data_word_queue[idx]);
            `VX_info("VX_RISC_V_BASE_DATA_SEQ", "Data Sent!")
        end
    endtask

endclass
