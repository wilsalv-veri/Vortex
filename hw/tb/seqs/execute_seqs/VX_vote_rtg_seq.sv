class VX_vote_rtg_seq extends VX_vote_doa_seq;

    `uvm_object_utils(VX_vote_rtg_seq)
    
    function new(string name="VX_VOTE_RTG_SEQ");
        super.new(name);

        message_id = "VX_VOTE_RTG_SEQ";

        if (!this.randomize())
            `VX_error(message_id, "Failed to randomize VX_vote_rtg_seq")
        else begin
            `VX_info(message_id, $sformatf("Randomized VX_vote_rtg_seq with Vote_type: %0s first_tmask: 0x%0h, alternate_tmask: 0x%0h",
             vote_instr_type.name(), first_tmask, alternate_tmask))
        end
    endfunction

    constraint vote_seq_c {
    
        unique {first_tmask_reg, pred_val_reg, alternate_tmask_reg, vote_result_reg};
        first_tmask     inside {[1:'hf]};
        alternate_tmask inside {[1:'hf]};
        vote_instr_type dist {VOTE_ALL:=30, VOTE_ANY:=10, VOTE_UNI:=30, VOTE_BAL:= 30};
    }
    
endclass