class VX_gpr_monitor extends uvm_monitor;

    `uvm_component_utils(VX_gpr_monitor)

    VX_gpr_tb_txn_item          gpr_info[`SOCKET_SIZE][`NUM_GPR_BANKS];
    virtual VX_gpr_tb_if        gpr_tb_if[`SOCKET_SIZE];
   
    uvm_analysis_port #(VX_gpr_tb_txn_item) gpr_info_analysis_port[`SOCKET_SIZE][`NUM_GPR_BANKS];

    function new(string name="VX_gpr_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        for(int core_id=0; core_id < `SOCKET_SIZE; core_id++)begin
    
            for(int bank_num=0; bank_num < `NUM_GPR_BANKS; bank_num++)begin
                gpr_info[core_id][bank_num] = VX_gpr_tb_txn_item::type_id::create($sformatf("core[%0d].VX_gpr_tb_txn_item_bank%0d", core_id, bank_num));
                gpr_info_analysis_port[core_id][bank_num] = new($sformatf("core[%0d].GPR_MONITOR_ANALYSIS_PORT_BANK%0d", core_id, bank_num), this);
            end
        
            if(! uvm_config_db #(virtual VX_gpr_tb_if)::get(this,"", $sformatf("core[%0d].gpr_tb_if", core_id), gpr_tb_if[core_id]))
            `VX_error("VX_GPR_MONITOR", $sformatf("Failed to get access to core[%0d].gpr_tb_if",core_id))
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        for(int id=0; id < `SOCKET_SIZE; id++)begin
            automatic int core_id = id;
            for(int idx=0; idx < `NUM_GPR_BANKS; idx++)begin
                automatic int bank_num = idx;
                fork
                    get_gpr_info(core_id, bank_num);
                join_none
            end
        end
    endtask

    virtual task  get_gpr_info(int core_id, int bank_num);
        `VX_info("VX_GPR_MONITOR", $sformatf("Starting GET_GPR_INFO For BANK:%0d", bank_num))
           
        forever @ (gpr_tb_if[core_id].wr_bank_set[bank_num]) begin
            
            if (gpr_tb_if[core_id].write_en[bank_num]) begin
                gpr_info[core_id][bank_num].core_id            =  core_id;
                gpr_info[core_id][bank_num].bank_num           =  VX_seq_gpr_bank_num_t'(bank_num);
                gpr_info[core_id][bank_num].bank_set           =  gpr_tb_if[core_id].wr_bank_set[bank_num];
                gpr_info[core_id][bank_num].byteen             =  gpr_tb_if[core_id].wr_byteen[bank_num];
                gpr_info[core_id][bank_num].gpr_data_entry     =  gpr_tb_if[core_id].wr_gpr_data_entry[bank_num];
                gpr_info_analysis_port[core_id][bank_num].write(gpr_info[core_id][bank_num]);
                `VX_info("VX_GPR_MONITOR", $sformatf("Sending GPR_INFO CORE: %0d BANK:%0d SET:%0d", core_id, bank_num, gpr_tb_if[core_id].wr_bank_set[bank_num]))
            end
        end
    endtask

endclass