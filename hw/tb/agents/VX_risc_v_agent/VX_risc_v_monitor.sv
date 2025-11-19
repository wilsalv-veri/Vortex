class VX_risc_v_monitor extends uvm_monitor;

    `uvm_component_utils(VX_risc_v_monitor)

    function new(string name="VX_risc_v_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(! uvm_config_db #(virtual VX_fetch_if) ::get(this, "", "fetch_if", fetch_if))
            `VX_error("VX_RISC_V_MONITOR", "Failed to get access to fetch_if")
        
        if(! uvm_config_db #(virtual VX_decode_if) ::get(this, "", "decode_if", decode_if))
            `VX_error("VX_RISC_V_MONITOR", "Failed to get access to decode_if")
    
        if(! uvm_config_db #(virtual VX_warp_ctl_if) ::get(this, "", "warp_ctl_if", warp_ctl_if))
            `VX_error("VX_RISC_V_MONITOR", "Failed to get access to warp_ctl_if")
    
        for( int idx=0; idx < `ISSUE_WIDTH; idx++) begin
            if(! uvm_config_db #(virtual VX_writeback_if) ::get(this, "", $sformatf("writeback_if[%0d]", idx), writeback_if[idx]))
                `VX_error("VX_RISC_V_MONITOR", "Failed to get access to writeback_if")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);    
    endtask

endclass