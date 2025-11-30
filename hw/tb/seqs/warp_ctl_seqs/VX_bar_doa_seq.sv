class VX_bar_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_bar_doa_seq)

    string message_id = "VX_BAR_DOA_SEQ";
    rand risc_v_seq_reg_num_t bar_id_num_reg;
    rand risc_v_seq_reg_num_t bar_warp_num_reg;
    rand VX_warp_num_t        num_warps_spawned; 
    rand risc_v_seq_imm_t     bar_id;

    function new(string name="VX_bar_doa_seq");
        super.new(name);
    endfunction

    constraint bar_seq_c {
        bar_id_num_reg   == 2;
        bar_warp_num_reg == 3;
        bar_id           == 0;
    }

    virtual function void pre_add_instructions();
        num_warps_spawned = p_sequencer.seq_result_item.num_warps_spawned - 1;
        `VX_info(message_id, $sformatf("Number of SPAWNED Warps : %0d", num_warps_spawned))
    endfunction

    virtual function void add_instructions();
        instr_queue.push_back(`ADDI(`RS1(bar_id_num_reg),`IMM_BIN(bar_id),`RD(bar_id_num_reg)));
        instr_queue.push_back(`ADDI(`RS1(bar_warp_num_reg),`IMM_BIN(num_warps_spawned),`RD(bar_warp_num_reg)));
        instr_queue.push_back(`BAR(`RS1(bar_id_num_reg), `RS2(bar_warp_num_reg)));     
    endfunction

    virtual function void post_add_instructions();
        //Remove the last instruction (TMC) which kills the warps
        //Must be careful. This will only work in the case of use of
        //sequence library which has another sequence after this
        //Without another sequence running after, this will run forever
        instr_queue.pop_back();
    endfunction

endclass