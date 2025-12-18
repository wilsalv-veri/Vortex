class VX_vote_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_vote_doa_seq)

    string message_id = "VX_VOTE_DOA_SEQ";

    rand vote_instr_type_t    vote_instr_type;
    rand risc_v_seq_reg_num_t first_tmask_reg;
    rand risc_v_seq_reg_num_t pred_val_reg;
    rand risc_v_seq_reg_num_t alternate_tmask_reg;
    rand risc_v_seq_reg_num_t vote_result_reg;
    
    rand risc_v_seq_imm_t     first_tmask; 
    rand risc_v_seq_imm_t     alternate_tmask;
  
    function new(string name="VX_vote_doa_seq");
        super.new(name);

        vote_instr_type     = VOTE_ANY;
        first_tmask_reg     = 1;
        pred_val_reg        = 2;
        alternate_tmask_reg = 3;
        vote_result_reg     = 4;

        first_tmask         = `IMM_HEX(a); 
        alternate_tmask     = `IMM_HEX(f); 
    endfunction

    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(first_tmask_reg),first_tmask,`RD(first_tmask_reg)));
        instr_queue.push_back(`TMC(`RS1(first_tmask_reg)));
        instr_queue.push_back(`ADDI(`RS1(pred_val_reg),`IMM_HEX(1),`RD(pred_val_reg))); //create pred
        instr_queue.push_back(`ADDI(`RS1(alternate_tmask_reg),alternate_tmask,`RD(alternate_tmask_reg))); //new tmask
        instr_queue.push_back(`TMC(`RS1(alternate_tmask_reg))); //with new tmask 
        instr_queue.push_back(`VOTE_ANY(`RS1(pred_val_reg),`RS2(0), `RD(vote_result_reg)));
    endfunction

    virtual function void post_add_instructions();
        int vote_instr_idx = get_vote_instruction_idx();
        update_vote_instr(vote_instr_idx);
    endfunction

    virtual function int get_vote_instruction_idx();
        VX_risc_v_Rtype_seq_item r_seq_item  = VX_risc_v_Rtype_seq_item::type_id::create("VX_risc_v_Rtype_seq_item");
        VX_risc_v_instr_seq_item instr_seq_item;

        for(int q_idx=0; q_idx < instr_queue.size();q_idx++)begin
            instr_seq_item = instr_queue.get(q_idx);

            if ($cast(r_seq_item, instr_seq_item))begin
                if (r_seq_item.instr_name == "VOTE_ANY")
                return q_idx;
            end             
        end
    
    endfunction

    virtual function void update_vote_instr(int vote_instr_idx);
        VX_risc_v_instr_seq_item instr_seq_item;
        VX_risc_v_Rtype_seq_item r_seq_item;
        risc_v_seq_funct3_t      funct3;
    
        instr_seq_item = instr_queue.get(vote_instr_idx);
        funct3         = VX_execute_pkg::get_vote_funct3(vote_instr_type.name());
       
        if ($cast(r_seq_item, instr_seq_item))begin
            r_seq_item.instr_name = vote_instr_type.name();
            r_seq_item.set_funct3(funct3);
        end

    endfunction

endclass