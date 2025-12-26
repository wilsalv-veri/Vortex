class VX_shfl_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_shfl_doa_seq)

    string message_id = "VX_SHFL_DOA_SEQ";

    rand shfl_instr_type_t    shfl_instr_type;
    rand risc_v_seq_reg_num_t tmask_reg;
    rand risc_v_seq_reg_num_t pred_val_reg;
    rand risc_v_seq_reg_num_t shfl_lane_reg;
         VX_shift_imm_t       shift_imm;
    
    rand risc_v_seq_reg_num_t shfl_result_reg;
    
    rand VX_tmask_t           tmask;
    rand risc_v_seq_imm_t     tmask_val; 
    rand risc_v_seq_imm_t     shfl_lane_val;
    
    rand VX_tid_t             shfl_bval;
    rand VX_tid_t             shfl_cval;
    rand VX_tid_t             shfl_mask;
    
    function new(string name="VX_shfl_doa_seq");
        super.new(name);
        
        shfl_instr_type     = SHFL_UP;
        tmask_reg           = 1;
        pred_val_reg        = 2;
        shfl_lane_reg       = 3;
        shfl_result_reg     = 5;

        tmask               = VX_tmask_t'('hf);
        tmask_val           =  `IMM_HEX(1); 
        shift_imm           = VX_shift_imm_t'(VX_execute_pkg::SHFL_OP_WIDTH);
    
        shfl_bval           = VX_tid_t'(1);
        shfl_cval           = VX_tid_t'(3);
        shfl_mask           = VX_tid_t'(0);
    endfunction

    virtual function void pre_add_instructions();
        shfl_lane_val[VX_execute_pkg::BVAL_START + 1: VX_execute_pkg::BVAL_START] = shfl_cval;
        shfl_lane_val[VX_execute_pkg::CVAL_START + 1: VX_execute_pkg::CVAL_START] = shfl_mask;
    endfunction

    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(pred_val_reg),`IMM_HEX(2),`RD(pred_val_reg))); 
        
        for(int tid=1; tid < `NUM_THREADS; tid++) begin
            tmask_val = (tmask_val << 1) | `IMM_HEX(1);
            instr_queue.push_back(`ADDI(`RS1(0),tmask_val,`RD(tmask_reg)));     
            
            if (tmask[tid])begin
                instr_queue.push_back(`TMC(`RS1(tmask_reg)));
                instr_queue.push_back(`ADDI(`RS1(pred_val_reg),`IMM_HEX(2),`RD(pred_val_reg))); 
            end
        end
        
        instr_queue.push_back(`ADDI(`RS1(shfl_lane_reg),shfl_lane_val,`RD(shfl_lane_reg))); 
        instr_queue.push_back(`SLLI(`RS1(shfl_lane_reg), shift_imm, `RD(shfl_lane_reg)));
        instr_queue.push_back(`ADDI(`RS1(shfl_lane_reg),`IMM_BIN(shfl_bval),`RD(shfl_lane_reg))); 
        instr_queue.push_back(`SHFL_UP(`RS1(pred_val_reg),`RS2(shfl_lane_reg), `RD(shfl_result_reg)));
    endfunction

    virtual function void post_add_instructions();
        int shfl_instr_idx = get_shfl_instruction_idx();
        update_shfl_instr(shfl_instr_idx);
    endfunction

    virtual function int get_shfl_instruction_idx();
        VX_risc_v_Rtype_seq_item r_seq_item  = VX_risc_v_Rtype_seq_item::type_id::create("VX_risc_v_Rtype_seq_item");
        VX_risc_v_instr_seq_item instr_seq_item;

        for(int q_idx=0; q_idx < instr_queue.size();q_idx++)begin
            instr_seq_item = instr_queue.get(q_idx);

            if ($cast(r_seq_item, instr_seq_item))begin
                if (r_seq_item.instr_name == "SHFL_UP")
                return q_idx;
            end             
        end
    
    endfunction

    virtual function void update_shfl_instr(int shfl_instr_idx);
        VX_risc_v_instr_seq_item instr_seq_item;
        VX_risc_v_Rtype_seq_item r_seq_item;
        risc_v_seq_funct3_t      funct3;
    
        instr_seq_item = instr_queue.get(shfl_instr_idx);
        funct3         = VX_execute_pkg::get_vote_funct3(shfl_instr_type.name());
       
        if ($cast(r_seq_item, instr_seq_item))begin
            r_seq_item.instr_name = shfl_instr_type.name();
            r_seq_item.set_funct3(funct3);
        end

    endfunction

endclass