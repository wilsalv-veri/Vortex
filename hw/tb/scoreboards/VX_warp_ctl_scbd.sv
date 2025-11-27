class VX_warp_ctl_scbd extends uvm_scoreboard;

    `uvm_component_utils(VX_warp_ctl_scbd)

    `uvm_analysis_imp_decl (_warp_ctl_instr)
    uvm_analysis_imp_warp_ctl_instr #(VX_risc_v_instr_seq_item, VX_warp_ctl_scbd) receive_riscv_instr;
    
    `uvm_analysis_imp_decl (_sched_info)
    uvm_analysis_imp_sched_info #(VX_sched_tb_txn_item, VX_warp_ctl_scbd) receive_sched_info; 

    uvm_tlm_analysis_fifo #(VX_gpr_tb_txn_item) gpr_tb_fifo;

    VX_risc_v_instr_seq_item   instr_array[integer]; 
    VX_gpr_tb_txn_item         gpr_info;

    VX_gpr_seq_block_t         gpr_block;

    VX_core_tmasks_t           curr_tmask;//Default initial TMASK is 1
    VX_core_tmasks_t           next_tmask;//Default initial TMASK is 1
    VX_tmask_t                 expected_tmask;
    VX_tid_t                   last_tid; //Initial last_tid = 0
    
    int                        exp_num_of_warps;
    VX_warp_mask_t             exp_warp_mask;
    VX_wid_t                   wid;

    VX_gpr_bank_num_t          rs1_bank_num, rs2_bank_num, rd_bank_num;
    VX_gpr_bank_set_t          rs1_set_num, rs2_set_num, rd_set_num;
    risc_v_seq_instr_address_t pc;
    risc_v_seq_instr_address_t exp_next_pc;
    
    
    string message_id = "VX_WARP_CTL_SCBD";
    
    function new(string name="VX_warp_ctl_scbd", uvm_component parent=null);
        super.new(name,parent);

        foreach(next_tmask[wid_idx])
            next_tmask[wid_idx] = !wid_idx ?  `NUM_THREADS'b1 : `NUM_THREADS'b0;
        
        curr_tmask = next_tmask;
        exp_warp_mask = `NUM_WARPS'b1;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        receive_riscv_instr = new("RECEIIVE_RISCV_INSTR", this);
        receive_sched_info  = new("RECEIVE_SCHED_INFO", this);
        
        gpr_tb_fifo         = new("GPR_TB_FIFO", this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            gpr_tb_fifo.get(gpr_info);
            write_gpr_info(gpr_info);
        end
    endtask

    virtual function void write_warp_ctl_instr(VX_risc_v_instr_seq_item instr);
        instr_array[instr.address] = instr;
        `VX_info(message_id, $sformatf("Instruction Received Address: 0x%0h Name:%0s Type:%0s RAW_DATA: 0x%0h", instr.address, instr.instr_name, instr.instr_type.name(), instr.raw_data))
    endfunction

    /* 
    virtual function void write_execute_info(VX_risc_v_instr_seq_item instr);
        instr_array[instr.address] = instr;
        `VX_info(message_id, $sformatf("Instruction Received Address: 0x%0h Name:%0s Type:%0s RAW_DATA: 0x%0h", instr.address, instr.instr_name, instr.instr_type.name(), instr.raw_data))
    endfunction*/

    virtual function void write_sched_info(VX_sched_tb_txn_item sched_info);
        `VX_info(message_id, $sformatf("Sched Info Received Address: 0x%0h", sched_info.result_pc))
        check_instruction(sched_info);
    endfunction

    virtual function void write_gpr_info(VX_gpr_tb_txn_item gpr_info);
         
        for(int tid=0; tid < `NUM_THREADS; tid++)begin
            for(int gpr_byte=0; gpr_byte < `SIMD_WIDTH; gpr_byte++)begin
                if(gpr_info.byteen[tid][gpr_byte])
                    gpr_block[gpr_info.bank_num][gpr_info.bank_set][tid][gpr_byte] = gpr_info.gpr_data_entry[tid][gpr_byte];
            end
        end

        `VX_info(message_id, $sformatf("GPR Info Received BANK_NUM: %0d SET: %0d DATA_ENTRY: 0x%0x", gpr_info.bank_num, gpr_info.bank_set, gpr_info.gpr_data_entry))
    endfunction

    virtual function void check_instruction(VX_sched_tb_txn_item sched_info);
       
        pc  = sched_info.result_pc;
        wid = sched_info.wid;
        
        if (instr_array.exists(pc)) begin
            
            case (instr_array[pc].instr_type)
                R_TYPE: begin
                    VX_risc_v_Rtype_seq_item r_item = VX_risc_v_Rtype_seq_item::create_instruction_with_data("R_TYPE_INST",instr_array[pc].raw_data);
                    set_gpr_lookup_fields(r_item);
                    next_tmask[wid]  = `NUM_THREADS'(sched_info.thread_masks[wid]);
                            
                    case(instr_array[pc].instr_name)
                        "TMC": begin      
                            expected_tmask   = `NUM_THREADS'(gpr_block[rs1_bank_num][rs1_set_num][last_tid]);
                         
                            if (expected_tmask !== next_tmask[wid])begin 
                                `VX_error(message_id, $sformatf("TMC Instruction Thread Mask WID: %0h Mismatch PC: %0h Instruction: 0x%0h Expected: 0x%0h Actual: 0x%0h", wid, pc, r_item.raw_data, gpr_block[rs1_bank_num][rs1_set_num][last_tid], sched_info.thread_masks[wid])) 
                                `VX_info(message_id, $sformatf("RS1: %0d BANK_NUM:%0d SET_NUM:%0d GPR_VAL: 0x%0h LAST_TID: %0d", r_item.rs1,rs1_bank_num, rs1_set_num, gpr_block[rs1_bank_num][rs1_set_num][last_tid], last_tid))
                            end
                            else 
                                `VX_info(message_id, $sformatf("RS1: %0d BANK_NUM:%0d SET_NUM:%0d GPR_VAL: 0x%0h ThreadMask: 4'b%b", r_item.rs1,rs1_bank_num, rs1_set_num, gpr_block[rs1_bank_num][rs1_set_num][last_tid],sched_info.thread_masks[wid])) 
                        
                          
                        end
                        "PRED":begin
                            expected_tmask = `NUM_THREADS'(0);
                            
                            for(int tid=0; tid < `NUM_THREADS;  tid++)    
                                expected_tmask[tid] = ((gpr_block[rs1_bank_num][rs1_set_num][tid][0] ^ r_item.rd[0]) & curr_tmask[wid][tid]); 
                            
                            expected_tmask = expected_tmask  ? expected_tmask : `NUM_THREADS'(gpr_block[rs2_bank_num][rs2_set_num][last_tid]);     
                          
                            if (expected_tmask !== next_tmask[wid])begin 
                                `VX_error(message_id, $sformatf("PRED Instruction Thread Mask Mismatch Expected: 0x%0h Actual: 0x%0h", expected_tmask, next_tmask[wid])) 
                                `VX_info(message_id, $sformatf("RS1_GPR_VAL: 0x%0h RS2_GPR_VAL: 0x%0h RD_GPR_VAL: 0x%0h", gpr_block[rs1_bank_num][rs1_set_num], gpr_block[rs2_bank_num][rs2_set_num], gpr_block[rd_bank_num][rd_set_num]))
                            end
                        end
                        "WSPAWN":begin
                            if (sched_info.wspawn_valid) begin
                                exp_num_of_warps = `NUM_WARPS'(gpr_block[rs1_bank_num][rs1_set_num][last_tid]);
                                exp_next_pc      = gpr_block[rs2_bank_num][rs2_set_num][last_tid];
                                exp_warp_mask    = get_warp_mask(exp_num_of_warps);
                                
                                //curr_last_wid
                                if (exp_warp_mask != sched_info.active_warps)
                                    `VX_error(message_id, $sformatf("WSPAWN Set Incorrect Active Warps Exp_Num Warps: %0d Exp: %0d'b%0b Act: %0d'b%0b", exp_num_of_warps, `NUM_WARPS, exp_warp_mask, `NUM_WARPS, sched_info.active_warps))

                                for(int warp_idx= (wid + 1); warp_idx < (exp_num_of_warps - 1); warp_idx++)begin
                                    if (exp_next_pc != sched_info.warp_pcs[warp_idx])
                                        `VX_error(message_id, $sformatf("WSPAWN Set Incorrect PC Exp: %0h Act: %0h", exp_next_pc, sched_info.warp_pcs[warp_idx]))
                                end
                            end
                        end

                    endcase    
                    
                    set_last_tid(next_tmask[wid]);
                    curr_tmask = next_tmask;
       
                end
                default:
                    `VX_error("VX_WARP_CTL_SCBD", $sformatf("Found instruction with the incorrect type: %s", instr_array[pc].instr_type.name() ))
            endcase
                    end
        else
            `VX_error("VX_WARP_CTL_SCBD", $sformatf("No instruction found at address: %0h", pc))
        
    endfunction

    virtual function void set_last_tid(VX_tmask_t  tmask);

        for(int idx = $bits(VX_tmask_t); idx > 0;idx--)begin
            if (tmask[idx])begin
                last_tid = VX_tid_t'(idx);
                `VX_info("VX_WARP_CTL_SCBD", $sformatf("Set Last_TID: %0d TMASK: 4'b%0b", last_tid, tmask)) 
                return;
            end
        end
    endfunction

    virtual function void  set_gpr_lookup_fields( VX_risc_v_Rtype_seq_item r_item);
        set_gpr_lookup_bank_nums(r_item);
        set_gpr_lookup_set_nums(r_item);
    endfunction   
    
    virtual function void set_gpr_lookup_bank_nums(VX_risc_v_Rtype_seq_item r_item);
        rs1_bank_num = `REG_NUM_TO_BANK(r_item.rs1);
        rs2_bank_num = `REG_NUM_TO_BANK(r_item.rs2);
        rd_bank_num  = `REG_NUM_TO_BANK(r_item.rd);
    endfunction

    virtual function void set_gpr_lookup_set_nums(VX_risc_v_Rtype_seq_item r_item);
      rs1_set_num  = `REG_NUM_TO_SET(wid,r_item.rs1);
      rs2_set_num  = `REG_NUM_TO_SET(wid,r_item.rs2);
      rd_set_num   = `REG_NUM_TO_SET(wid,r_item.rd);
    endfunction

    virtual function VX_warp_mask_t get_warp_mask(int number_of_warps);
        VX_warp_mask_t warp_mask = `NUM_WARPS'(0); 
       
        for(int idx=0; idx < number_of_warps;idx++)begin
            if (!idx)
                warp_mask = `NUM_WARPS'(1);
            else
                warp_mask = (warp_mask << 1) | `NUM_WARPS'(1);
        end

        return warp_mask; 
    endfunction

endclass