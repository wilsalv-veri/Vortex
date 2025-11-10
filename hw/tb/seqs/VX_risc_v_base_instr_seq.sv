import VX_tb_common_pkg::*; 

class VX_risc_v_base_instr_seq extends VX_risc_v_base_seq;

    `uvm_object_utils(VX_risc_v_base_instr_seq)

    
    function new(string name="VX_risc_v_base_instr_seq");
        super.new(name);

        if (!this.randomize())
            `VX_info("VX_RISC_V_BASE_SEQ", $sformatf("Failed to Randomize VX_risc_v_base_instr_seq object!"))
        
    endfunction

    task body(); 
        num_of_cachelines = 1;

        super.body();
        
                                             //2000f133
        //localparam inst0               = { 7'b0010000,5'b0,5'b1 ,3'b111,5'b10, 7'b0110011};
        risc_v_inst = VX_risc_v_inst_item::type_id::create($sformatf("riscv_inst%0d", 0));
               
        start_item(risc_v_inst);
            `VX_info("VX_RISC_V_BASE_SEQ", "Sequencer Grant Received!")

            risc_v_inst.inst_type = R_TYPE;
            risc_v_inst.opcode    = 7'b0110011;
            risc_v_inst.rd        = 5'b10;
            risc_v_inst.funct3    = 3'b111;
            risc_v_inst.rs1       = 5'b1;
            risc_v_inst.rs2       = 5'b0;
            risc_v_inst.funct7    = 7'b0010000;
        finish_item(risc_v_inst);
        `VX_info("VX_RISC_V_BASE_SEQ", "Instruction Sent!")

        
        //TODO: Enable Multiple Instruction/Cacheline Sequence
        /*
        p_sequencer.seq_num_inst_port.put(num_of_cachelines*INST_PER_CACHE_LINE);  
       
        for (int cache_line_idx=0; cache_line_idx < num_of_cachelines; cache_line_idx)begin 
            for(int inst_num = 0 ; inst_num < INST_PER_CACHE_LINE; inst_num++)begin
                risc_v_inst = VX_risc_v_inst_item::type_id::create($sformatf("riscv_inst%0d", inst_num));
                start_item(risc_v_inst);
                assert(risc_v_inst.randomize());
                finish_item(risc_v_inst);
            end
        end*/    
    

    endtask

endclass
