class VX_risc_v_sequencer extends uvm_sequencer #(VX_risc_v_inst_item);

    `uvm_component_utils(VX_risc_v_sequencer)

    uvm_blocking_put_port #(int) seq_num_inst_port;   

    function new(string name="VX_risc_v_sequencer", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_num_inst_port = new("SEQ_NUM_PUT_PORT", this);
    endfunction


endclass