import VX_tb_common_pkg::*; 

class VX_risc_v_base_seq extends uvm_sequence #(VX_risc_v_inst_item);

    `uvm_object_utils(VX_risc_v_base_seq)

    `uvm_declare_p_sequencer(VX_risc_v_sequencer)
    
    rand int num_of_cachelines;
    VX_risc_v_inst_item risc_v_inst;
    
    function new(string name="VX_risc_v_base_seq");
        super.new(name);

        if (!this.randomize())
            `VX_info("VX_RISC_V_BASE_SEQ", $sformatf("Failed to Randomize VX_risc_v_base_seq object!"))
        
    endfunction

    constraint sequence_c {
        num_of_cachelines inside {[0:5]};
    }

    task body(); 
        `VX_info("[VX_RISC_V_BASE_SEQ]", "Starting Sequence") 
        p_sequencer.seq_num_inst_port.put(num_of_cachelines);  
    endtask

endclass