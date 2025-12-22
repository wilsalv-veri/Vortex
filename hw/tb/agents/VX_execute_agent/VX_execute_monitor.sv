class VX_execute_monitor extends uvm_monitor;

    `uvm_component_utils(VX_execute_monitor)

    string message_id = "VX_EXECUTE_MONITOR";
    
    VX_alu_tb_txn_item                         alu_tb_item;
    virtual VX_result_if                       alu_block_result_if[`VX_PE_COUNT];
     
    VX_lsu_tb_txn_item                         lsu_tb_item[`NUM_LSU_BLOCKS];
    virtual VX_lsu_mem_if #( .NUM_LANES (`NUM_LSU_LANES),
                             .DATA_SIZE (LSU_WORD_SIZE),
                             .TAG_WIDTH (LSU_TAG_WIDTH))
                                                lsu_mem_if [`NUM_LSU_BLOCKS];
  
    VX_commit_tb_txn_item                      commit_tb_item[`ISSUE_WIDTH];
    virtual VX_commit_if                       commit_if [`ISSUE_WIDTH];
    virtual VX_dispatch_if                     dispatch_if[`ISSUE_WIDTH];

    uvm_analysis_port #(VX_alu_tb_txn_item)    alu_analysis_port;
    uvm_analysis_port #(VX_lsu_tb_txn_item)    lsu_analysis_port;

    uvm_analysis_port #(VX_commit_tb_txn_item) commit_analysis_port;

    int lsu_commit_start_idx;  
    int lsu_commit_end_idx;    

    function new (string name="VX_execute_monitor", uvm_component parent=null);
        super.new(name, parent);

        lsu_commit_start_idx   = EX_LSU * `ISSUE_WIDTH;
        lsu_commit_end_idx     = lsu_commit_start_idx + `ISSUE_WIDTH;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        alu_tb_item          = VX_alu_tb_txn_item::type_id::create("VX_alu_tb_item");
         
        alu_analysis_port    = new("ALU_ANALYSIS_PORT", this);
        lsu_analysis_port    = new("LSU_ANALYSIS_PORT", this);
        commit_analysis_port = new("COMMIT_ANALYSIS_PORT", this);

        for(int pe_num = 0; pe_num < `VX_PE_COUNT; pe_num++)begin
            if(!uvm_config_db #(virtual VX_result_if)::get(this, "", $sformatf("alu_result_if[%0d]", pe_num), alu_block_result_if[pe_num]))
                `VX_error(message_id, $sformatf("Failed to get access for alu_result_if[%0d]", pe_num))
        end

        for(int lsu_block=0; lsu_block < `NUM_LSU_BLOCKS; lsu_block++) begin
            
            lsu_tb_item[lsu_block] = VX_lsu_tb_txn_item::type_id::create($sformatf("VX_lsu_tb_txn_item[%0d]", lsu_block));
            
            if (!uvm_config_db #(virtual VX_lsu_mem_if #( .NUM_LANES (`NUM_LSU_LANES),
                                                          .DATA_SIZE (LSU_WORD_SIZE),
                                                          .TAG_WIDTH (LSU_TAG_WIDTH)))
                                                          ::get(this, "", $sformatf("lsu_mem_if[%0d]", lsu_block), lsu_mem_if[lsu_block]))
                `VX_error(message_id, $sformatf("Failed to get access for lsu_mem_if[%0d]", lsu_block))
        end
   
        for(int lsu_commit_idx=lsu_commit_start_idx, virt_commit_if_idx=0_; lsu_commit_idx < lsu_commit_end_idx; lsu_commit_idx++, virt_commit_if_idx++)begin
            
            commit_tb_item[virt_commit_if_idx] = VX_commit_tb_txn_item::type_id::create($sformatf("VX_commit_tb_txn_item[%0d]", virt_commit_if_idx));
            
            if( !uvm_config_db #(virtual VX_commit_if)::get (this, "", $sformatf("commit_if[%0d]", lsu_commit_idx),commit_if[virt_commit_if_idx]))
                `VX_error(message_id, $sformatf("Failed to get access for commit_if[%0d]", lsu_commit_idx))
           
            if( !uvm_config_db #(virtual VX_dispatch_if)::get (this, "", $sformatf("dispatch_if[%0d]", lsu_commit_idx),dispatch_if[virt_commit_if_idx]))
                `VX_error(message_id, $sformatf("Failed to get access for dispatch_if[%0d]", lsu_commit_idx))
        
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
            for(int idx=0; idx < `NUM_LSU_BLOCKS; idx++)begin
                automatic int lsu_block = idx;
                fork 
                    get_lsu_info(lsu_block);
                join_none
            end
 
            for(int idx=lsu_commit_start_idx, jdx=0; idx < lsu_commit_end_idx; idx++, jdx++)begin
                automatic int lsu_commit_idx = jdx;
                fork
                    get_commit_info(lsu_commit_idx);
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

    virtual task get_lsu_info(int lsu_block);
        `VX_info(message_id, $sformatf("Starting GET_LSU_INFO"))

        fork 
            forever @(posedge lsu_mem_if[lsu_block].req_valid)begin
                lsu_tb_item[lsu_block].req_mask       =  lsu_mem_if[lsu_block].req_data.mask;
                lsu_tb_item[lsu_block].req_addresses  =  lsu_mem_if[lsu_block].req_data.addr;
                lsu_tb_item[lsu_block].req_byteen     =  lsu_mem_if[lsu_block].req_data.byteen;
            end

            forever @(posedge lsu_mem_if[lsu_block].rsp_valid)begin
                lsu_tb_item[lsu_block].rsp_mask =  lsu_mem_if[lsu_block].rsp_data.mask;
                lsu_tb_item[lsu_block].rsp_data = lsu_mem_if[lsu_block].rsp_data.data;
                lsu_analysis_port.write(lsu_tb_item[lsu_block]);    
            end
        join_none
  
    endtask

    virtual task get_commit_info(int lsu_commit_idx);
        `VX_info(message_id, $sformatf("Starting GET_COMMIT_INFO LSU_COMMIT_IDX: %0d", lsu_commit_idx))

        forever @(posedge commit_if[lsu_commit_idx].valid)begin  
            commit_tb_item[lsu_commit_idx].pc    = commit_if[lsu_commit_idx].data.PC;
            commit_tb_item[lsu_commit_idx].wid   = commit_if[lsu_commit_idx].data.wid;
            commit_tb_item[lsu_commit_idx].tmask = commit_if[lsu_commit_idx].data.tmask;
            commit_tb_item[lsu_commit_idx].wb    = commit_if[lsu_commit_idx].data.wb;
            commit_tb_item[lsu_commit_idx].rd    = commit_if[lsu_commit_idx].data.rd;
            commit_tb_item[lsu_commit_idx].data  = commit_if[lsu_commit_idx].data.data;
            commit_analysis_port.write(commit_tb_item[lsu_commit_idx]);
        end
    endtask

endclass