class VX_alu_scbd extends uvm_scoreboard;

    `uvm_component_utils(VX_alu_scbd)
    
    string message_id = "VX_ALU_SCBD";

    `uvm_analysis_imp_decl (_alu_instr)
    uvm_analysis_imp_alu_instr #(VX_risc_v_instr_seq_item, VX_alu_scbd) receive_riscv_instr;

    `uvm_analysis_imp_decl(_alu_info)
    uvm_analysis_imp_alu_info #(VX_alu_tb_txn_item, VX_alu_scbd) receive_alu_info;

    uvm_tlm_analysis_fifo #(VX_gpr_tb_txn_item) gpr_tb_fifo;
    VX_gpr_tb_txn_item                          gpr_info;
    VX_gpr_seq_block_t                          gpr_block;
    VX_gpr_seq_data_entry_t                     operand1_data; 
    VX_gpr_seq_data_entry_t                     operand2_data;;
    VX_gpr_seq_data_entry_t                     expected_result;
    
    VX_risc_v_instr_seq_item                    instr_array[integer]; 
    VX_alu_tb_txn_item                          alu_info;
     
    risc_v_seq_instr_address_t                  pc;
    VX_wid_t                                    wid;
    VX_seq_gpr_bank_num_t                       rs1_bank_num, rs2_bank_num, rd_bank_num;
    VX_seq_gpr_bank_set_t                       rs1_set_num, rs2_set_num, rd_set_num;
    risc_v_seq_imm_t                            imm;

    VX_tid_t                                    vote_count;
    VX_tmask_t                                  vote_mask;
    VX_seq_gpr_t                                vote_all_result;
    VX_seq_gpr_t                                vote_none_result;

    VX_tid_t                                    shfl_bval;
    VX_tid_t                                    shfl_cval;
    VX_tid_t                                    shfl_mask;
    VX_tid_t                                    shfl_minLane;
    VX_tid_t                                    shfl_maxLane;
    VX_tid_t                                    shfl_lane;
    bit                                         shfl_instr;

    function new(string name="VX_alu_scbd", uvm_component parent=null);
        super.new(name,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        receive_riscv_instr = new("ALU_SCBD_RECEIVE_RISCV_INSTR", this);
        receive_alu_info = new("RECEIVE_ALU_INFO", this);
        gpr_tb_fifo      = new("ALU_SCBD_GPR_TB_FIFO", this);

    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            gpr_tb_fifo.get(gpr_info);
            write_gpr_info(gpr_info);
        end
    endtask

    virtual function void write_alu_instr(VX_risc_v_instr_seq_item instr);
        instr_array[instr.address] = instr;
        `VX_info(message_id, $sformatf("Instruction Received Address: 0x%0h Name:%0s Type:%0s RAW_DATA: 0x%0h", instr.address, instr.instr_name, instr.instr_type.name(), instr.raw_data))
    endfunction

    virtual function void write_gpr_info(VX_gpr_tb_txn_item gpr_info);
        write_gpr_entry(gpr_info, gpr_block);
        `VX_info(message_id, $sformatf("GPR Info Received BYTEEN: 0x%0h BANK_NUM: %0d SET: %0d DATA_ENTRY: 0x%0x", gpr_info.byteen,  gpr_info.bank_num, gpr_info.bank_set, gpr_info.gpr_data_entry))
    endfunction

    function void write_alu_info(VX_alu_tb_txn_item alu_info);
        this.alu_info = alu_info;
        check_alu_result();
    endfunction

    function void check_alu_result();
        pc  = alu_info.pc;
        wid = alu_info.wid;
       
        if (instr_array.exists(pc)) begin
            
            vote_count = 0;
            shfl_instr = 0;

            for(int tid=0; tid < `NUM_THREADS;  tid++)begin
                
                expected_result[tid] = alu_info.data[tid];

                case (instr_array[pc].instr_type)
                    R_TYPE: begin
                        VX_risc_v_Rtype_seq_item r_item = VX_risc_v_Rtype_seq_item::create_instruction_with_data("R_TYPE_INST",instr_array[pc].raw_data);
                        set_r_item_gpr_lookup_fields(r_item);
                        
                        operand1_data[tid]   = gpr_block[rs1_bank_num][rs1_set_num][tid];
                        operand2_data[tid]   = gpr_block[rs2_bank_num][rs2_set_num][tid];
                        
                        shfl_bval            = {operand2_data[tid][1],operand2_data[tid][0]}[BVAL_START + NUM_ALU_BITS - 1 : BVAL_START];
                        shfl_cval            = {operand2_data[tid][1],operand2_data[tid][0]}[CVAL_START + NUM_ALU_BITS - 1 : CVAL_START];
                        shfl_mask            = {operand2_data[tid][1],operand2_data[tid][0]}[MASK_START + NUM_ALU_BITS - 1 : MASK_START];
                        
                        shfl_minLane         = shfl_mask;
                        shfl_maxLane         = shfl_mask + shfl_cval < `NUM_ALU_LANES ? shfl_mask + shfl_cval : `NUM_ALU_LANES - 1;

                        case(instr_array[pc].instr_name)
                            "ADD":    expected_result[tid] = operand1_data[tid] + operand2_data[tid];
                            "SUB":    expected_result[tid] = operand1_data[tid] - operand2_data[tid];
                            "SLL":    expected_result[tid] = operand1_data[tid] << operand2_data[tid]; 
                            "SLT":    expected_result[tid] = $signed(operand1_data[tid]) < $signed(operand2_data[tid]);   
                            "SLTU":   expected_result[tid] = operand1_data[tid] < operand2_data[tid];   
                            "XOR":    expected_result[tid] = operand1_data[tid] ^ operand2_data[tid]; 
                            "SRL":    expected_result[tid] = operand1_data[tid] >> operand2_data[tid];  
                            "SRA":    expected_result[tid] = $signed(operand1_data[tid]) >>> operand2_data[tid];  
                            "OR" :    expected_result[tid] = operand1_data[tid] | operand2_data[tid]; 
                            "AND":    expected_result[tid] = operand1_data[tid] & operand2_data[tid]; 
                            "MUL":    expected_result[tid] = operand1_data[tid] * operand2_data[tid];  
                            "MULH":   expected_result[tid] = ($signed(operand1_data[tid]) * $signed(operand2_data[tid])) >> `GPR_DATA_WIDTH;
                            "MULHSU": expected_result[tid] = ($signed(operand1_data[tid]) * operand2_data[tid]) >> `GPR_DATA_WIDTH;
                            "MULHU":  expected_result[tid] = (operand1_data[tid] * operand2_data[tid]) >> `GPR_DATA_WIDTH; 
                            "DIV":    expected_result[tid] = $signed(operand2_data[tid]) != 0 ? $signed(operand1_data[tid]) / $signed(operand2_data[tid]) : -1; 
                            "DIVU":   expected_result[tid] = operand2_data[tid] != 0 ? operand1_data[tid]  / operand2_data[tid] : -1;
                            "REM":    expected_result[tid] = $signed(operand2_data[tid]) != 0 ? $signed(operand1_data[tid]) % $signed(operand2_data[tid]) : operand1_data[tid];
                            "REMU":   expected_result[tid] = operand2_data[tid] != 0 ? operand1_data[tid] % operand2_data[tid] : operand1_data[tid];
                        
                            //Vote Instructions
                            "VOTE_ALL":begin
                                vote_count += operand1_data[tid][0];
                                vote_mask[tid] = operand1_data[tid][0][0];
                            end
                            "VOTE_ANY":begin
                                vote_count += operand1_data[tid][0];
                                vote_mask[tid] = operand1_data[tid][0][0];
                            end
                            "VOTE_UNI":begin
                                vote_count += operand1_data[tid][0];
                                vote_mask[tid] = operand1_data[tid][0][0];
                            end
                            "VOTE_BAL": begin
                                vote_count += operand1_data[tid][0];
                                vote_mask[tid] = operand1_data[tid][0][0];
                            end

                            //SHFL Instructions
                            "SHFL_UP":begin
                                shfl_instr = 1;
                                shfl_lane  = (tid - shfl_bval);
                            end
                            "SHFL_DOWN":begin
                                shfl_instr  = 1;
                                shfl_lane   = (tid + shfl_bval);
                             
                            end
                            "SHFL_IDX":begin
                                shfl_instr  = 1;
                                shfl_lane   = shfl_bval;
                            end
                            "SHFL_BFLY":begin
                                shfl_instr  = 1;
                                shfl_lane   = tid ^ shfl_bval;
                            end
                        endcase
                        
                        if (shfl_instr)begin
                            shfl_instr = 0;
                            
                            if ((shfl_lane >= shfl_minLane) && (shfl_lane <= shfl_maxLane))
                                expected_result[tid] = gpr_block[rs1_bank_num][rs1_set_num][shfl_lane];
                            else
                                expected_result[tid] = operand1_data[tid];
                        end
                    end
                    
                    I_TYPE: begin
                        VX_risc_v_Itype_seq_item i_item = VX_risc_v_Itype_seq_item::create_instruction_with_data("I_TYPE_INST",instr_array[pc].raw_data);
                        set_i_item_gpr_lookup_fields(i_item);
                        imm = `SEXT(`XLEN,i_item.imm);

                        operand1_data[tid]   = gpr_block[rs1_bank_num][rs1_set_num][tid];
                                
                        case(instr_array[pc].instr_name)
                            "ADDI":    expected_result[tid] = operand1_data[tid] + imm;
                            "SLTI":    expected_result[tid] = operand1_data[tid] < $signed(imm);
                            "SLTIU":   expected_result[tid] = operand1_data[tid] < imm;
                            "XORI":    expected_result[tid] = operand1_data[tid] ^ imm;
                            "ORI":     expected_result[tid] = operand1_data[tid] | imm;   
                            "ANDI":    expected_result[tid] = operand1_data[tid] & imm;
                            "SLLI":    expected_result[tid] = operand1_data[tid] << imm;
                            "SRLI":    expected_result[tid] = operand1_data[tid] >> imm;
                            "SRAI":    expected_result[tid] = operand1_data[tid] >>> imm;
                        endcase

                    end
                endcase

                if (alu_info.tmask[tid]) begin
                    if (expected_result[tid] !== alu_info.data[tid])
                        `VX_error(message_id, $sformatf("ALU RESULT MISMATCH PC: 0x%0h INSTR: %0s Exp_Res: 0x%0h Act_Res: 0x%0h TID: %0d", pc, instr_array[pc].instr_name, expected_result[tid], alu_info.data[tid], tid))
                end
            end

            for(int tid=0; tid < `NUM_THREADS;  tid++)begin
                
                vote_all_result[tid]  = vote_count == $countones(alu_info.tmask);
                vote_none_result[tid] = vote_count == 0;

                if (alu_info.tmask[tid]) begin
                    case(instr_array[pc].instr_name)
                        "VOTE_ALL": expected_result[tid] = VX_gpr_seq_data_entry_t'(vote_all_result);
                        "VOTE_ANY": expected_result[tid] = vote_count > 0;
                        "VOTE_UNI": expected_result[tid] = vote_all_result || vote_none_result;
                        "VOTE_BAL": expected_result[tid] = VX_gpr_seq_data_entry_t'(vote_mask);
                    endcase
                end
                
            end
                      
        end
        
    endfunction

    virtual function void  set_r_item_gpr_lookup_fields( VX_risc_v_Rtype_seq_item r_item);
        set_r_item_gpr_lookup_bank_nums(r_item);
        set_r_item_gpr_lookup_set_nums(r_item);
    endfunction   
   
    virtual function void set_r_item_gpr_lookup_bank_nums(VX_risc_v_Rtype_seq_item r_item);
        rs1_bank_num = `REG_NUM_TO_BANK(r_item.rs1);
        rs2_bank_num = `REG_NUM_TO_BANK(r_item.rs2);
        rd_bank_num  = `REG_NUM_TO_BANK(r_item.rd);
    endfunction

    virtual function void set_r_item_gpr_lookup_set_nums(VX_risc_v_Rtype_seq_item r_item);
      rs1_set_num  = `REG_NUM_TO_SET(wid,r_item.rs1);
      rs2_set_num  = `REG_NUM_TO_SET(wid,r_item.rs2);
      rd_set_num   = `REG_NUM_TO_SET(wid,r_item.rd);
    endfunction

    virtual function void  set_i_item_gpr_lookup_fields( VX_risc_v_Itype_seq_item i_item);
        set_i_item_gpr_lookup_bank_nums(i_item);
        set_i_item_gpr_lookup_set_nums(i_item);
    endfunction   
   
    virtual function void set_i_item_gpr_lookup_bank_nums(VX_risc_v_Itype_seq_item i_item);
        rs1_bank_num = `REG_NUM_TO_BANK(i_item.rs1);
        rd_bank_num  = `REG_NUM_TO_BANK(i_item.rd);
    endfunction

    virtual function void set_i_item_gpr_lookup_set_nums(VX_risc_v_Itype_seq_item i_item);
      rs1_set_num  = `REG_NUM_TO_SET(wid,i_item.rs1);
      rd_set_num   = `REG_NUM_TO_SET(wid,i_item.rd);
    endfunction

endclass