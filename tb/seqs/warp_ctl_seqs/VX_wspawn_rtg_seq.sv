class VX_wspawn_rtg_seq extends VX_wspawn_doa_seq;

    `uvm_object_utils(VX_wspawn_rtg_seq)

    function new(string name="VX_wspawn_rtg_seq");
        super.new(name);
    
        if(!this.randomize())
            `VX_error(message_id, "Failed to randomize wspawn seq")
    
    endfunction

    constraint wspawn_seq_c {

        unique {warp_nums_reg, warp_pc_reg};

        warp_nums_reg inside {[1:RV_REGS - 1]};
        warp_pc_reg inside   {[2:RV_REGS - 1]};
        num_of_active_warps dist {0:=10, [1:`NUM_WARPS]:/90};
    }

endclass