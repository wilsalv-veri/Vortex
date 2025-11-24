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

    VX_core_tmasks_t           next_tmask;//Default initial TMASK is 1
    VX_tmask_t                 expected_tmask;
    VX_tid_t                   last_tid; //Initial last_tid = 0
    
    VX_warp_mask_t             warp_mask;
    VX_wid_t                   wid;
    
    function new(string name="VX_warp_ctl_scbd", uvm_component parent=null);
        super.new(name,parent);

        foreach(next_tmask[wid_idx])
            next_tmask[wid_idx] = !wid_idx ?  `NUM_THREADS'b1 : `NUM_THREADS'b0;
        
        warp_mask = `NUM_WARPS'b1;
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
        `VX_info("VX_WARP_CTL_SCBD", $sformatf("Instruction Received Address: 0x%0h Name:%0s Type:%0s RAW_DATA: 0x%0h", instr.address, instr.instr_name, instr.instr_type.name(), instr.raw_data))
    endfunction

    virtual function void write_sched_info(VX_sched_tb_txn_item sched_info);
        `VX_info("VX_WARP_CTL_SCBD", $sformatf("Sched Info Received Address: 0x%0h", sched_info.result_pc))
        check_instruction(sched_info);
    endfunction

    virtual function void write_gpr_info(VX_gpr_tb_txn_item gpr_info);
        gpr_block[gpr_info.bank_num][gpr_info.bank_set] = gpr_info.gpr_data_entry;
        `VX_info("VX_WARP_CTL_SCBD", $sformatf("GPR Info Received BANK_NUM: %0d SET: %0d DATA_ENTRY: 0x%0x", gpr_info.bank_num, gpr_info.bank_set, gpr_info.gpr_data_entry))
    endfunction

    virtual function void check_instruction(VX_sched_tb_txn_item sched_info);
        int bank_num;
        int set_num;
    
        risc_v_seq_instr_address_t pc = sched_info.result_pc;
        
        if (instr_array.exists(pc)) begin
            
            case (instr_array[pc].instr_type)
                R_TYPE: begin
                    VX_risc_v_Rtype_seq_item r_item = VX_risc_v_Rtype_seq_item::create_instruction_with_data("R_TYPE_INST",instr_array[pc].raw_data);
                    case(instr_array[pc].instr_name)
                        "TMC": begin
                            
                            bank_num = `REG_NUM_TO_BANK(r_item.rs1);
                            set_num  = `REG_NUM_TO_SET(r_item.rs1);
                            
                            next_tmask[wid]  = `NUM_THREADS'(sched_info.thread_masks[wid]);
                            expected_tmask   = `NUM_THREADS'(gpr_block[bank_num][set_num][last_tid]);
                         
                            if (expected_tmask !== next_tmask[wid])begin 
                                `VX_error("VX_WARP_CTL_SCBD", $sformatf("TMC Instruction Thread Mask Mismatch Instruction: 0x%0h Expected: 0x%0h Actual: 0x%0h", r_item.raw_data, gpr_block[bank_num][set_num][last_tid], sched_info.thread_masks[wid])) //sched_info_array[pc]
                                `VX_info("VX_WARP_CTL_SCBD", $sformatf("RS1: %0d BANK_NUM:%0d SET_NUM:%0d GPR_VAL: 0x%0h LAST_TID: %0d", r_item.rs1,bank_num, set_num, gpr_block[bank_num][set_num][last_tid], last_tid))
                            end
                            else 
                                `VX_info("VX_WARP_CTL_SCBD", $sformatf("RS1: %0d BANK_NUM:%0d SET_NUM:%0d GPR_VAL: 0x%0h ThreadMask: 4'b%b", r_item.rs1,bank_num, set_num, gpr_block[bank_num][set_num][last_tid],sched_info.thread_masks[wid])) //sched_info_array[pc]
                        
                            set_last_tid(next_tmask[wid]);

                        end 
                    endcase    
            
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

endclass