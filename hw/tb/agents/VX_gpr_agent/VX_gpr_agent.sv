class VX_gpr_agent extends uvm_agent;

    `uvm_component_utils(VX_gpr_agent)

    VX_gpr_monitor gpr_monitor;

    function new(string name="VX_grp_agent",uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        gpr_monitor = VX_gpr_monitor::type_id::create("VX_gpr_monitor",this);
    endfunction

endclass