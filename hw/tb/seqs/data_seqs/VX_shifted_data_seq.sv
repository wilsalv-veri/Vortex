class VX_shifted_data_seq extends VX_risc_v_base_data_seq;

    `uvm_object_utils(VX_shifted_data_seq)

    int                    num_of_data_word;
    risc_v_seq_data_t      data_value;

    function new(string name = "VX_shifted_data_seq");
        super.new(name);

        num_of_data_word = INST_PER_CACHE_LINE;
        data_value       = risc_v_seq_data_t'('h11111111); 
    endfunction

    virtual function void add_data();
         for(int word_idx=0; word_idx < num_of_data_word; word_idx++) begin
            risc_v_seq_item           = VX_risc_v_seq_item::type_id::create($sformatf("riscv_inst_data%0d", 0));
            risc_v_seq_item.data_type = DATA;
              
            risc_v_seq_item.raw_data  = data_value;
            data_word_queue.push_back(risc_v_seq_item);
            data_value += 1;
         end
    endfunction

endclass