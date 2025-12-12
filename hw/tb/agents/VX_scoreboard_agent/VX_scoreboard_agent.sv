class VX_scoreboard_agent extends uvm_agent;

    `uvm_component_utils(VX_scoreboard_agent)

    VX_scoreboard_monitor scoreboard_monitor;

    function new(string name="VX_scoreboard_agent", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_monitor = VX_scoreboard_monitor::type_id::create("VX_scoreboard_monitor", this);
    endfunction

endclass