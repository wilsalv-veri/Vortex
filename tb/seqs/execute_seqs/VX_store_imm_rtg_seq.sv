class VX_store_imm_rtg_seq extends VX_store_imm_doa_seq;

    `uvm_object_utils(VX_store_imm_rtg_seq)

    function new(string name="VX_store_imm_rtg_seq");
        super.new(name);

        message_id = "VX_STORE_IMM_RTG_SEQ";

        if (!this.randomize())
            `VX_error(message_id, "Failed to randomize VX_store_imm_rtg_seq")
        else 
            `VX_info(message_id, $sformatf("Randomized VX_store_imm_rtg_seq with ST_TYPE: %0s RS1: %0d RS2: %0d ADD_IMM: 0x%0h LD_DST: %0d", st_instr_type.name(), st_src1_reg, st_src2_reg, add_imm, ld_dst_reg))
    
    endfunction

    constraint store_imm_seq_c {
        st_src1_reg      inside {[1:RV_REGS - 1]};
        st_src2_reg      inside {[1:RV_REGS - 1]};
        ld_dst_reg       inside {[1:RV_REGS - 1]};

        unique {st_src2_reg, ld_dst_reg};
        load_store_imm   ==     INSTR_SEG_SIZE;
        add_imm          inside {[0: `I_TYPE_IMM_WIDTH'hfff]};
    }

endclass