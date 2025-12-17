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
     
    risc_v_seq_instr_address_t pc;
    VX_wid_t                   wid;
    VX_seq_gpr_bank_num_t      rs1_bank_num, rs2_bank_num, rd_bank_num;
    VX_seq_gpr_bank_set_t      rs1_set_num, rs2_set_num, rd_set_num;
   
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
            
            case (instr_array[pc].instr_type)
                R_TYPE: begin
                    VX_risc_v_Rtype_seq_item r_item = VX_risc_v_Rtype_seq_item::create_instruction_with_data("R_TYPE_INST",instr_array[pc].raw_data);
                    set_r_item_gpr_lookup_fields(r_item);
                     
                    for(int tid=0; tid < `NUM_THREADS;  tid++)begin
                        operand1_data[tid]   = gpr_block[rs1_bank_num][rs1_set_num][tid];
                        operand2_data[tid]   = gpr_block[rs2_bank_num][rs2_set_num][tid];
                            
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
                        endcase

                        if (expected_result[tid] !== alu_info.data[tid])
                            `VX_error(message_id, $sformatf("ALU RESULT MISMATCH INSTR: %0s Exp_Res: 0x%0h Act_Res: 0x%0h TID: %0d", instr_array[pc].instr_name, expected_result[tid], alu_info.data[tid], tid))
                    end
                end
            endcase
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

endclass