class VX_gpr_monitor extends uvm_monitor;

    `uvm_component_utils(VX_gpr_monitor)

    VX_gpr_tb_txn_item gpr_info[`NUM_GPR_BANKS];
 
    uvm_analysis_port #(VX_gpr_tb_txn_item) gpr_info_analysis_port[`NUM_GPR_BANKS];

    function new(string name="VX_gpr_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        for(int bank_num=0; bank_num < `NUM_GPR_BANKS; bank_num++)begin
            gpr_info[bank_num] = VX_gpr_tb_txn_item::type_id::create($sformatf("VX_gpr_tb_txn_item_bank%od", bank_num));
            gpr_info_analysis_port[bank_num] = new($sformatf("GPR_MONITOR_ANALYSIS_PORT_BANK%0d",bank_num), this);
        end
       
        if(! uvm_config_db #(virtual VX_gpr_tb_if)::get(this,"","gpr_tb_if", gpr_tb_if))
            `VX_error("VX_GPR_MONITOR", "Failed to get access to gpr_tb_if")

    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        for(int idx=0; idx < `NUM_GPR_BANKS; idx++)begin
            automatic int bank_num = idx;
            fork
                get_gpr_info(bank_num);
            join_none
        end
    endtask

    virtual task  get_gpr_info(int bank_num);
        `VX_info("VX_GPR_MONITOR", $sformatf("Starting GET_GPR_INFO For BANK:%0d", bank_num))
           
        forever @ (gpr_tb_if.bank_set[bank_num]) begin
            
            if (gpr_tb_if.write_en[bank_num]) begin
                gpr_info[bank_num].bank_num           =  VX_seq_gpr_bank_num_t'(bank_num);
                gpr_info[bank_num].bank_set           =  gpr_tb_if.bank_set[bank_num];
                gpr_info[bank_num].byteen             =  gpr_tb_if.byteen[bank_num];
                gpr_info[bank_num].gpr_data_entry     =  gpr_tb_if.gpr_data_entry[bank_num];
                gpr_info_analysis_port[bank_num].write(gpr_info[bank_num]);
                `VX_info("VX_GPR_MONITOR", $sformatf("Sending GPR_INFO BANK:%0d SET:%0d", bank_num, gpr_tb_if.bank_set[bank_num]))
            end
        end
    endtask

endclass