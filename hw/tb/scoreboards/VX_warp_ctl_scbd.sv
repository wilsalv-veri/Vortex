class VX_warp_ctl_scbd extends uvm_scoreboard;

    `uvm_component_utils(VX_warp_ctl_scbd)

    `uvm_analysis_imp_decl (_warp_ctl_instr)
    uvm_analysis_imp_warp_ctl_instr #(VX_risc_v_instr_seq_item, VX_warp_ctl_scbd) receive_riscv_instr;
    
    `uvm_analysis_imp_decl (_sched_info)
    uvm_analysis_imp_sched_info #(VX_sched_tb_txn_item, VX_warp_ctl_scbd) receive_sched_info; 

    uvm_tlm_analysis_fifo #(VX_gpr_tb_txn_item) gpr_tb_fifo;

    VX_risc_v_instr_seq_item  instr_array[integer]; 
    VX_gpr_tb_txn_item        gpr_info;

    VX_gpr_block_t            gpr_block;

    bit [NW_WIDTH-1:0] wid;

    function new(string name="VX_warp_ctl_scbd", uvm_component parent=null);
        super.new(name,parent);
        this.gpr_block[0][0] = {`GPR_DATA_ENTRY_WIDTH{1'b0}}; //Initialize R0 to 0
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        receive_riscv_instr = new("RECEIIVE_RISCV_INSTR", this);
        receive_sched_info  = new("RECEIVE_SCHED_INFO", this);
        
        gpr_tb_fifo         = new("GPR_TB_FIFO", this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);
        gpr_tb_fifo.get(gpr_info);
        write_gpr_info(gpr_info);

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
        this.gpr_block[gpr_info.bank_num][gpr_info.bank_set] = gpr_info.gpr_data_entry;
        `VX_info("VX_WARP_CTL_SCBD", $sformatf("GPR Info Received BANK_NUM: %0d SET: %0d", gpr_info.bank_num, gpr_info.bank_set))
    endfunction

    virtual function void check_instruction(VX_sched_tb_txn_item sched_info);
        int bank_num;
        int set_num;
        bit [1:0] last_tid;
        risc_v_seq_instr_address_t pc = sched_info.result_pc;
        
        if (instr_array.exists(pc)) begin
            
            case (instr_array[pc].instr_type)
                R_TYPE: begin
                    VX_risc_v_Rtype_seq_item r_item = VX_risc_v_Rtype_seq_item::create_instruction_with_data("R_TYPE_INST",instr_array[pc].raw_data);
                    case(instr_array[pc].instr_name)
                        "TMC": begin
                            wid = sched_info.wid;
                            last_tid = sched_info.last_tid;
                            bank_num = `REG_NUM_TO_BANK(r_item.rs1);
                            set_num  = `REG_NUM_TO_SET(r_item.rs1);

                            if (gpr_block[bank_num][set_num][last_tid] !== `GPR_DATA_WIDTH'(sched_info.thread_masks[wid]))begin 
                                `VX_error("VX_WARP_CTL_SCBD", $sformatf("TMC Instruction Thread Mask Mismatch Instruction: 0x%0h Expected: 0x%0h Actual: 0x%0h", r_item.raw_data, gpr_block[bank_num][set_num][last_tid], sched_info.thread_masks[wid])) //sched_info_array[pc]
                                `VX_info("VX_WARP_CTL_SCBD", $sformatf("RS1: %0d BANK_NUM:%0d SET_NUM:%0d GPR_VAL: 0x%0h", r_item.rs1,bank_num, set_num, gpr_block[bank_num][set_num][last_tid]))
                            end
                            else 
                                `VX_info("VX_WARP_CTL_SCBD", $sformatf("RS1: %0d BANK_NUM:%0d SET_NUM:%0d GPR_VAL: 0x%0h ThreadMask: 4'b%b", r_item.rs1,bank_num, set_num, gpr_block[bank_num][set_num][last_tid],sched_info.thread_masks[wid])) //sched_info_array[pc]
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

endclass