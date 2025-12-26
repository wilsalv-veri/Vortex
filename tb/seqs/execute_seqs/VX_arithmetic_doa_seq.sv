class VX_arithmetic_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_arithmetic_doa_seq)
    
    string message_id = "VX_ARITHMETIC_DOA_SEQ";
    rand risc_v_seq_reg_num_t src1_reg;
    rand risc_v_seq_reg_num_t src2_reg;
    rand risc_v_seq_reg_num_t dst_reg;
    rand arith_instr_type_t   arith_instr_type;

    function new(string name="VX_arithmetic_doa_seq");
        super.new(name);
        src1_reg  = 1;
        src2_reg  = 2;
        dst_reg   = 3;
        arith_instr_type = ADD;
    endfunction

    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(src1_reg),`IMM_HEX(5),`RD(src1_reg)));
        instr_queue.push_back(`ADDI(`RS1(src2_reg),`IMM_HEX(6),`RD(src2_reg)));
        instr_queue.push_back(`ADD(`RS1(src1_reg),`RS2(src2_reg), `RD(dst_reg)));
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
                if (r_seq_item.instr_name == "ADD")
                return q_idx;
            end             
        end
    
    endfunction

    virtual function void update_arith_instr(int arith_instr_idx);
        VX_risc_v_instr_seq_item instr_seq_item;
        VX_risc_v_Rtype_seq_item r_seq_item;
        risc_v_seq_funct7_t      funct7;
        risc_v_seq_funct3_t      funct3;
    
        instr_seq_item = instr_queue.get(arith_instr_idx);
        funct3         = VX_execute_pkg::get_arith_funct3(arith_instr_type.name());
        funct7         = VX_execute_pkg::get_arith_funct7(arith_instr_type.name());

        if ($cast(r_seq_item, instr_seq_item))begin
            r_seq_item.instr_name = arith_instr_type.name();
            r_seq_item.set_funct3(funct3);
            r_seq_item.set_funct7(funct7);
        end

    endfunction

endclass