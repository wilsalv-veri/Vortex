class VX_tmc_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_tmc_doa_seq)

    risc_v_seq_reg_num_t src_reg;
    risc_v_seq_reg_num_t dst_reg;
    
    function new(string name="VX_tmc_doa_seq");
        super.new(name);
        `VX_info("VX_TMC_DOA_SEQ", "SEQUENCE CREATED")
        src_reg = 2;
        dst_reg = 2;
    endfunction
 
    virtual function void add_instructions();  
        instr_queue.push_back(`ADDI(`RS1(src_reg),`IMM_HEX(f),`RD(dst_reg)));
        instr_queue.push_back(`TMC(`RS1(src_reg))); 
    endfunction

endclass
