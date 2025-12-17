class VX_arithmetic_imm_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_arithmetic_imm_doa_seq)
    
    string message_id = "VX_ARITHMETIC_IMM_DOA_SEQ";
    rand risc_v_seq_reg_num_t     src1_reg;
    rand risc_v_seq_imm_t         src1_val;
    rand risc_v_seq_imm_t         imm;
    rand risc_v_seq_reg_num_t     dst_reg;
    rand arith_instr_imm_type_t   arith_imm_instr_type;

    function new(string name="VX_arithmetic_doa_seq");
        super.new(name);
        src1_reg  = 1;
        src1_val  = risc_v_seq_imm_t'(4);
        imm       = risc_v_seq_imm_t'(16);
        dst_reg   = 3;
        arith_imm_instr_type = ADDI;
    endfunction

    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(src1_reg),`IMM_BIN(src1_val),`RD(src1_reg)));
        instr_queue.push_back(`ADDI(`RS1(dst_reg), `IMM_HEX(a),       `RD(dst_reg)));
        instr_queue.push_back(`ANDI(`RS1(src1_reg),`IMM_BIN(imm),     `RD(dst_reg)));
    endfunction

    virtual function void post_add_instructions();
        int arith_instr_idx = get_arith_instruction_idx();
        update_arith_instr(arith_instr_idx);
    endfunction

    virtual function int get_arith_instruction_idx();
        VX_risc_v_Rtype_seq_item r_seq_item  = VX_risc_v_Rtype_seq_item::type_id::create("VX_risc_v_Rtype_seq_item");
        VX_risc_v_instr_seq_item instr_seq_item;

        for(int q_idx=0; q_idx < instr_queue.size();q_idx++)begin
            instr_seq_item = instr_queue.get(q_idx);

            if ($cast(r_seq_item, instr_seq_item))begin
                if (r_seq_item.instr_name == "ANDI")
                return q_idx;
            end             
        end
    
    endfunction

    virtual function void update_arith_instr(int arith_instr_idx);
        VX_risc_v_instr_seq_item instr_seq_item;
        VX_risc_v_Itype_seq_item i_seq_item;
        risc_v_seq_funct3_t      funct3;
        
        instr_seq_item = instr_queue.get(arith_instr_idx);
        funct3         = VX_execute_pkg::get_arith_imm_funct3(arith_imm_instr_type.name());
       
        if ($cast(i_seq_item, instr_seq_item))begin
            i_seq_item.instr_name = arith_imm_instr_type.name();
            i_seq_item.set_funct3(funct3);

            case(arith_imm_instr_type.name())
                "SLLI","SRLI","SRAI": begin
                    i_seq_item.set_imm_field ({27'd0, imm[`I_TYPE_SHIFT_IMM_WIDTH - 1:0]});
                end
            endcase
        end

    endfunction

endclass