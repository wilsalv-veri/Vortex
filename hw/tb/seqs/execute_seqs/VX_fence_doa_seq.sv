class VX_fence_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_fence_doa_seq)

    string message_id = "VX_FENCE_DOA_SEQ";

    rand risc_v_seq_reg_num_t    st_src1_reg;
    rand risc_v_seq_reg_num_t    st_src2_reg;
    rand risc_v_seq_reg_num_t    ld_dst_reg;
    rand risc_v_seq_imm_t        load_store_imm;
    rand risc_v_seq_imm_t        add_imm;

    function new(string name="VX_fence_doa_seq");
        super.new(name);
    endfunction

    constraint store_imm_seq_c {
        st_src1_reg    == 1;
        st_src2_reg    == 2;
        ld_dst_reg     == 3;
        add_imm        == `IMM_HEX(a);
        load_store_imm == INSTR_SEG_SIZE;
    }
    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(st_src1_reg), MEM_LOAD_BOOT_ADDR,`RD(st_src1_reg))); 
        instr_queue.push_back(`SLLI(st_src1_reg,CL_BYTE_OFFSET_BITS,st_src1_reg));
        instr_queue.push_back(`LW(`RS1(st_src1_reg),load_store_imm,`RD(st_src2_reg)));
        instr_queue.push_back(`ADDI(`RS1(st_src2_reg), add_imm, `RD(st_src2_reg)));
        instr_queue.push_back(`SH(`RS1(st_src1_reg), `RS2(st_src2_reg), load_store_imm));
        instr_queue.push_back(`FENCE(0,0,0,0,0));
        instr_queue.push_back(`LB(`RS1(st_src1_reg),load_store_imm,`RD(ld_dst_reg)));
    endfunction
    
endclass