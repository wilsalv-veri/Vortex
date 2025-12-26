class VX_execute_agent extends uvm_agent;

    `uvm_component_utils(VX_execute_agent)

    VX_execute_monitor execute_monitor;

    function new(string name="VX_execute_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        execute_monitor = VX_execute_monitor::type_id::create("VX_execute_monitor", this);
    endfunction
    
endclass