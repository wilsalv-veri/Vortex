import VX_tb_top_pkg::*;

class VX_wspawn_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_wspawn_doa_seq)

    string message_id = "VX_WSPAWN_DOA_SEQ";
    risc_v_seq_instr_address_t new_pc;
    rand risc_v_seq_reg_num_t warp_nums_reg;
    rand risc_v_seq_reg_num_t warp_pc_reg;
    rand int num_of_active_warps;

    function new(string name="VX_wspawn_doa_seq");
        super.new(name);
        
        
    endfunction

    constraint wspawn_seq_c {
        warp_nums_reg == 1;
        warp_pc_reg   == 2;
        num_of_active_warps == 2;
    }

    virtual function void add_instructions();

        `VX_info(message_id, $sformatf("WARP_NUMS_REG: %0d WARP_PC_REG:%0d NUM_ACTIVE_WARPS: %0d", warp_nums_reg,warp_pc_reg,num_of_active_warps ))
        instr_queue.push_back(`ADDI(`RS1(warp_nums_reg),`IMM_BIN(num_of_active_warps),`RD(warp_nums_reg)));
        instr_queue.push_back(`LUI(`IMM_BIN(CODE_CS_BASE_ADDR),`RD(warp_pc_reg))); 
        instr_queue.push_back(`ADDI(`RS1(warp_pc_reg),`IMM_BIN(new_pc),`RD(warp_pc_reg)));
        instr_queue.push_back(`WSPAWN(`RS1(warp_nums_reg), `RS2(warp_pc_reg)));
    endfunction

    virtual function void post_add_instructions();
        set_warp_pc_offset();
    endfunction

    virtual function void set_warp_pc_offset();
        int queue_size = instr_queue.size();
        new_pc = (queue_size * XLENB);
        `VX_info(message_id, $sformatf("NEW WARP PC: 0x%0h", new_pc))
        set_warp_pc_imm(new_pc);
    endfunction

    virtual function void set_warp_pc_imm(risc_v_seq_imm_t imm);
        VX_risc_v_Itype_seq_item i_seq_item = VX_risc_v_Itype_seq_item::type_id::create("VX_risc_v_Itype_seq_item");
        VX_risc_v_instr_seq_item instr_seq_item;

        int warp_pc_instr_idx = get_warp_pc_instruction_idx();
        instr_seq_item = instr_queue.get(warp_pc_instr_idx);
        if ($cast(i_seq_item, instr_seq_item))begin
            i_seq_item.set_imm_field(imm); 
            instr_seq_item.raw_data = i_seq_item.raw_data;
        end
        else
            `VX_error(message_id, "Failed to cast Warp PC Instruction into I-TYPE")
    endfunction

    virtual function int get_warp_pc_instruction_idx();
        VX_risc_v_Itype_seq_item i_seq_item  = VX_risc_v_Itype_seq_item::type_id::create("VX_risc_v_Itype_seq_item");
        VX_risc_v_instr_seq_item instr_seq_item;

        for(int q_idx=0; q_idx < instr_queue.size();q_idx++)begin
            instr_seq_item = instr_queue.get(q_idx);

            if ($cast(i_seq_item, instr_seq_item))begin
                if ((i_seq_item.instr_name == "ADDI") && (i_seq_item.rs1 == warp_pc_reg))
                return q_idx;
            end             
        end
        `VX_error(message_id, "Failed to find Warp PC Instruction In Queue")
    endfunction

endclass 