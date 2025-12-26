class VX_sched_agent extends uvm_agent;

    `uvm_component_utils(VX_sched_agent)

    VX_sched_monitor sched_monitor;

    function new(string name="VX_sched_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sched_monitor = VX_sched_monitor::type_id::create("VX_sched_monitor",this);
    endfunction
    
endclass
