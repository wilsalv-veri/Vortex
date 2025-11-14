import VX_tb_common_pkg::*; 

class VX_risc_v_base_instr_seq extends VX_risc_v_base_seq;

    `uvm_object_utils(VX_risc_v_base_instr_seq)

    VX_risc_v_inst_seq_item       instr_queue[$];

    function new(string name="VX_risc_v_base_instr_seq");
        super.new(name);

        if (!this.randomize())
            `VX_info("VX_RISC_V_BASE_SEQ", $sformatf("Failed to Randomize VX_risc_v_base_instr_seq object!"))
        
    endfunction

    task body(); 
        num_of_cachelines = 1;
      
        super.body();
        add_instructions();
        send_instructions();
    endtask

    virtual function add_instructions();
        instr_queue.push_back(`AND(5'h0,5'h1,5'h2));      
    endfunction

    virtual task send_instructions();
        foreach(instr_queue[idx])begin
            start_item(instr_queue[idx]);
            `VX_info("VX_RISC_V_BASE_SEQ", "Sequencer Grant Received!")
            finish_item(instr_queue[idx]);
            `VX_info("VX_RISC_V_BASE_SEQ", "Instruction Sent!")
        end

        //TODO: Enable Multiple Instruction/Cacheline Sequence
        /*
        for (int cache_line_idx=0; cache_line_idx < num_of_cachelines; cache_line_idx)begin 
            for(int inst_num = 0 ; inst_num < INST_PER_CACHE_LINE; inst_num++)begin
                risc_v_inst = VX_risc_v_inst_item::type_id::create($sformatf("riscv_inst%0d", inst_num));
                start_item(risc_v_inst);
                assert(risc_v_inst.randomize());
                finish_item(risc_v_inst);
            end
        end*/    
    
    endtask   

endclass
