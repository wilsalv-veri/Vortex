class VX_issue_agent extends uvm_agent;

    `uvm_component_utils(VX_issue_agent)

    VX_issue_monitor issue_monitor;

    function new(string name="VX_scoreboard_agent", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        issue_monitor = VX_issue_monitor::type_id::create("VX_issue_monitor", this);
    endfunction

endclass