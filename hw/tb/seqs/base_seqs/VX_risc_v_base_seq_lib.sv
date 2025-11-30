class VX_risc_v_base_seq_lib extends uvm_sequence_library #(VX_risc_v_seq_item);

    `uvm_object_utils(VX_risc_v_base_seq_lib)
    `uvm_sequence_library_utils(VX_risc_v_base_seq_lib)

    `uvm_declare_p_sequencer(VX_risc_v_sequencer)
    
    int num_of_sequences;
    protected int curr_seq_idx;

    function new(string name="VX_risc_v_base_seq_lib");
        super.new(name);
        curr_seq_idx = 0;
        sequence_count = 0;
        num_of_sequences = 2;
        sequence_count = num_of_sequences;
        add_vx_sequences();
        init_sequence_library();
    endfunction

    virtual task body();
        p_sequencer.seq_lib_num_seqs_port.put(sequence_count);
        super.body();
    endtask

    virtual function void add_vx_sequences();
        //Do nothing. Implement in derived classes
    endfunction

    function int select_sequence(int max);
        return select_inorder_next_seq();
    endfunction

    virtual function int select_inorder_next_seq();
        return curr_seq_idx++;
    endfunction

endclass