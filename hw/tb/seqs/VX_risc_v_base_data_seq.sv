import VX_tb_common_pkg::*; 

class VX_risc_v_base_data_seq extends VX_risc_v_base_seq;

    `uvm_object_utils(VX_risc_v_base_data_seq)

    
    function new(string name="VX_risc_v_base_data_seq");
        super.new(name);

        if (!this.randomize())
            `VX_info("VX_RISC_V_BASE_SEQ", $sformatf("Failed to Randomize VX_risc_v_base_data_seq object!"))
        
    endfunction

    task body(); 
        num_of_cachelines = 1;

        super.body();
        
        risc_v_inst = VX_risc_v_inst_item::type_id::create($sformatf("riscv_inst_data%0d", 0));
               
        start_item(risc_v_inst);
            `VX_info("VX_RISC_V_BASE_SEQ", "Sequencer Grant Received!")
            risc_v_inst.inst_type = DATA_TYPE;
            risc_v_inst.program_data    = 32'hcafebabe;
        finish_item(risc_v_inst);
        `VX_info("VX_RISC_V_BASE_SEQ", "Instruction Sent!")
    endtask

endclass
