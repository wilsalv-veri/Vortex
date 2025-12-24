class VX_execute_monitor extends uvm_monitor;

    `uvm_component_utils(VX_execute_monitor)

    string message_id = "VX_EXECUTE_MONITOR";
    
    VX_alu_tb_txn_item                         alu_tb_item[`SOCKET_SIZE];
    virtual VX_result_if                       alu_block_result_if[`SOCKET_SIZE][`VX_PE_COUNT];
     
    VX_lsu_tb_txn_item                         lsu_tb_item[`SOCKET_SIZE][`NUM_LSU_BLOCKS];
    virtual VX_lsu_mem_if #( .NUM_LANES (`NUM_LSU_LANES),
                             .DATA_SIZE (LSU_WORD_SIZE),
                             .TAG_WIDTH (LSU_TAG_WIDTH))
                                                lsu_mem_if [`SOCKET_SIZE][`NUM_LSU_BLOCKS];
  
    VX_commit_tb_txn_item                      commit_tb_item[`SOCKET_SIZE][`ISSUE_WIDTH];
    virtual VX_commit_if                       commit_if [`SOCKET_SIZE][`ISSUE_WIDTH];
    virtual VX_dispatch_if                     dispatch_if[`SOCKET_SIZE][`ISSUE_WIDTH];

    uvm_analysis_port #(VX_alu_tb_txn_item)    alu_analysis_port[`SOCKET_SIZE];
    uvm_analysis_port #(VX_lsu_tb_txn_item)    lsu_analysis_port[`SOCKET_SIZE];

    uvm_analysis_port #(VX_commit_tb_txn_item) commit_analysis_port[`SOCKET_SIZE];

    int lsu_commit_start_idx;  
    int lsu_commit_end_idx;    

    function new (string name="VX_execute_monitor", uvm_component parent=null);
        super.new(name, parent);

        lsu_commit_start_idx   = EX_LSU * `ISSUE_WIDTH;
        lsu_commit_end_idx     = lsu_commit_start_idx + `ISSUE_WIDTH;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        
        for(int core_id=0; core_id < `SOCKET_SIZE; core_id++)begin
            
            alu_tb_item[core_id]          = VX_alu_tb_txn_item::type_id::create("VX_alu_tb_item");
         
            alu_analysis_port[core_id]    = new($sformatf("core[%0d].ALU_ANALYSIS_PORT",   core_id), this);
            lsu_analysis_port[core_id]    = new($sformatf("core[%0d].LSU_ANALYSIS_PORT",   core_id), this);
            commit_analysis_port[core_id] = new($sformatf("core[%0d].COMMIT_ANALYSIS_PORT",core_id), this);

            
            for(int pe_num = 0; pe_num < `VX_PE_COUNT; pe_num++)begin
                if(!uvm_config_db #(virtual VX_result_if)::get(this, "", $sformatf("core[%0d].alu_result_if[%0d]", core_id, pe_num), alu_block_result_if[core_id][pe_num]))
                    `VX_error(message_id, $sformatf("Failed to get access for core[%0d].alu_result_if[%0d]", core_id, pe_num))
            end

            for(int lsu_block=0; lsu_block < `NUM_LSU_BLOCKS; lsu_block++) begin

                lsu_tb_item[core_id][lsu_block] = VX_lsu_tb_txn_item::type_id::create($sformatf("core[%0d].VX_lsu_tb_txn_item[%0d]", core_id, lsu_block));

                if (!uvm_config_db #(virtual VX_lsu_mem_if #( .NUM_LANES (`NUM_LSU_LANES),
                                                              .DATA_SIZE (LSU_WORD_SIZE),
                                                              .TAG_WIDTH (LSU_TAG_WIDTH)))
                                                              ::get(this, "", $sformatf("core[%0d].lsu_mem_if[%0d]", core_id, lsu_block), lsu_mem_if[core_id][lsu_block]))
                    `VX_error(message_id, $sformatf("Failed to get access for core[%0d].lsu_mem_if[%0d]", core_id, lsu_block))
            end                                                                      
        
            for(int lsu_commit_idx=lsu_commit_start_idx, virt_commit_if_idx=0_; lsu_commit_idx < lsu_commit_end_idx; lsu_commit_idx++, virt_commit_if_idx++)begin

                commit_tb_item[core_id][virt_commit_if_idx] = VX_commit_tb_txn_item::type_id::create($sformatf("core[%0d].VX_commit_tb_txn_item[%0d]", core_id, virt_commit_if_idx));

                if( !uvm_config_db #(virtual VX_commit_if)::get (this, "", $sformatf("core[%0d].commit_if[%0d]", core_id, lsu_commit_idx),commit_if[core_id][virt_commit_if_idx]))
                    `VX_error(message_id, $sformatf("Failed to get access for core[%0d].commit_if[%0d]", core_id, lsu_commit_idx))
            
                if( !uvm_config_db #(virtual VX_dispatch_if)::get (this, "", $sformatf("core[%0d].dispatch_if[%0d]", core_id, lsu_commit_idx),dispatch_if[core_id][virt_commit_if_idx]))
                    `VX_error(message_id, $sformatf("Failed to get access for core[%0d].dispatch_if[%0d]", core_id, lsu_commit_idx))
            
            end
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        for(int id=0; id < `SOCKET_SIZE; id++)begin
            automatic int core_id = id;
            fork 
                for(int idx=0; idx < `VX_PE_COUNT; idx++)begin
                    automatic int pe_num = idx;
                    fork 
                        get_alu_info(core_id, pe_num);
                    join_none
                end
                for(int idx=0; idx < `NUM_LSU_BLOCKS; idx++)begin
                    automatic int lsu_block = idx;
                    fork 
                        get_lsu_info(core_id, lsu_block);
                    join_none
                end
            
                for(int idx=lsu_commit_start_idx, jdx=0; idx < lsu_commit_end_idx; idx++, jdx++)begin
                    automatic int lsu_commit_idx = jdx;
                    fork
                        get_commit_info(core_id, lsu_commit_idx);
                    join_none
                end

            join_none
        end
    endtask

    virtual task get_alu_info(int core_id, int pe_num);
        `VX_info(message_id, $sformatf("Starting GET_ALU_INFO for PE_IDX: %0d",pe_num))
    
        forever @(posedge alu_block_result_if[core_id][pe_num].valid)begin
            alu_tb_item[core_id].core_id = core_id;
            alu_tb_item[core_id].pc      = alu_block_result_if[core_id][pe_num].data.PC;
            alu_tb_item[core_id].rd      = alu_block_result_if[core_id][pe_num].data.rd;
            alu_tb_item[core_id].wid     = alu_block_result_if[core_id][pe_num].data.wid;
            alu_tb_item[core_id].tmask   = alu_block_result_if[core_id][pe_num].data.tmask;
            alu_tb_item[core_id].wb      = alu_block_result_if[core_id][pe_num].data.wb;
            alu_tb_item[core_id].data    = alu_block_result_if[core_id][pe_num].data.data;
            alu_analysis_port[core_id].write(alu_tb_item[core_id]);
        end
    endtask 

    virtual task get_lsu_info(int core_id, int lsu_block);
        `VX_info(message_id, $sformatf("Starting GET_LSU_INFO for CORE: %0d LSU_BLOCK: %0d", core_id, lsu_block))

        fork 
            forever @(posedge lsu_mem_if[core_id][lsu_block].req_valid)begin
                lsu_tb_item[core_id][lsu_block].core_id       = core_id;
                lsu_tb_item[core_id][lsu_block].req_mask      = lsu_mem_if[core_id][lsu_block].req_data.mask;
                lsu_tb_item[core_id][lsu_block].req_addresses = lsu_mem_if[core_id][lsu_block].req_data.addr;
                lsu_tb_item[core_id][lsu_block].req_byteen    = lsu_mem_if[core_id][lsu_block].req_data.byteen;
                lsu_tb_item[core_id][lsu_block].req_data      = lsu_mem_if[core_id][lsu_block].req_data.data;
            end

            forever @(posedge lsu_mem_if[core_id][lsu_block].rsp_valid)begin
                lsu_tb_item[core_id][lsu_block].rsp_mask =  lsu_mem_if[core_id][lsu_block].rsp_data.mask;
                lsu_tb_item[core_id][lsu_block].rsp_data = lsu_mem_if[core_id][lsu_block].rsp_data.data;
                lsu_analysis_port[core_id].write(lsu_tb_item[core_id][lsu_block]);    
            end
        join_none
  
    endtask

    virtual task get_commit_info(int core_id, int lsu_commit_idx);
        `VX_info(message_id, $sformatf("Starting GET_COMMIT_INFO LSU_COMMIT_IDX: %0d", lsu_commit_idx))

        forever @(posedge commit_if[core_id][lsu_commit_idx].valid)begin  
            commit_tb_item[core_id][lsu_commit_idx].core_id = core_id;
            commit_tb_item[core_id][lsu_commit_idx].pc      = commit_if[core_id][lsu_commit_idx].data.PC;
            commit_tb_item[core_id][lsu_commit_idx].wid     = commit_if[core_id][lsu_commit_idx].data.wid;
            commit_tb_item[core_id][lsu_commit_idx].tmask   = commit_if[core_id][lsu_commit_idx].data.tmask;
            commit_tb_item[core_id][lsu_commit_idx].wb      = commit_if[core_id][lsu_commit_idx].data.wb;
            commit_tb_item[core_id][lsu_commit_idx].rd      = commit_if[core_id][lsu_commit_idx].data.rd;
            commit_tb_item[core_id][lsu_commit_idx].data    = commit_if[core_id][lsu_commit_idx].data.data;
            commit_analysis_port[core_id].write(commit_tb_item[core_id][lsu_commit_idx]);
        end
    endtask

endclass