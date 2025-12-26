class VX_shfl_rtg_seq extends VX_shfl_doa_seq;

    `uvm_object_utils(VX_shfl_rtg_seq)

    VX_tmask_t           max_possible_tmask;
   
    function new(string name="VX_shfl_rtg_seq");
        super.new(name);
        message_id = "VX_SHFL_RTG_SEQ";

        max_possible_tmask = get_max_possible_tmask();

        if (!this.randomize())
            `VX_error(message_id, "Failed to randomize VX_shfl_rtg_seq")
        else begin
            `VX_info(message_id, $sformatf("Randomized VX_shfl_rtg_seq with SHFL_TYPE: %0s SRC1: 0x%0h BVAL: 0x%0h CVAL: 0x%0h MASK: 0x%0h",
            shfl_instr_type.name(),shfl_lane_reg, shfl_bval, shfl_cval, shfl_mask))
        end
    endfunction

    constraint shfl_seq_c {
        shfl_lane_reg  inside  {[1: RV_REGS - 1]};
        shfl_result_reg inside {[1: RV_REGS - 1]};

        tmask     inside {[1: max_possible_tmask]};
        shfl_bval inside {[0: `NUM_THREADS]};
        shfl_cval inside {[0: `NUM_THREADS]};
        shfl_mask inside {[0: `NUM_THREADS]};
    }

    
endclass