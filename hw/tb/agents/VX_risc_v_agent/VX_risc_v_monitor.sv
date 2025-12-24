class VX_risc_v_monitor extends uvm_monitor;

    `uvm_component_utils(VX_risc_v_monitor)

    function new(string name="VX_risc_v_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);    
    endtask

endclass