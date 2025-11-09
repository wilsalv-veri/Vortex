class VX_risc_v_monitor extends uvm_monitor;

    `uvm_component_utils(VX_risc_v_monitor)

    virtual VX_fetch_if fetch_if;

    function new(string name="VX_risc_v_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(! uvm_config_db #(virtual VX_fetch_if) ::get(this, "", "fetch_if", fetch_if))
            `VX_error("VX_RISC_V_MONITOR", "Failed to get access to fetch_if")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        //TODO: Change Condition
        phase.raise_objection(this);
            wait(fetch_if.valid);
            `VX_info("VX_RISC_V_MONITOR", "Observed Fetch Valid")
            #10; //Feq clks of delay to see what comes after
        phase.drop_objection(this);
    endtask

endclass