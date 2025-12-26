class VX_arithmetic_imm_rtg_seq extends VX_arithmetic_imm_doa_seq;

    `uvm_object_utils(VX_arithmetic_imm_rtg_seq)

    string mesagge_id = "VX_ARITHMETIC_IMM_RTG_SEQ";

    function new(string name="VX_arithmetic_imm_rtg_seq");
        super.new(name);

        if(!this.randomize())
            `VX_error(message_id, "Failed to randomize VX_arithmetic_imm_rtg_seq")
        else begin
            `VX_info(message_id, $sformatf("Running VX_arithmetc_imm_rtg_seq with operation %0s on SRC1: 0x%0h IMM: 0x%0h RD: 0x%0h", 
            arith_imm_instr_type.name(), src1_reg, imm, dst_reg));
        
        end
    endfunction

    constraint arithmetinc_imm_instr_operands_c {
        
        src1_reg inside {[1:RV_REGS - 1]};
        dst_reg inside  {[1:RV_REGS - 1]};
        imm       <= 12'hFFF;
        unique {src1_reg, dst_reg};
    }

endclass