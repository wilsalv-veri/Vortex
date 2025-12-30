class VX_pred_rtg_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_pred_rtg_seq)

    rand risc_v_seq_reg_num_t first_tmask_reg;
    rand risc_v_seq_reg_num_t pred_val_reg;
    rand risc_v_seq_reg_num_t else_tmask_reg;
    rand risc_v_seq_reg_num_t alternate_tmask_reg;
    
    rand risc_v_seq_imm_t first_tmask; 
    rand risc_v_seq_imm_t else_tmask;
    rand risc_v_seq_imm_t alternate_tmask;
    
    bit pred_value = 1'b1;
    rand bit take_then;
    rand bit is_neg;

    string message_id = "VX_PRED_SEQ";

    constraint pred_operands_c {
        take_then dist {0:= 30, 1:= 70};
        is_neg    dist {0:= 80, 1:= 20};

        unique {first_tmask_reg, pred_val_reg, else_tmask_reg, alternate_tmask_reg};
       
        first_tmask_reg      inside {[1:RV_REGS - 1]};
        pred_val_reg         inside {[2:RV_REGS - 1]};
        else_tmask_reg       inside {[2:RV_REGS - 1]};
        alternate_tmask_reg  inside {[2:RV_REGS - 1]};

        first_tmask inside {[0:15]};
        else_tmask inside {[0:15]};
        alternate_tmask inside {[0:15]};
    }

    function new(string name="VX_pred_rtg_seq");
        super.new(name);
        
        if (!this.randomize())
            `VX_error(message_id, "Failed to randomize VX_pred_seq")
        else
            `VX_info(message_id, $sformatf("TAKE_THEN: %0d IS_NEG: %0d FIRST_TMASK: 0x%0h ELSE_TMASK: 0x%0h ALTERNATE_TMASK: 0x%0h", 
            take_then,is_neg, first_tmask,else_tmask, alternate_tmask))
    endfunction

    virtual function void add_instructions();
        //Setup Instructions
        instr_queue.push_back(`ADDI(`RS1(first_tmask_reg),`IMM_BIN(first_tmask),`RD(first_tmask_reg)));
        instr_queue.push_back(`TMC(`RS1(first_tmask_reg)));
        
        if (take_then)
            instr_queue.push_back(`ADDI(`RS1(pred_val_reg),`IMM_BIN(pred_value),`RD(pred_val_reg))); //create pred
        
        instr_queue.push_back(`ADDI(`RS1(else_tmask_reg),`IMM_BIN(else_tmask),`RD(else_tmask_reg))); //else tmask
        instr_queue.push_back(`ADDI(`RS1(alternate_tmask_reg),`IMM_BIN(alternate_tmask),`RD(alternate_tmask_reg))); //new tmask
        instr_queue.push_back(`TMC(`RS1(alternate_tmask_reg))); //with new tmask 
      
        //Pred Instruction
        instr_queue.push_back(`PRED(`RS1(pred_val_reg),`RS2(else_tmask_reg), `RD(is_neg)));
        
    endfunction

endclass