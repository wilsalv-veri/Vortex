class VX_lsu_scbd extends uvm_scoreboard;

    `uvm_component_utils(VX_lsu_scbd)

    string message_id = "VX_LSU_SCBD";
    VX_lsu_tb_txn_item                                                  lsu_info;
    VX_commit_tb_txn_item                                               commit_info;
    VX_risc_v_instr_seq_item                                            instr_array[integer]; 
    
    `uvm_analysis_imp_decl(_lsu_info)
    uvm_analysis_imp_lsu_info #(VX_lsu_tb_txn_item, VX_lsu_scbd)        receive_lsu_info;

    `uvm_analysis_imp_decl(_commit_info)
    uvm_analysis_imp_commit_info #(VX_commit_tb_txn_item, VX_lsu_scbd)  receive_commit_info;

    `uvm_analysis_imp_decl (_lsu_instr)
    uvm_analysis_imp_lsu_instr #(VX_risc_v_instr_seq_item, VX_lsu_scbd) receive_riscv_instr;
   
    risc_v_seq_instr_address_t                                          pc;
    VX_wid_t                                                            wid;
   
    uvm_tlm_analysis_fifo #(VX_gpr_tb_txn_item)                         gpr_tb_fifo;
    VX_gpr_tb_txn_item                                                  gpr_info;
    VX_gpr_seq_block_t                                                  gpr_block;
    VX_gpr_seq_data_entry_t                                             operand1_data; 
    VX_gpr_seq_data_entry_t                                             expected_result;

    VX_seq_gpr_bank_num_t                                               rs1_bank_num, rd_bank_num;
    VX_seq_gpr_bank_set_t                                               rs1_set_num,  rd_set_num;
    risc_v_seq_imm_t                                                    imm;

    VX_seq_gpr_byte_t                                                   gpr_load_byte;
    VX_seq_gpr_half_w_t                                                 gpr_load_half_w;
    VX_seq_gpr_word_t                                                   gpr_load_word;
  
    function new(string name="VX_lsu_scbd", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        receive_lsu_info    = new("RECEIVE_LSU_INFO", this);
        receive_commit_info = new("RECEIVE_COMMIT_INFO", this);
        receive_riscv_instr = new("LSU_SCBD_RECEIVE_RISCV_INSTR", this);
        gpr_tb_fifo         = new("LSU_SCBD_GPR_TB_FIFO", this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            gpr_tb_fifo.get(gpr_info);
            write_gpr_info(gpr_info);
        end
    endtask

    virtual function void write_gpr_info(VX_gpr_tb_txn_item gpr_info);
        write_gpr_entry(gpr_info, gpr_block);
        `VX_info(message_id, $sformatf("GPR Info Received BYTEEN: 0x%0h BANK_NUM: %0d SET: %0d DATA_ENTRY: 0x%0x", gpr_info.byteen,  gpr_info.bank_num, gpr_info.bank_set, gpr_info.gpr_data_entry))
    endfunction

    virtual function void write_lsu_instr(VX_risc_v_instr_seq_item instr);
        instr_array[instr.address] = instr;
        `VX_info(message_id, $sformatf("Instruction Received Address: 0x%0h Name:%0s Type:%0s RAW_DATA: 0x%0h", instr.address, instr.instr_name, instr.instr_type.name(), instr.raw_data))
    endfunction

    function void write_lsu_info(VX_lsu_tb_txn_item lsu_info);
        this.lsu_info = lsu_info;
    endfunction

    function void write_commit_info(VX_commit_tb_txn_item commit_info);
        this.commit_info = commit_info;
        check_load_operation();
    endfunction

    function void check_load_operation();
        pc  = commit_info.pc;
        wid = commit_info.wid;

        if (instr_array.exists(pc)) begin
            
            for(int tid=0; tid < `NUM_THREADS;  tid++)begin
                case (instr_array[pc].instr_type)
                
                    I_TYPE: begin
                        VX_risc_v_Itype_seq_item i_item = VX_risc_v_Itype_seq_item::create_instruction_with_data("I_TYPE_INST",instr_array[pc].raw_data);
                        set_i_item_gpr_lookup_fields(i_item);
                        imm = `SEXT(`XLEN,i_item.imm);

                        operand1_data[tid]   = gpr_block[rs1_bank_num][rs1_set_num][tid];
                     
                        if((operand1_data[tid] + imm) != (lsu_info.req_addresses[tid] << `WORD_OFFSET_BITS))
                            `VX_error(message_id, $sformatf("Incorrect Load Target Exp: 0x%0h Act: 0x%0h", (operand1_data[tid] + imm) , (lsu_info.req_addresses[tid] << `WORD_OFFSET_BITS)))

                        if(i_item.rd != commit_info.rd)
                            `VX_error(message_id,  $sformatf("Committing to incorrect reg Exp: %0d Act: %0d", i_item.rd, commit_info.rd))

                        gpr_load_byte = lsu_info.rsp_data[tid][`LB_WIDTH - 1: 0];
                        gpr_load_half_w = lsu_info.rsp_data[tid][`LH_WIDTH - 1: 0];
                        gpr_load_word = lsu_info.rsp_data[tid][`LW_WIDTH - 1: 0];

                        case(instr_array[pc].instr_name)
                            "LB":  expected_result[tid] = `SEXT(`XLEN, gpr_load_byte);
                            "LH":  expected_result[tid] = `SEXT(`SEQ_RAW_DATA_WIDTH, gpr_load_half_w);
                            "LW":  expected_result[tid] = `SEXT(`SEQ_RAW_DATA_WIDTH, gpr_load_word);
                            "LBU": expected_result[tid] = VX_seq_gpr_t'(gpr_load_byte);
                            "LHU": expected_result[tid] = VX_seq_gpr_t'(gpr_load_half_w);
                        endcase

                        if (expected_result[tid] != commit_info.data[tid])
                            `VX_error(message_id, $sformatf("Incorrect Load Data Committed Exp: 0x%0h Act: 0x%0h", expected_result[tid], commit_info.data[tid]))
                    
                    end
                    default: `VX_error(message_id, $sformatf("Found Instruction of incorrect type %0s", instr_array[pc].instr_type))
                endcase
            end
        end
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