class VX_load_imm_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_load_imm_doa_seq)

    string message_id = "VX_LOAD_IMM_DOA_SEQ";

    rand load_instr_type_t       ld_instr_type;
    rand risc_v_seq_reg_num_t    src1_reg;
    rand risc_v_seq_reg_num_t    dst_reg;
    rand risc_v_seq_imm_t        load_imm;

    function new(string name="VX_load_imm_doa_seq");
        super.new(name);
    endfunction

    constraint load_imm_seq_c {
        ld_instr_type == LB;
        src1_reg      == 1;
        dst_reg       == 2;
        load_imm      == INSTR_SEG_SIZE;
    }
    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(src1_reg), MEM_LOAD_BOOT_ADDR,`RD(src1_reg))); 
        instr_queue.push_back(`SLLI(src1_reg,CL_BYTE_OFFSET_BITS,src1_reg));
        instr_queue.push_back(`LB(`RS1(src1_reg),load_imm,`RD(dst_reg)));
    endfunction

     virtual function void post_add_instructions();
        int load_instr_idx = get_load_instruction_idx();
        update_load_instr(load_instr_idx);
    endfunction

    virtual function int get_load_instruction_idx();
        VX_risc_v_Itype_seq_item i_seq_item  = VX_risc_v_Itype_seq_item::type_id::create("VX_risc_v_Itype_seq_item");
        VX_risc_v_instr_seq_item instr_seq_item;

        for(int q_idx=0; q_idx < instr_queue.size();q_idx++)begin
            instr_seq_item = instr_queue.get(q_idx);

            if ($cast(i_seq_item, instr_seq_item))begin
                if (i_seq_item.instr_name == "LB")
                return q_idx;
            end             
        end
    
    endfunction

    virtual function void update_load_instr(int load_instr_idx);
        VX_risc_v_instr_seq_item instr_seq_item;
        VX_risc_v_Itype_seq_item i_seq_item;
        risc_v_seq_funct3_t      funct3;
    
        instr_seq_item = instr_queue.get(load_instr_idx);
        funct3         = VX_execute_pkg::get_load_funct3(ld_instr_type.name());
       
        if ($cast(i_seq_item, instr_seq_item))begin
            i_seq_item.instr_name = ld_instr_type.name();
            i_seq_item.set_funct3(funct3);
        end
    endfunction

endclass