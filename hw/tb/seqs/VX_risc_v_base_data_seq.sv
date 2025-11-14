import VX_tb_common_pkg::*; 

class VX_risc_v_base_data_seq extends VX_risc_v_base_seq;

    `uvm_object_utils(VX_risc_v_base_data_seq)

    VX_risc_v_seq_item       data_word_queue[$];

    function new(string name="VX_risc_v_base_data_seq");
        super.new(name);

        if (!this.randomize())
            `VX_info("VX_RISC_V_BASE_SEQ", $sformatf("Failed to Randomize VX_risc_v_base_data_seq object!"))
        
    endfunction

    task body(); 
        num_of_cachelines = 1;

        super.body();
        add_data();
        send_data();  
    endtask

    task add_data();
        risc_v_seq_item           = VX_risc_v_seq_item::type_id::create($sformatf("riscv_inst_data%0d", 0));
        risc_v_seq_item.data_type = DATA;
        risc_v_seq_item.raw_data  = 32'hcafebabe;
        data_word_queue.push_back(risc_v_seq_item);
    endtask

    task send_data();
        foreach(data_word_queue[idx])begin
            start_item(data_word_queue[idx]);
            `VX_info("VX_RISC_V_BASE_DATA_SEQ", "Sequencer Grant Received!")
            finish_item(data_word_queue[idx]);
            `VX_info("VX_RISC_V_BASE_DATA_SEQ", "Data Sent!")
        end
    endtask

endclass
