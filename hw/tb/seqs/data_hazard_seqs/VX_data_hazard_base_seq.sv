class VX_data_hazard_base_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_data_hazard_base_seq)

    rand bit                  src_hazard;
    rand risc_v_seq_reg_num_t hazard_reg1;
    rand risc_v_seq_reg_num_t hazard_reg2;
    rand risc_v_seq_reg_num_t hazard_reg3;
    rand risc_v_seq_reg_num_t hazard_reg4;
    rand risc_v_seq_reg_num_t src1_reg;
    rand risc_v_seq_reg_num_t src2_reg;
    rand risc_v_seq_reg_num_t dst_reg;
    rand data_hazard_type_t   data_hazard_type;
    string message_id = "VX_DATA_HAZARD_BASE_SEQ";

    function new(string name="VX_raw_doa_seq");
        super.new(name);
        data_hazard_type = RAW;
        
        hazard_reg1 = 2;
        hazard_reg2 = hazard_reg1;
        hazard_reg3 = 1;
        hazard_reg4 = hazard_reg3;

        src1_reg    = hazard_reg4;
        src2_reg    = hazard_reg2;
        dst_reg     = src2_reg;
    endfunction

    virtual function void add_instructions();
        `VX_info(message_id, $sformatf("Hazard_Reg1: %0d Hazard_Reg2: %0d Hazard_Reg3: %0d Hazard_Reg4: %0d", 
        hazard_reg1, hazard_reg2,hazard_reg3,hazard_reg4))
        
        instr_queue.push_back(`ADDI(`RS1(hazard_reg1),`IMM_HEX(a),`RD(hazard_reg2)));
        instr_queue.push_back(`ADDI(`RS1(hazard_reg3),`IMM_HEX(b),`RD(hazard_reg4)));
        instr_queue.push_back(`ADD(`RS1(src1_reg),`RS2(src2_reg), `RD(dst_reg)));
    endfunction

endclass