class VX_bar_rtg_seq extends VX_bar_doa_seq;

    `uvm_object_utils (VX_bar_rtg_seq)

    function new(string name="VX_bar_rtg_seq");
        super.new(name);

        if(!this.randomize())
            `VX_error(message_id, "Failed to randomize barrier seq")
    
    endfunction

    constraint bar_seq_c {
        unique {bar_id_num_reg,bar_warp_num_reg};
        bar_id_num_reg   inside {[2:RV_REGS - 1]};
        bar_warp_num_reg inside {[2:RV_REGS - 1]};
        bar_id           dist   {[0:1]:/50};
        is_global        dist   {0:=20, 1:=80};
    }
endclass