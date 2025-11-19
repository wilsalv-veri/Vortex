import VX_tb_common_pkg::*;
   
class VX_tmc_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_tmc_doa_seq)

    rand bit [3:0] predicate;

    function new(string name="VX_tmc_doa_seq");
        super.new(name);
        `VX_info("VX_TMC_DOA_SEQ", "SEQUENCE CREATED")
    endfunction
 
    virtual function void add_instructions();  
        instr_queue.push_back(`ADDI(`RS1(2),`IMM_HEX(f),`RD(2)));
        instr_queue.push_back(`TMC(`RS1(2))); 
    endfunction

endclass
