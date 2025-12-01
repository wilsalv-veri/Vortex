class VX_split_join_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_split_join_doa_seq)

    rand VX_tmask_t           pred_val;
    rand bit                  not_pred_val;
    rand risc_v_seq_imm_t     then_store_val;
    rand risc_v_seq_imm_t     else_store_val;
    rand risc_v_seq_imm_t     all_store_val;
    
    rand risc_v_seq_reg_num_t pred_reg;
    rand risc_v_seq_reg_num_t ipdom_stack_ptr_reg;
    rand risc_v_seq_reg_num_t then_val_reg;
    rand risc_v_seq_reg_num_t else_val_reg;
    rand risc_v_seq_reg_num_t all_val_reg;
    
    function new(string name="VX_split_join_doa_seq");
        super.new(name);
        pred_val            = 'b0011;
        not_pred_val        = 1'b0;
        then_store_val      = 'ha;
        else_store_val      = 'hb;
        all_store_val       = 'hc;

        pred_reg            = 2;
        ipdom_stack_ptr_reg = 3;
        then_val_reg        = 4;
        else_val_reg        = 5;
        all_val_reg         = 6;
    endfunction
     
    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(pred_reg),`IMM_BIN(pred_val),`RD(pred_reg)));
        instr_queue.push_back(`TMC(`RS1(pred_reg))); 
        instr_queue.push_back(`SPLIT(`RS1(pred_reg),`RS2(not_pred_val),`RD(ipdom_stack_ptr_reg)));
        instr_queue.push_back(`ADDI(`RS1(then_val_reg),`IMM_BIN(then_store_val),`RD(then_val_reg)));
        instr_queue.push_back(`JOIN(`RS1(ipdom_stack_ptr_reg)));
        instr_queue.push_back(`ADDI(`RS1(else_val_reg),`IMM_BIN(else_store_val),`RD(else_val_reg)));
        instr_queue.push_back(`JOIN(`RS1(ipdom_stack_ptr_reg)));
        instr_queue.push_back(`ADDI(`RS1(all_val_reg),`IMM_BIN(all_store_val),`RD(all_val_reg)));
    endfunction
    
endclass
