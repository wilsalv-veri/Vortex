class VX_risc_v_agent extends uvm_agent;

    `uvm_component_utils (VX_risc_v_agent)

    VX_risc_v_driver                     risc_v_driver;
    VX_risc_v_sequencer                  vx_risc_v_seqr;

    uvm_tlm_fifo #(int) seq_num_inst_fifo;

    function new(string name="VX_risc_v_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        risc_v_driver    = VX_risc_v_driver::type_id::create("VX_risc_v_driver", this);
        vx_risc_v_seqr   = VX_risc_v_sequencer::type_id::create("VX_risc_v_seqr", this);
        
        seq_num_inst_fifo = new("SEQ_NUM_INST_FIFO", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        risc_v_driver.seq_item_port.connect(vx_risc_v_seqr.seq_item_export);
        
        vx_risc_v_seqr.seq_num_inst_port.connect(seq_num_inst_fifo.put_export);
        risc_v_driver.receive_seq_num_insts.connect(seq_num_inst_fifo.get_peek_export);
        
        vx_risc_v_seqr.seq_lib_num_seqs_port.connect(risc_v_driver.receive_seq_lib_seq_num);
    endfunction
    
endclass