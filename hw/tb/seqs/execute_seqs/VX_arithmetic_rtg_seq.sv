class VX_arithmetic_rtg_seq extends VX_arithmetic_doa_seq;

    `uvm_object_utils(VX_arithmetic_rtg_seq)

    function new(string name="VX_arithmetic_rtg_seq");
        super.new(name);

        message_id = "VX_ARITHMETIC_RTG_SEQ";
        
        if (!this.randomize())
            `VX_error(message_id, "Failed to randomize VX_arithmetic_rtg_seq")
        else begin
            `VX_info(message_id, $sformatf("Running VX_arithmetc_rtg_seq with operation %0s on SRC1: 0x%0h SRC2: 0x%0h RD: 0x%0h", 
            arith_instr_type.name(), src1_reg, src2_reg, dst_reg));
        
        end

    endfunction

    constraint arithmetinc_instr_operands_c {
        
        src1_reg inside {[1:RV_REGS]};
        src2_reg inside {[1:RV_REGS]};
        dst_reg inside  {[1:RV_REGS]};
        
        unique {src1_reg, src2_reg, dst_reg};
    }
endclass