class VX_risc_v_base_seq_lib_test extends VX_risc_v_base_test;

    `uvm_component_utils(VX_risc_v_base_seq_lib_test)

    VX_risc_v_base_seq_lib risc_v_base_seq_lib;

    string message_id = "VX_RISC_V_BASE_SEQ_LIB_TEST";

    function new(string name="VX_risc_v_base_seq_lib_test", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        risc_v_base_seq_lib = VX_risc_v_base_seq_lib::type_id::create("VX_risc_v_base_seq_lib");
        init_seq_lib_parameters();
    endfunction

    virtual task start_sequence();
        risc_v_base_seq_lib.start(vx_tb_environment.risc_v_agent.vx_risc_v_seqr);
    endtask

    virtual function void init_seq_lib_parameters();
        set_selection_mode(UVM_SEQ_LIB_USER);
        risc_v_base_seq_lib.min_random_count = 1;
        risc_v_base_seq_lib.max_random_count = 1000;
        `VX_info(message_id, "Initialized Sequence Library")
    endfunction

    virtual function void set_selection_mode(uvm_sequence_lib_mode seq_mode);
        risc_v_base_seq_lib.selection_mode = seq_mode;
    endfunction

endclass