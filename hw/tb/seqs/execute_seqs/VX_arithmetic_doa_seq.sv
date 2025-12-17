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

    /*
    function risc_v_seq_funct3_t get_arith_funct3(string arith_instr_name);
        risc_v_seq_funct3_t funct3;

        case(arith_instr_name)
            "ADD":    funct3 = `FUNCT3_WIDTH'b000;
            "SUB":    funct3 = `FUNCT3_WIDTH'b000;
            "SLL":    funct3 = `FUNCT3_WIDTH'b001;
            "SLT":    funct3 = `FUNCT3_WIDTH'b010;
            "SLTU":   funct3 = `FUNCT3_WIDTH'b011;
            "XOR":    funct3 = `FUNCT3_WIDTH'b100;
            "SRL":    funct3 = `FUNCT3_WIDTH'b101;
            "SRA":    funct3 = `FUNCT3_WIDTH'b101;
            "OR":     funct3 = `FUNCT3_WIDTH'b110;          
            "AND":    funct3 = `FUNCT3_WIDTH'b111;
            "MUL":    funct3 = `FUNCT3_WIDTH'b000;
            "MULH":   funct3 = `FUNCT3_WIDTH'b001;
            "MULHSU": funct3 = `FUNCT3_WIDTH'b010;
            "MULHU":  funct3 = `FUNCT3_WIDTH'b011;
            "DIV":    funct3 = `FUNCT3_WIDTH'b100;
            "DIVU":   funct3 = `FUNCT3_WIDTH'b101;
            "REM":    funct3 = `FUNCT3_WIDTH'b110;              
            "REMU":   funct3 = `FUNCT3_WIDTH'b111;
        endcase

        return funct3;
    endfunction

    function risc_v_seq_funct7_t get_arith_funct7(string arith_instr_name);
        risc_v_seq_funct7_t funct7;

        case(arith_instr_name)
            "ADD":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SUB":    funct7 = `FUNCT7_WIDTH'b0100000;
            "SLL":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SLT":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SLTU":   funct7 = `FUNCT7_WIDTH'b0000000;
            "XOR":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SRL":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SRA":    funct7 = `FUNCT7_WIDTH'b0100000;
            "OR":     funct7 = `FUNCT7_WIDTH'b0000000;          
            "AND":    funct7 = `FUNCT7_WIDTH'b0000000;
            "MUL":    funct7 = `FUNCT7_WIDTH'b0000001;
            "MULH":   funct7 = `FUNCT7_WIDTH'b0000001;
            "MULHSU": funct7 = `FUNCT7_WIDTH'b0000001;
            "MULHU":  funct7 = `FUNCT7_WIDTH'b0000001;
            "DIV":    funct7 = `FUNCT7_WIDTH'b0000001;
            "DIVU":   funct7 = `FUNCT7_WIDTH'b0000001;
            "REM":    funct7 = `FUNCT7_WIDTH'b0000001;              
            "REMU":   funct7 = `FUNCT7_WIDTH'b0000001;
        
        endcase
        
        return funct7;
    endfunction
    */

endclass