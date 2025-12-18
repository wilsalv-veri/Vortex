class VX_execute_monitor extends uvm_monitor;

    `uvm_component_utils(VX_execute_monitor)

    string message_id = "VX_EXECUTE_MONITOR";
    
    VX_alu_tb_txn_item alu_tb_item;
    
    virtual VX_result_if alu_block_result_if[`VX_PE_COUNT];

    uvm_analysis_port #(VX_alu_tb_txn_item) alu_analysis_port;

    function new (string name="VX_execute_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        alu_tb_item = VX_alu_tb_txn_item::type_id::create("VX_alu_tb_item");
        alu_analysis_port = new("ALU_ANALYSIS_PORT", this);

        for(int pe_num = 0; pe_num < `VX_PE_COUNT; pe_num++)begin
            if(!uvm_config_db #(virtual VX_result_if)::get(this, "", $sformatf("alu_result_if[%0d]", pe_num), alu_block_result_if[pe_num]))
                `VX_error(message_id, $sformatf("Failed to get access for alu_result_if[%0d]", pe_num))
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        fork 
            for(int idx=0; idx < `VX_PE_COUNT; idx++)begin
                automatic int pe_num = idx;
                fork 
                    get_alu_info(pe_num);
                join_none
            end

        join_none
    endtask

    virtual task get_alu_info(int pe_num);
        `VX_info(message_id, $sformatf("Starting GET_ALU_INFO for PE_IDX: %0d",pe_num))
    
        forever @(posedge alu_block_result_if[pe_num].valid)begin
            alu_tb_item.pc     = alu_block_result_if[pe_num].data.PC;
            alu_tb_item.rd     = alu_block_result_if[pe_num].data.rd;
            alu_tb_item.wid    = alu_block_result_if[pe_num].data.wid;
            alu_tb_item.tmask  = alu_block_result_if[pe_num].data.tmask;
            alu_tb_item.wb     = alu_block_result_if[pe_num].data.wb;
            alu_tb_item.data   = alu_block_result_if[pe_num].data.data;
            alu_analysis_port.write(alu_tb_item);
        end
    endtask 

endclass