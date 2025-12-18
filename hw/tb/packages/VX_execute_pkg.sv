`ifndef VX_EXECUTE_PKG_VH
`define VX_EXECUTE_PKG_VH

package VX_execute_pkg;

    import uvm_pkg::*;
    import VX_gpu_pkg::*;
    import VX_tb_common_pkg::*;
    import VX_gpr_pkg::*;
    
    `include "VX_alu_txn_item.sv"

    `include "VX_execute_monitor.sv"
    `include "VX_execute_agent.sv"
    `include "VX_alu_scbd.sv"

    function risc_v_seq_funct3_t get_arith_funct3(string arith_instr_name);
        risc_v_seq_funct3_t funct3;

        case(arith_instr_name)
            "ADD":    funct3 = `FUNCT3_WIDTH'b000;
            "SUB":    funct3 = `FUNCT3_WIDTH'b000;
            "SLL":    funct3 = `FUNCT3_WIDTH'b001;
            "SLT":    funct3 = `FUNCT3_WIDTH'b010;
            "SLTU":   funct3 = `FUNCT3_WIDTH'b011;
            "XOR":    funct3 = `FUNCT3_WIDTH'b100;
            "SRL":    funct3 = `FUNCT3_WIDTH'b101;
            "SRA":    funct3 = `FUNCT3_WIDTH'b101;
            "OR":     funct3 = `FUNCT3_WIDTH'b110;          
            "AND":    funct3 = `FUNCT3_WIDTH'b111;
            "MUL":    funct3 = `FUNCT3_WIDTH'b000;
            "MULH":   funct3 = `FUNCT3_WIDTH'b001;
            "MULHSU": funct3 = `FUNCT3_WIDTH'b010;
            "MULHU":  funct3 = `FUNCT3_WIDTH'b011;
            "DIV":    funct3 = `FUNCT3_WIDTH'b100;
            "DIVU":   funct3 = `FUNCT3_WIDTH'b101;
            "REM":    funct3 = `FUNCT3_WIDTH'b110;              
            "REMU":   funct3 = `FUNCT3_WIDTH'b111;
        endcase

        return funct3;
    endfunction

    function risc_v_seq_funct3_t get_arith_imm_funct3(string arith_imm_instr_name);
        risc_v_seq_funct3_t funct3;

        case(arith_imm_instr_name)
            "ADDI":    funct3 =  `FUNCT3_WIDTH'b000;
            "SLTI":    funct3 =  `FUNCT3_WIDTH'b010;
            "SLTIU":   funct3 =  `FUNCT3_WIDTH'b011;
            "XORI":    funct3 =  `FUNCT3_WIDTH'b100;
            "ORI":     funct3 =  `FUNCT3_WIDTH'b110;          
            "ANDI":    funct3 =  `FUNCT3_WIDTH'b111;
            "SLLI":    funct3 =  `FUNCT3_WIDTH'b001;
            "SRLI":    funct3 =  `FUNCT3_WIDTH'b101;
            "SRAI":    funct3 =  `FUNCT3_WIDTH'b101;
        endcase

        return funct3;
    endfunction

    function risc_v_seq_funct3_t get_vote_funct3(string vote_instr_name);
        risc_v_seq_funct3_t funct3;

        case(vote_instr_name)
            "VOTE_ALL": funct3 = `FUNCT3_WIDTH'b000;
            "VOTE_ANY": funct3 = `FUNCT3_WIDTH'b001;
            "VOTE_UNI": funct3 = `FUNCT3_WIDTH'b010;
            "VOTE_BAL": funct3 = `FUNCT3_WIDTH'b011;
        endcase

        return funct3;
    endfunction

    function risc_v_seq_funct3_t get_shift_funct3(string shift_instr_name);
        risc_v_seq_funct3_t funct3;

        case(shift_instr_name)
            "SLL":  funct3 = `FUNCT3_WIDTH'b001;
            "SRL":  funct3 = `FUNCT3_WIDTH'b101;
            "SRA":  funct3 = `FUNCT3_WIDTH'b101;
            "SLLI": funct3 = `FUNCT3_WIDTH'b001;
            "SRLI": funct3 = `FUNCT3_WIDTH'b101;
            "SRAI": funct3 = `FUNCT3_WIDTH'b101;
        endcase

        return funct3;
    endfunction

    function risc_v_seq_funct7_t get_arith_funct7(string arith_instr_name);
        risc_v_seq_funct7_t funct7;

        case(arith_instr_name)
            "ADD":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SUB":    funct7 = `FUNCT7_WIDTH'b0100000;
            "SLL":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SLT":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SLTU":   funct7 = `FUNCT7_WIDTH'b0000000;
            "XOR":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SRL":    funct7 = `FUNCT7_WIDTH'b0000000;
            "SRA":    funct7 = `FUNCT7_WIDTH'b0100000;
            "OR":     funct7 = `FUNCT7_WIDTH'b0000000;          
            "AND":    funct7 = `FUNCT7_WIDTH'b0000000;
            "MUL":    funct7 = `FUNCT7_WIDTH'b0000001;
            "MULH":   funct7 = `FUNCT7_WIDTH'b0000001;
            "MULHSU": funct7 = `FUNCT7_WIDTH'b0000001;
            "MULHU":  funct7 = `FUNCT7_WIDTH'b0000001;
            "DIV":    funct7 = `FUNCT7_WIDTH'b0000001;
            "DIVU":   funct7 = `FUNCT7_WIDTH'b0000001;
            "REM":    funct7 = `FUNCT7_WIDTH'b0000001;              
            "REMU":   funct7 = `FUNCT7_WIDTH'b0000001;
        
        endcase
        
        return funct7;
    endfunction

endpackage

`endif //VX_EXECUTE_PKG_VX