class VX_store_imm_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_store_imm_doa_seq)

    string message_id = "VX_LOAD_IMM_DOA_SEQ";

    rand store_instr_type_t      st_instr_type;
    rand risc_v_seq_reg_num_t    st_src1_reg;
    rand risc_v_seq_reg_num_t    st_src2_reg;
    rand risc_v_seq_reg_num_t    ld_dst_reg;
    rand risc_v_seq_imm_t        load_store_imm;
    rand risc_v_seq_imm_t        add_imm;

    function new(string name="VX_store_imm_doa_seq");
        super.new(name);
    endfunction

    constraint store_imm_seq_c {
        st_instr_type  == SB;
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
        instr_queue.push_back(`SB(`RS1(st_src1_reg), `RS2(st_src2_reg), load_store_imm));
        instr_queue.push_back(`LB(`RS1(st_src1_reg),load_store_imm,`RD(ld_dst_reg)));
    endfunction

    virtual function void post_add_instructions();
        int store_instr_idx = get_store_instruction_idx();
        update_store_instr(store_instr_idx);
    endfunction

    virtual function int get_store_instruction_idx();
        VX_risc_v_Stype_seq_item s_seq_item  = VX_risc_v_Stype_seq_item::type_id::create("VX_risc_v_Stype_seq_item");
        VX_risc_v_instr_seq_item instr_seq_item;

        for(int q_idx=0; q_idx < instr_queue.size();q_idx++)begin
            instr_seq_item = instr_queue.get(q_idx);

            if ($cast(s_seq_item, instr_seq_item))begin
                if (s_seq_item.instr_name == "SB")
                    return q_idx;
            end             
        end
    
    endfunction

    virtual function void update_store_instr(int store_instr_idx);
        VX_risc_v_instr_seq_item instr_seq_item;
        VX_risc_v_Stype_seq_item s_seq_item;
        risc_v_seq_funct3_t      funct3;
    
        instr_seq_item = instr_queue.get(store_instr_idx);
        funct3         = VX_execute_pkg::get_store_funct3(st_instr_type.name());
       
        if ($cast(s_seq_item, instr_seq_item))begin
            s_seq_item.instr_name = st_instr_type.name();  
            s_seq_item.set_funct3(funct3);
        end
       
    endfunction

endclass