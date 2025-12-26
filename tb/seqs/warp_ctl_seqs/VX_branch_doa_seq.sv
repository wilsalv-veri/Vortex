class VX_branch_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_branch_doa_seq)

    rand risc_v_seq_reg_num_t br_cmp_src1;
    rand risc_v_seq_reg_num_t br_cmp_src2;
    rand risc_v_seq_imm12_t   br_cmp_val1;
    rand risc_v_seq_imm12_t   br_cmp_val2;
    rand risc_v_seq_imm_t     branch_target;
    string message_id = "VX_BRANCH_DOA_SEQ";
         
    function new(string name="VX_branch_doa_seq");
        super.new(name);
        br_cmp_src1 = 1;
        br_cmp_src2 = 2;
        br_cmp_val1 = 1;
        br_cmp_val2 = br_cmp_val1; 
    endfunction

    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(br_cmp_src1),`IMM_BIN(br_cmp_val1),`RD(br_cmp_src1)));
        instr_queue.push_back(`ADDI(`RS1(br_cmp_src2),`IMM_BIN(br_cmp_val2),`RD(br_cmp_src2)));
        instr_queue.push_back(`BEQ(br_cmp_src1, br_cmp_src2, branch_target));
        instr_queue.push_back(`EBREAK); //INFINITE LOOP
    endfunction

    virtual function void post_add_instructions();
        set_branch_target("BEQ"); 
    endfunction

    virtual function void set_branch_target(string instr_name);
        int branch_instr_idx = get_branch_instruction_idx(instr_name);
        branch_target = risc_v_seq_instr_address_t'(4) * (instr_queue.size() - branch_instr_idx - 1);
        `VX_info(message_id, $sformatf("BRANCH TARGET: 0x%0h", branch_target))
        set_branch_target_imm(instr_name, branch_target);
    endfunction

    virtual function void set_branch_target_imm(string instr_name, risc_v_seq_imm_t imm);
        VX_risc_v_Btype_seq_item b_seq_item = VX_risc_v_Btype_seq_item::type_id::create("VX_risc_v_Btype_seq_item");
        VX_risc_v_instr_seq_item instr_seq_item;

        int branch_instr_idx = get_branch_instruction_idx(instr_name);
        instr_seq_item = instr_queue.get(branch_instr_idx);
        if ($cast(b_seq_item, instr_seq_item))begin
            b_seq_item.set_imm_field(imm); 
            instr_seq_item.raw_data = b_seq_item.raw_data;
        end
        else
            `VX_error(message_id, "Failed to cast BRANCH Instruction into B-TYPE")
    endfunction

    virtual function int get_branch_instruction_idx(string instr_name);
        VX_risc_v_Btype_seq_item b_seq_item  = VX_risc_v_Btype_seq_item::type_id::create("VX_risc_v_Btype_seq_item");
        VX_risc_v_instr_seq_item instr_seq_item;

        for(int q_idx=0; q_idx < instr_queue.size();q_idx++)begin
            instr_seq_item = instr_queue.get(q_idx);

            if ($cast(b_seq_item, instr_seq_item))begin
                if ((b_seq_item.instr_name == instr_name))
                return q_idx;
            end             
        end
        `VX_error(message_id, "Failed to find BRANCH Instruction In Queue")
    endfunction

endclass