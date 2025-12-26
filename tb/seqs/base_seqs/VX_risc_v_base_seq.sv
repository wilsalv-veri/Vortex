class VX_risc_v_base_seq extends uvm_sequence #(VX_risc_v_seq_item);

    `uvm_object_utils(VX_risc_v_base_seq)

    `uvm_declare_p_sequencer(VX_risc_v_sequencer)
    
    int num_of_words;
    VX_risc_v_seq_item risc_v_seq_item;

    function new(string name="VX_risc_v_base_seq");
        super.new(name);   
    endfunction

    task body(); 
        p_sequencer.seq_num_inst_port.put(num_of_words);  
    endtask

endclass