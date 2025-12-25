class VX_lsu_scbd extends uvm_scoreboard;

    `uvm_component_utils(VX_lsu_scbd)

    string message_id = "VX_LSU_SCBD";
    VX_lsu_tb_txn_item                                                  lsu_info[`SOCKET_SIZE];
    VX_commit_tb_txn_item                                               commit_info[`SOCKET_SIZE];
    
    VX_lsu_tb_txn_item                                                  lsu_info_item;
    VX_commit_tb_txn_item                                               commit_info_item;

    VX_risc_v_instr_seq_item                                            instr_array[integer]; 
    
    `uvm_analysis_imp_decl (_lsu_instr)
    uvm_analysis_imp_lsu_instr #(VX_risc_v_instr_seq_item, VX_lsu_scbd) receive_riscv_instr;
   
    uvm_tlm_analysis_fifo #(VX_lsu_tb_txn_item)                         lsu_tb_fifo;
    uvm_tlm_analysis_fifo #(VX_commit_tb_txn_item)                      commit_tb_fifo;

    VX_core_id_t                                                        core_id;
    risc_v_seq_instr_address_t                                          pc;
    risc_v_seq_instr_address_t                                          fence_pc;
    VX_wid_t                                                            wid;
   
    uvm_tlm_analysis_fifo #(VX_gpr_tb_txn_item)                         gpr_tb_fifo;
    VX_gpr_tb_txn_item                                                  gpr_info;
    VX_gpr_seq_block_t                                                  gpr_block[`SOCKET_SIZE];
    VX_gpr_seq_data_entry_t                                             operand1_data; 
    VX_gpr_seq_data_entry_t                                             operand2_data; 
    VX_gpr_seq_data_entry_t                                             expected_result;
    VX_lsu_req_byteen_t                                                 expected_byteen;
    
    VX_seq_gpr_bank_num_t                                               rs1_bank_num, rs2_bank_num, rd_bank_num;
    VX_seq_gpr_bank_set_t                                               rs1_set_num, rs2_set_num, rd_set_num;
    risc_v_seq_imm_t                                                    imm;

    VX_seq_gpr_byte_t                                                   gpr_byte;
    VX_seq_gpr_half_w_t                                                 gpr_half_w;
    VX_seq_gpr_word_t                                                   gpr_word;
  
    function new(string name="VX_lsu_scbd", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        receive_riscv_instr = new("LSU_SCBD_RECEIVE_RISCV_INSTR", this);
        lsu_tb_fifo         = new("LSU_SCBD_LSU_TB_FIFO", this);
        commit_tb_fifo      = new("LSU_SCBD_COMMIT_TB_FIFO", this);
        gpr_tb_fifo         = new("LSU_SCBD_GPR_TB_FIFO", this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);
        
        fork 
            forever begin
                gpr_tb_fifo.get(gpr_info);
                write_gpr_info(gpr_info);
            end

            forever begin
                lsu_tb_fifo.get(lsu_info_item);
                write_lsu_info(lsu_info_item);
            end

            forever begin
                commit_tb_fifo.get(commit_info_item);
                write_commit_info(commit_info_item);
            end
        join_none
    endtask

    virtual function void write_gpr_info(VX_gpr_tb_txn_item gpr_info);
        write_gpr_entry(gpr_info, gpr_block[gpr_info.core_id]);
        `VX_info(message_id, $sformatf("GPR Info Received CORE_ID: %0d BYTEEN: 0x%0h BANK_NUM: %0d SET: %0d DATA_ENTRY: 0x%0x", gpr_info.core_id, gpr_info.byteen,  gpr_info.bank_num, gpr_info.bank_set, gpr_info.gpr_data_entry))
    endfunction

    virtual function void write_lsu_instr(VX_risc_v_instr_seq_item instr);
        instr_array[instr.address] = instr;
        `VX_info(message_id, $sformatf("Instruction Received Address: 0x%0h Name:%0s Type:%0s RAW_DATA: 0x%0h", instr.address, instr.instr_name, instr.instr_type.name(), instr.raw_data))
    endfunction

    function void write_lsu_info(VX_lsu_tb_txn_item lsu_info);
        this.lsu_info[lsu_info.core_id] = lsu_info;
    endfunction

    function void write_commit_info(VX_commit_tb_txn_item commit_info);
        this.commit_info[commit_info.core_id] = commit_info;
        check_lsu_operation(commit_info.core_id);
    endfunction

    function void check_lsu_operation(VX_core_id_t  core_id);
        pc      = commit_info[core_id].pc;
        wid     = commit_info[core_id].wid;

        if (instr_array.exists(pc)) begin
            
            for(int tid=0; tid < `NUM_THREADS;  tid++)begin
                case (instr_array[pc].instr_type)
                
                    I_TYPE: begin
                        VX_risc_v_Itype_seq_item i_item = VX_risc_v_Itype_seq_item::create_instruction_with_data("I_TYPE_INST",instr_array[pc].raw_data);
                        set_i_item_gpr_lookup_fields(i_item);
                        imm = `SEXT(`XLEN,i_item.imm);

                        operand1_data[tid]   = gpr_block[core_id][rs1_bank_num][rs1_set_num][tid];
                     
                        if(pc < fence_pc)
                            `VX_error(message_id, $sformatf("Load Instr Violated FENCE CORE_ID: %0d LD_PC: 0x%0h Fence_PC: 0x%0h", core_id, pc, fence_pc))

                        if (!commit_info[core_id].wb)
                            `VX_error(message_id, "commit_if.wb NOT set on Load Instruction")
                    
                        if((operand1_data[tid] + imm) != (lsu_info[core_id].req_addresses[tid] << `WORD_OFFSET_BITS))
                            `VX_error(message_id, $sformatf("Incorrect Load Target Exp: 0x%0h Act: 0x%0h", (operand1_data[tid] + imm) , (lsu_info[core_id].req_addresses[tid] << `WORD_OFFSET_BITS)))

                        if(i_item.rd != commit_info[core_id].rd)
                            `VX_error(message_id,  $sformatf("Committing to incorrect reg Exp: %0d Act: %0d", i_item.rd, commit_info[core_id].rd))

                        gpr_byte = lsu_info[core_id].rsp_data[tid][`B_WIDTH - 1: 0];
                        gpr_half_w = lsu_info[core_id].rsp_data[tid][`H_WIDTH - 1: 0];
                        gpr_word = lsu_info[core_id].rsp_data[tid][`W_WIDTH - 1: 0];

                        case(instr_array[pc].instr_name)
                            "LB":  expected_result[tid] = `SEXT(`XLEN, gpr_byte);
                            "LH":  expected_result[tid] = `SEXT(`SEQ_RAW_DATA_WIDTH, gpr_half_w);
                            "LW":  expected_result[tid] = `SEXT(`SEQ_RAW_DATA_WIDTH, gpr_word);
                            "LBU": expected_result[tid] = VX_seq_gpr_t'(gpr_byte);
                            "LHU": expected_result[tid] = VX_seq_gpr_t'(gpr_half_w);
                        endcase

                        if (expected_result[tid] != commit_info[core_id].data[tid])
                            `VX_error(message_id, $sformatf("Incorrect Load Data Committed TID: %0d Exp: 0x%0h Act: 0x%0h", tid, expected_result[tid], commit_info[core_id].data[tid]))
                    
                    end
                    S_TYPE: begin
                        VX_risc_v_Stype_seq_item s_item = VX_risc_v_Stype_seq_item::create_instruction_with_data("S_TYPE_INST",instr_array[pc].raw_data);
                        set_s_item_gpr_lookup_fields(s_item);
                        imm = `SEXT(`XLEN,{s_item.imm1,s_item.imm0});

                        operand1_data[tid]   = gpr_block[core_id][rs1_bank_num][rs1_set_num][tid];
                        operand2_data[tid]   = gpr_block[core_id][rs2_bank_num][rs2_set_num][tid];
                        
                        if(pc < fence_pc)
                            `VX_error(message_id, $sformatf("Store Instr Violated FENCE ST_PC: 0x%0h Fence_PC: 0x%0h", pc, fence_pc))

                        if (commit_info[core_id].wb)
                            `VX_error(message_id, "commit_if.wb set on Store Instruction")
                        
                        if((operand1_data[tid] + imm) != (lsu_info[core_id].req_addresses[tid] << `WORD_OFFSET_BITS))
                            `VX_error(message_id, $sformatf("Incorrect Store Target Exp: 0x%0h Act: 0x%0h", (operand1_data[tid] + imm) , (lsu_info[core_id].req_addresses[tid] << `WORD_OFFSET_BITS)))

                        case(instr_array[pc].instr_name)
                            "SB":  expected_byteen[tid] = `NUM_THREADS'b1;
                            "SH":  expected_byteen[tid] = `NUM_THREADS'b11;
                            "SW":  expected_byteen[tid] = `NUM_THREADS'b1111;
                        endcase

                        if(expected_byteen[tid] != lsu_info[core_id].req_byteen[tid]) begin
                            `VX_error(message_id, $sformatf("Incorrect Store Byteen TID: %0d Exp: %0d'b%0b Act: %0d'b%0b",
                            tid, `NUM_THREADS, expected_byteen[tid], `NUM_THREADS, lsu_info[core_id].req_byteen[tid]))
                        end

                        if (operand2_data[tid] != lsu_info[core_id].req_data[tid])
                            `VX_error(message_id, $sformatf("Incorrect Store Data Sent TID: %0d Exp: 0x%0h Act: 0x%0h", tid, operand2_data[tid], lsu_info[core_id].req_data[tid]))
                      
                    end
                    F_TYPE:begin
                        fence_pc = pc;
                    end
                    default: `VX_error(message_id, $sformatf("Found Instruction of incorrect type %0s", instr_array[pc].instr_type))
                endcase
            end
        end
    endfunction

    virtual function void  set_i_item_gpr_lookup_fields(VX_risc_v_Itype_seq_item i_item);
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

    virtual function void  set_s_item_gpr_lookup_fields(VX_risc_v_Stype_seq_item s_item);
        set_s_item_gpr_lookup_bank_nums(s_item);
        set_s_item_gpr_lookup_set_nums(s_item);
    endfunction   
   
    virtual function void set_s_item_gpr_lookup_bank_nums(VX_risc_v_Stype_seq_item s_item);
        rs1_bank_num = `REG_NUM_TO_BANK(s_item.rs1);
        rs2_bank_num  = `REG_NUM_TO_BANK(s_item.rs2);
    endfunction

    virtual function void set_s_item_gpr_lookup_set_nums(VX_risc_v_Stype_seq_item s_item);
      rs1_set_num  = `REG_NUM_TO_SET(wid,s_item.rs1);
      rs2_set_num   = `REG_NUM_TO_SET(wid,s_item.rs2);
    endfunction

endclass