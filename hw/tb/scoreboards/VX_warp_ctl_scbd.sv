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
    VX_tid_t                   last_tid [`NUM_WARPS - 1:0]; //Initial last_tid = 0
    
    bit                             br_taken;
    VX_wid_t [`NUM_ALU_BLOCKS-1:0]  br_wid;

    bit                        is_else;
    bit                        join_is_else[$];
    VX_tb_ipdom_stack_entry_t  tb_ipdom_stack[$];
    VX_tb_ipdom_stack_entry_t  ipdom_stack_entry;

    int                        exp_num_of_warps;
    VX_warp_mask_t             exp_warp_mask;
    VX_warp_num_t              num_warps;
    VX_wid_t                   wid;

    VX_seq_gpr_bank_num_t      rs1_bank_num, rs2_bank_num, rd_bank_num;
    VX_seq_gpr_bank_set_t      rs1_set_num, rs2_set_num, rd_set_num;
    VX_seq_gpr_t               br_src1, br_src2;
    risc_v_seq_instr_address_t pc;
    risc_v_seq_instr_address_t exp_next_pc;
    risc_v_seq_instr_address_t stack_rd_ptr;
    risc_v_seq_instr_address_t [`NUM_ALU_BLOCKS-1:0] br_target;

    string message_id = "VX_WARP_CTL_SCBD";
    
    function new(string name="VX_warp_ctl_scbd", uvm_component parent=null);
        super.new(name,parent);

        foreach(next_tmask[wid_idx])
            next_tmask[wid_idx] = !wid_idx ?  `NUM_THREADS'b1 : `NUM_THREADS'b0;
        
        curr_tmask    = next_tmask;
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

        `VX_info(message_id, $sformatf("GPR Info Received BYTEEN: 0x%0h BANK_NUM: %0d SET: %0d DATA_ENTRY: 0x%0x", gpr_info.byteen,  gpr_info.bank_num, gpr_info.bank_set, gpr_info.gpr_data_entry))
    endfunction

    virtual function void check_instruction(VX_sched_tb_txn_item sched_info);
       
        pc    = sched_info.br_valid  ? sched_info.br_pc : sched_info.result_pc;
        wid   = sched_info.wid;
        num_warps = $countones(sched_info.active_warps);

        if (instr_array.exists(pc)) begin
            
            case (instr_array[pc].instr_type)
                R_TYPE: begin
                    VX_risc_v_Rtype_seq_item r_item = VX_risc_v_Rtype_seq_item::create_instruction_with_data("R_TYPE_INST",instr_array[pc].raw_data);
                    set_r_item_gpr_lookup_set_nums(r_item);
                    next_tmask[wid]  = `NUM_THREADS'(sched_info.thread_masks[wid]);
                            
                    case(instr_array[pc].instr_name)
                        "TMC": begin      
                            expected_tmask   = `NUM_THREADS'(gpr_block[rs1_bank_num][rs1_set_num][last_tid[wid]]);
                         
                            if (expected_tmask !== next_tmask[wid])begin 
                                `VX_error(message_id, $sformatf("TMC Instruction Thread Mask Mismatch  WID: %0h PC: %0h Instruction: 0x%0h Expected: 0x%0h Actual: 0x%0h", wid, pc, r_item.raw_data, gpr_block[rs1_bank_num][rs1_set_num][last_tid[wid]], sched_info.thread_masks[wid])) 
                                `VX_info(message_id, $sformatf("WID: %0d RS1: %0d BANK_NUM:%0d SET_NUM:%0d GPR_VAL: 0x%0h LAST_TID: %0d", wid, r_item.rs1,rs1_bank_num, rs1_set_num, gpr_block[rs1_bank_num][rs1_set_num][last_tid[wid]], last_tid[wid]))
                            end
                            else 
                                `VX_info(message_id, $sformatf("WID: %0d RS1: %0d BANK_NUM:%0d SET_NUM:%0d GPR_VAL: 0x%0h ThreadMask: 4'b%b", wid, r_item.rs1,rs1_bank_num, rs1_set_num, gpr_block[rs1_bank_num][rs1_set_num][last_tid[wid]],sched_info.thread_masks[wid])) 
                         
                        end
                        "PRED":begin
                            expected_tmask = `NUM_THREADS'(0);
                            
                            for(int tid=0; tid < `NUM_THREADS;  tid++)    
                                expected_tmask[tid] = ((gpr_block[rs1_bank_num][rs1_set_num][tid][0] ^ r_item.rd[0]) & curr_tmask[wid][tid]); 
                            
                            expected_tmask = expected_tmask  ? expected_tmask : `NUM_THREADS'(gpr_block[rs2_bank_num][rs2_set_num][last_tid[wid]]);     
                          
                            if (expected_tmask !== next_tmask[wid])begin 
                                `VX_error(message_id, $sformatf("PRED Instruction Thread Mask Mismatch Expected: 0x%0h Actual: 0x%0h", expected_tmask, next_tmask[wid])) 
                                `VX_info(message_id, $sformatf("RS1_GPR_VAL: 0x%0h RS2_GPR_VAL: 0x%0h RD_GPR_VAL: 0x%0h", gpr_block[rs1_bank_num][rs1_set_num], gpr_block[rs2_bank_num][rs2_set_num], gpr_block[rd_bank_num][rd_set_num]))
                            end
                        end
                        "WSPAWN":begin
                            if (sched_info.wspawn_valid && sched_info.curr_single_warp) begin
                                exp_num_of_warps = `NUM_WARPS'(gpr_block[rs1_bank_num][rs1_set_num][last_tid[wid]]);
                                exp_next_pc      = gpr_block[rs2_bank_num][rs2_set_num][last_tid[wid]];
                                exp_warp_mask    = get_warp_mask(exp_num_of_warps);
                                
                                if (exp_warp_mask != sched_info.active_warps)
                                    `VX_error(message_id, $sformatf("WSPAWN Set Incorrect Active Warps Exp_Num Warps: %0d Exp: %0d'b%0b Act: %0d'b%0b", exp_num_of_warps, `NUM_WARPS, exp_warp_mask, `NUM_WARPS, sched_info.active_warps))

                                for(int warp_idx = (wid + 1); warp_idx < exp_num_of_warps; warp_idx++)begin
                                    if (exp_next_pc != sched_info.warp_pcs[warp_idx])
                                        `VX_error(message_id, $sformatf("WSPAWN Set Incorrect PC WID:%0d Exp: %0h Act: %0h",warp_idx,  exp_next_pc, sched_info.warp_pcs[warp_idx]))
                                end
                            end
                        end
                        "BAR": begin
                            for(int wid_idx=0; wid_idx < `NUM_WARPS; wid_idx++)begin
                                if (wid_idx == wid)
                                    continue;
                                
                                if (sched_info.active_warps[wid_idx] && (sched_info.warp_pcs[wid_idx] > sched_info.warp_pcs[wid]))
                                    `VX_error(message_id, $sformatf("BARRIER NOT SUSTAINED WID: 0x%0h PC: 0x%0h VIOLATING WARP: 0x%0h VIOLATING PC: 0x%0h", 
                                wid, sched_info.warp_pcs[wid], wid_idx, sched_info.warp_pcs[wid_idx]))
                            end
                        end
                        "SPLIT": begin
                            expected_tmask = `NUM_THREADS'(0);
                            for(int tid_idx=0; tid_idx < `NUM_THREADS; tid_idx++)begin
                                if (curr_tmask[wid][tid_idx])
                                    expected_tmask[tid_idx] = gpr_block[rs1_bank_num][rs1_set_num][tid_idx][0] ^ r_item.rs2[0];
                            end

                            expected_tmask = $countones(expected_tmask) >= $countones(~expected_tmask & curr_tmask[wid]) ? expected_tmask :  ~expected_tmask & curr_tmask[wid];
                            if (expected_tmask != next_tmask[wid])
                                `VX_error(message_id, $sformatf("SPLIT Instruction set incorrect next tmask Exp_TMASK: %0d'b%0b Act_TMASK: %0d'b%0b", `NUM_THREADS,expected_tmask, `NUM_THREADS, next_tmask[wid]))
                            
                            if (expected_tmask != curr_tmask[wid])
                                ipdom_stack_push_entry();
                        end
                        "JOIN": begin

                            stack_rd_ptr = gpr_block[rs1_bank_num][rs1_set_num][last_tid[wid]];
                            
                            if (stack_rd_ptr == (tb_ipdom_stack.size() - 1))begin
                                `VX_info(message_id, $sformatf("RS1 Stack Ptr: 0x%0h Stack Size: 0x%0h", stack_rd_ptr, tb_ipdom_stack.size()))
                                if (sched_info.join_valid) begin
                                    ipdom_stack_entry = tb_ipdom_stack.pop_back();
                                    expected_tmask = ipdom_stack_entry.join_is_else ? ipdom_stack_entry.join_tmask : ipdom_stack_entry.non_dvg_tmask;

                                    if (expected_tmask != next_tmask[wid])
                                        `VX_error(message_id, $sformatf("JOIN Instruction set incorrect next tmask WID: %0d Exp_TMASK: %0d'b%0b Act_TMASK: %0d'b%0b IS_ELSE: %0d", wid, `NUM_THREADS,expected_tmask, `NUM_THREADS, next_tmask[wid], ipdom_stack_entry.join_is_else))

                                    if (ipdom_stack_entry.join_is_else) begin
                                        ipdom_stack_entry.join_is_else = 0;
                                        tb_ipdom_stack.push_back(ipdom_stack_entry);
                                    end
                                end

                            end
                            else if (next_tmask[wid] != curr_tmask[wid])
                                `VX_error(message_id, $sformatf("JOIN Instruction With Incorrect Stack Ptr Changed T-MASK RD_PTR: %0d STACK_SIZE: %0d", stack_rd_ptr,tb_ipdom_stack.size() ))  
                        
                        end
                    endcase    
                    
                    set_last_tid(next_tmask[wid]);
                    curr_tmask = next_tmask;
       
                end
                B_TYPE: begin
                    VX_risc_v_Btype_seq_item b_item = VX_risc_v_Btype_seq_item::create_instruction_with_data("B_TYPE_INST",instr_array[pc].raw_data);
                    set_b_item_gpr_lookup_set_nums(b_item);
                    
                    for(int alu_num=0; alu_num < `NUM_ALU_BLOCKS; alu_num++)begin
                        
                        br_wid = sched_info.br_wid[alu_num];
                        br_src1 = gpr_block[rs1_bank_num][rs1_set_num][last_tid[br_wid]];
                        br_src2 = gpr_block[rs1_bank_num][rs1_set_num][last_tid[br_wid]];
                        br_target = pc + get_br_offset(b_item);
                   
                        case(instr_array[pc].instr_name)
                            "BEQ":br_taken = br_src1 == br_src2;     
                        endcase

                        if (sched_info.br_valid[alu_num])begin
                            if (br_taken != sched_info.br_taken[alu_num])
                                `VX_error(message_id, $sformatf("BR instruction had incorrect outcome ALU_NUM: %0d Exp Taken: %0d Act Taken: %0d", alu_num, br_taken, sched_info.br_taken))
                            else if (br_taken && (br_target[alu_num] != sched_info.br_target[alu_num]))
                                `VX_error(message_id, $sformatf("BR instruction taken with incorrect branch target PC: 0x%0h ALU_NUM: %0d Exp Target: 0x%0h Act Target: 0x%0h", pc, alu_num, br_target[alu_num], sched_info.br_target[alu_num]))
                            else if (br_taken && (br_target[alu_num] != sched_info.warp_pcs[br_wid]))
                                `VX_error(message_id, $sformatf("BR instruction taken but did not update WARP WID: 0x%0h PC TARGET: 0x%0h ACT_PC: 0x%0h", br_wid, br_target[alu_num], sched_info.warp_pcs[br_wid]))
                        end
                    end
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
                last_tid[wid] = VX_tid_t'(idx);
                `VX_info("VX_WARP_CTL_SCBD", $sformatf("Set Last_TID: %0d TMASK: 4'b%0b WID: %0d", last_tid[wid], tmask, wid)) 
                return;
            end
        end
    endfunction

    virtual function void  set_r_item_gpr_lookup_fields( VX_risc_v_Rtype_seq_item r_item);
        set_r_item_gpr_lookup_bank_nums(r_item);
        set_r_item_gpr_lookup_set_nums(r_item);
    endfunction   
   
    virtual function void  set_b_item_gpr_lookup_fields( VX_risc_v_Btype_seq_item b_item);
        set_b_item_gpr_lookup_bank_nums(b_item);
        set_b_item_gpr_lookup_set_nums(b_item);
    endfunction   
   
    virtual function void set_r_item_gpr_lookup_bank_nums(VX_risc_v_Rtype_seq_item r_item);
        rs1_bank_num = `REG_NUM_TO_BANK(r_item.rs1);
        rs2_bank_num = `REG_NUM_TO_BANK(r_item.rs2);
        rd_bank_num  = `REG_NUM_TO_BANK(r_item.rd);
    endfunction

     virtual function void set_b_item_gpr_lookup_bank_nums(VX_risc_v_Btype_seq_item b_item);
        rs1_bank_num = `REG_NUM_TO_BANK(b_item.rs1);
        rs2_bank_num = `REG_NUM_TO_BANK(b_item.rs2);
    endfunction

    virtual function void set_r_item_gpr_lookup_set_nums(VX_risc_v_Rtype_seq_item r_item);
      rs1_set_num  = `REG_NUM_TO_SET(wid,r_item.rs1);
      rs2_set_num  = `REG_NUM_TO_SET(wid,r_item.rs2);
      rd_set_num   = `REG_NUM_TO_SET(wid,r_item.rd);
    endfunction

    virtual function void set_b_item_gpr_lookup_set_nums(VX_risc_v_Btype_seq_item b_item);
      rs1_set_num  = `REG_NUM_TO_SET(wid,b_item.rs1);
      rs2_set_num  = `REG_NUM_TO_SET(wid,b_item.rs2);
    endfunction

    virtual function VX_warp_mask_t get_warp_mask(int number_of_warps);
        VX_warp_mask_t warp_mask = `NUM_WARPS'(1); 
       
        for(int idx=1; idx < number_of_warps;idx++)  
            warp_mask = (warp_mask << 1) | `NUM_WARPS'(1);
        
        return warp_mask; 
    endfunction

    virtual function void ipdom_stack_push_entry();
        ipdom_stack_entry.join_tmask = ~expected_tmask & curr_tmask[wid];
        ipdom_stack_entry.non_dvg_tmask = curr_tmask[wid];
        ipdom_stack_entry.join_is_else = 1;
        tb_ipdom_stack.push_back(ipdom_stack_entry);
    endfunction

    virtual function  risc_v_seq_instr_address_t get_br_offset(VX_risc_v_Btype_seq_item b_item);
        return risc_v_seq_instr_address_t'({b_item.imm_12,b_item.imm_11,b_item.imm1,b_item.imm0,1'b0});
    endfunction

endclass