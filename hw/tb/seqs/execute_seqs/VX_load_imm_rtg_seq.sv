class VX_load_imm_rtg_seq extends VX_load_imm_doa_seq;

    `uvm_object_utils(VX_load_imm_rtg_seq)

    function new(string name="VX_load_imm_rtg_seq");
        super.new(name);

        message_id = "VX_LOAD_IMM_RTG_SEQ";

        if (!this.randomize())
            `VX_error(message_id, "Failed to randomize VX_load_imm_rtg_seq")
        else 
            `VX_info(message_id, $sformatf("Randomized VX_load_imm_rtg_seq with LD_TYPE: %0s RS1: %0d RD: %0d", ld_instr_type.name(), src1_reg, dst_reg))
    
    endfunction

    constraint load_imm_seq_c {
        ld_instr_type;
        src1_reg      inside {[1:RV_REGS - 1]};
        dst_reg       inside {[1:RV_REGS - 1]};
        load_imm      == INSTR_SEG_SIZE;
    }

endclass