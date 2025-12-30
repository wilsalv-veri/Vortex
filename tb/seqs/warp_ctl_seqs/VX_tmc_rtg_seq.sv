class VX_tmc_rtg_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_tmc_rtg_seq)

    rand VX_tmask_t           thread_mask;
    rand risc_v_seq_reg_num_t src_reg;
    rand risc_v_seq_reg_num_t dst_reg;
    rand int                  num_of_iterations;
    rand int                  imm_add;

    function new(string name="VX_tmc_rtg_seq");
        super.new(name);
        
        `VX_info("VX_TMC_RTG_SEQ", "SEQUENCE CREATED")

        if (!this.randomize())
            `VX_error("VX_TMC_RTG_SEQ", "Failed to randomize sequence")
        else begin
            `VX_info("VX_TMC_RTG_SEQ", $sformatf("Number of Iterations Selected: %0d", num_of_iterations))
        end
    endfunction

    constraint tmc_seq_operands_c {
        src_reg inside {[2:RV_REGS - 1]};
        dst_reg inside {[2:RV_REGS - 1]};
        imm_add inside {[0:15]};
        num_of_iterations inside {[2:10]};
    }
 
    virtual function void add_instructions(); 
        num_of_iterations.rand_mode(0);
        instr_queue.push_back(`ADDI(`RS1(src_reg),`IMM_BIN(thread_mask),`RD(dst_reg)));
        instr_queue.push_back(`TMC(`RS1(src_reg))); 
           
        for(int iter_num = 0; iter_num < num_of_iterations;iter_num++) begin
            instr_queue.push_back(`ADDI(`RS1(src_reg),`IMM_BIN(imm_add),`RD(dst_reg)));
            instr_queue.push_back(`TMC(`RS1(dst_reg))); 
            
            if (!this.randomize())
                `VX_error("VX_TMC_RTG_SEQ", "Failed to randomize tmc_rtg_seq")
        end
    endfunction

endclass
