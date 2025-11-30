class VX_risc_v_sequencer extends uvm_sequencer #(VX_risc_v_seq_item);

    `uvm_component_utils(VX_risc_v_sequencer)

    risc_v_seq_instr_address_t curr_pc = 0;
    uvm_blocking_put_port #(int) seq_num_inst_port;  
    uvm_blocking_put_port #(int) seq_lib_num_seqs_port; 
    VX_seq_result_txn_item seq_result_item;

    function new(string name="VX_risc_v_sequencer", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_num_inst_port     = new("SEQ_NUM_PUT_PORT", this);
        seq_lib_num_seqs_port = new("SEQ_LIB_NUM_SEQS_PORT",this);
        seq_result_item       = VX_seq_result_txn_item::type_id::create("VX_seq_result_txn_item");
    endfunction

endclass