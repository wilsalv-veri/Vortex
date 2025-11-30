import VX_tb_common_pkg::*;

class VX_risc_v_base_test extends uvm_test;

    `uvm_component_utils(VX_risc_v_base_test)

    VX_tb_environment  vx_tb_environment;
    VX_risc_v_base_seq risc_v_base_seq;
    
    virtual VX_uvm_test_if uvm_test_ifc;

    function new(string name="VX_risc_v_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        vx_tb_environment = VX_tb_environment::type_id::create("VX_tb_environment", this);
        risc_v_base_seq   = VX_risc_v_base_seq::type_id::create("VX_risc_v_base_seq");

        if(!uvm_config_db #(virtual VX_uvm_test_if)::get(this, "", "uvm_test_ifc", uvm_test_ifc))
            `VX_error("VX_RISC_V_BASE_TEST", "Failed to get access to VX_uvm_test_if")

    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        wait_for_seq_completion(phase);
        wait_for_core_idle(phase);
    endtask

    task wait_for_seq_completion(uvm_phase phase);
        phase.raise_objection(this);
            `VX_info("VX_RISC_V_BASE_TEST", "SEQUENCE STARTING")
            uvm_test_ifc.mem_load_seq_done = 1'b0;
            start_sequence();
            wait(vx_tb_environment.risc_v_agent.risc_v_driver.all_words_received());
            wait(vx_tb_environment.risc_v_agent.risc_v_driver.mem_load_ifc.load_valid);
            
            uvm_test_ifc.mem_load_seq_done = 1'b1;
        phase.drop_objection(this);
    endtask

    task wait_for_core_idle(uvm_phase phase);
        phase.raise_objection(this);
            wait(!uvm_test_ifc.core_busy);
            `VX_info("VX_RISC_V_BASE_TEST", "END_OF TEST")
        phase.drop_objection(this);
    endtask 

    virtual task start_sequence();
         risc_v_base_seq.start(vx_tb_environment.risc_v_agent.vx_risc_v_seqr);
    endtask

endclass