class VX_pred_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_pred_doa_seq)

    risc_v_seq_reg_num_t first_tmask_reg;
    risc_v_seq_reg_num_t pred_val_reg;
    risc_v_seq_reg_num_t else_tmask_reg;
    risc_v_seq_reg_num_t alternate_tmask_reg;
    
    risc_v_seq_imm_t first_tmask; 
    risc_v_seq_imm_t else_tmask;
    risc_v_seq_imm_t alternate_tmask;
  
    function new(string name="VX_pred_doa_seq");
        super.new(name);
        
        first_tmask_reg     = 1;
        pred_val_reg        = 2;
        else_tmask_reg      = 3;
        alternate_tmask_reg = 4;

        first_tmask         = `IMM_HEX(a); 
        else_tmask          = `IMM_HEX(5);
        alternate_tmask     = `IMM_HEX(f);
    endfunction

    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(first_tmask_reg),first_tmask,`RD(first_tmask_reg)));
        instr_queue.push_back(`TMC(`RS1(first_tmask_reg)));
        instr_queue.push_back(`ADDI(`RS1(pred_val_reg),`IMM_HEX(1),`RD(pred_val_reg))); //create pred
        instr_queue.push_back(`ADDI(`RS1(else_tmask_reg),else_tmask,`RD(else_tmask_reg))); //else tmask
        instr_queue.push_back(`ADDI(`RS1(alternate_tmask_reg),alternate_tmask,`RD(alternate_tmask_reg))); //new tmask
        instr_queue.push_back(`TMC(`RS1(alternate_tmask_reg))); //with new tmask 
        instr_queue.push_back(`PRED(`RS1(pred_val_reg),`RS2(else_tmask_reg), `RD(0)));
    endfunction

endclass