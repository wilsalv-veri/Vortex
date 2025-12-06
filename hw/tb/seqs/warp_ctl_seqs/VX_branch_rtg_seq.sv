class VX_branch_rtg_seq extends VX_branch_doa_seq;

    `uvm_object_utils(VX_branch_rtg_seq)
    
    rand br_instr_type_t br_instr_type;
    rand bit taken;
    rand bit pos_only;
    rand bit neg_only;
   
    function new(string name="VX_branch_rtg_seq");
        super.new(name);
        message_id = "VX_BRANCH_RTG_SEQ";

        if (! this.randomize())
            `VX_error(message_id, "Failed to randomize VX_branch_rtg_seq")
        else begin
            `VX_info(message_id, $sformatf("BRANCH Instruction Picked : %0s Taken: %0d VAL1: 0x%0h VAL2: 0x%0h", br_instr_type.name, taken, br_cmp_val1,br_cmp_val2 ))
        end
    endfunction

    constraint branch_reg_seq_c {
        solve taken before br_instr_type;
        solve pos_only before br_cmp_val1, br_cmp_val2;
        taken   dist {0:=90, 1:=10};
        unique {br_cmp_src1, br_cmp_src2};
        br_cmp_src1 inside {[1:31]};
        br_cmp_src2 inside {[1:31]};

        if (taken){
            if (br_instr_type == BEQ){
                br_cmp_val1 ==  br_cmp_val2;
            }
            else if (br_instr_type == BNE){
                br_cmp_val1 !=  br_cmp_val2;
            }
            else if (br_instr_type == BLTU){
                br_cmp_val1 <  br_cmp_val2;
            }
            else if (br_instr_type == BGEU){
                br_cmp_val1 >  br_cmp_val2;
            }    
            
            else if (br_instr_type == BLT){    
                br_cmp_val1[`IMM_11-1:0] < br_cmp_val2[`IMM_11-1:0];

                if (pos_only){
                    br_cmp_val1[`IMM_11]  == 0;
                    br_cmp_val2[`IMM_11]  == 0;
                }
                else if (neg_only){
                    br_cmp_val1[`IMM_11]  == 1;
                    br_cmp_val2[`IMM_11]  == 1;
                }
                else {
                    br_cmp_val1[`IMM_11] == 1;
                    br_cmp_val1[`IMM_11] == 0;
                }
            }  
            else if (br_instr_type == BGE){
                br_cmp_val1[`IMM_11-1:0] > br_cmp_val2[`IMM_11-1:0];

                if (pos_only){
                    br_cmp_val1[`IMM_11]  == 0;
                    br_cmp_val2[`IMM_11]  == 0;
                }
                else if (neg_only){
                    br_cmp_val1[`IMM_11]  == 1;
                    br_cmp_val2[`IMM_11]  == 1;
                }
                else {
                    br_cmp_val1[`IMM_11] == 0;
                    br_cmp_val1[`IMM_11] == 1;
                }
            }
            
        }
        else {

            if (br_instr_type == BEQ){
                br_cmp_val1 !=  br_cmp_val2;
            }
            else if (br_instr_type == BNE){
                br_cmp_val1 ==  br_cmp_val2;
            }
            else if (br_instr_type == BLTU){
                br_cmp_val1 >  br_cmp_val2;
            }
            else if (br_instr_type == BGEU){
                br_cmp_val1 <  br_cmp_val2;
            }
            else if (br_instr_type == BLT){  
                br_cmp_val1[`IMM_11-1:0] > br_cmp_val2[`IMM_11-1:0];

                if (pos_only){
                    br_cmp_val1[`IMM_11]  == 0;
                    br_cmp_val2[`IMM_11]  == 0;
                }
                else if (neg_only){
                    br_cmp_val1[`IMM_11]  == 1;
                    br_cmp_val2[`IMM_11]  == 1;
                }
                else {
                    br_cmp_val1[`IMM_11] == 0;
                    br_cmp_val1[`IMM_11] == 1;
                }
            }  
            else if (br_instr_type == BGE){
                br_cmp_val1[`IMM_11-1:0] < br_cmp_val2[`IMM_11-1:0];

                if (pos_only){
                    br_cmp_val1[`IMM_11]  == 0;
                    br_cmp_val2[`IMM_11]  == 0;
                }
                else if (neg_only){
                    br_cmp_val1[`IMM_11]  == 1;
                    br_cmp_val2[`IMM_11]  == 1;
                }
                else {
                    br_cmp_val1[`IMM_11] == 1;
                    br_cmp_val1[`IMM_11] == 0;
                }
            }
        }
    }

    virtual function void post_add_instructions();
        int branch_instr_idx           = get_branch_instruction_idx("BEQ"); //doa seq has BEQ instr
        
        modify_br_instr(br_instr_type.name(), branch_instr_idx);
        set_branch_target(br_instr_type.name());
        modify_ebreak_instr("ECALL", branch_instr_idx + 1);
    endfunction

    virtual function modify_ebreak_instr(string instr_name, int instr_idx);
        VX_risc_v_instr_seq_item instr_item;
        VX_risc_v_Itype_seq_item i_item;
        
        instr_item = instr_queue.get(instr_idx);
        instr_item.instr_name = instr_name;

        if ($cast(i_item, instr_item))
            i_item.set_imm_field(0);
        else
            `VX_error(message_id, "Failed to cast instruction into I-TYPE")
    
    endfunction
    virtual function modify_br_instr(string instr_name, int instr_idx);
        VX_risc_v_instr_seq_item instr_item;
        VX_risc_v_Btype_seq_item b_item;
        risc_v_seq_funct3_t br_funct3  = get_br_funct3(br_instr_type.name());
        
        instr_item = instr_queue.get(instr_idx);
        instr_item.instr_name = instr_name;

        if ($cast(b_item, instr_item))
            b_item.set_funct3_field(br_funct3);
        else
            `VX_error(message_id, "Failed to cast instruction into B-TYPE")
    endfunction

    virtual function risc_v_seq_funct3_t get_br_funct3(string instr_name);
        case(instr_name)
            "BEQ" : get_br_funct3 =  `FUNCT3_WIDTH'b000;
            "BNE" : get_br_funct3 =  `FUNCT3_WIDTH'b001;
            "BLT" : get_br_funct3 =  `FUNCT3_WIDTH'b100;
            "BGE" : get_br_funct3 =  `FUNCT3_WIDTH'b101;
            "BLTU": get_br_funct3 =  `FUNCT3_WIDTH'b110;
            "BGEU": get_br_funct3 =  `FUNCT3_WIDTH'b111;
        endcase
    endfunction

endclass