class VX_tb_environment extends uvm_env;

    `uvm_component_utils(VX_tb_environment)

    VX_risc_v_agent      risc_v_agent;
    //VX_risc_v_scbd     risc_v_scbd;
     
    function new(string name="VX_tb_environment", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        risc_v_agent = VX_risc_v_agent::type_id::create("VX_risc_v_agent", this);
        //risc_v_scbd  = VX_risc_v_scbd::type_id::create("VX_risc_v_scbd", this);
    endfunction

    /*
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        risc_v_agent.risc_v_monitor.send_riscv_inst.connect(risc_v_scbd.receive_riscv_inst);
    endfunction
    */
endclass