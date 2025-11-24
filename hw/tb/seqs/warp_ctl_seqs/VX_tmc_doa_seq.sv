import VX_tb_common_pkg::*;
   
class VX_tmc_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_tmc_doa_seq)

    rand bit [3:0] thread_mask;

    function new(string name="VX_tmc_doa_seq");
        super.new(name);
        
        `VX_info("VX_TMC_DOA_SEQ", "SEQUENCE CREATED")

        if (!this.randomize())
            `VX_error("VX_TMC_DOA_SEQ", "Failed to randomize sequence")
        else
            `VX_info("VX_TMC_DOA_SEQ", $sformatf("Thread Mask: 4'b%0b", thread_mask))
    endfunction
 
    virtual function void add_instructions();  
        //thread_mask
        instr_queue.push_back(`ADDI(`RS1(2),`IMM_BIN(thread_mask),`RD(2)));
        instr_queue.push_back(`TMC(`RS1(2))); 
        instr_queue.push_back(`ADDI(`RS1(2),`IMM_HEX(2),`RD(3)));
        instr_queue.push_back(`TMC(`RS1(3))); 
    endfunction

endclass
