class VX_issue_monitor extends uvm_monitor;
   
    `uvm_component_utils(VX_issue_monitor)

    string message_id = "VX_ISSUE_MONITOR";
    
    VX_scoreboard_tb_txn_item scoreboard_info[`SOCKET_SIZE];
    VX_writeback_tb_txn_item  writeback_info[`SOCKET_SIZE];
    VX_operands_tb_txn_item   operands_info[`SOCKET_SIZE];

    uvm_analysis_port #(VX_scoreboard_tb_txn_item) scoreboard_info_analysis_port[`SOCKET_SIZE][`ISSUE_WIDTH];
    uvm_analysis_port #(VX_writeback_tb_txn_item)  writeback_info_analysis_port[`SOCKET_SIZE][`ISSUE_WIDTH];
    uvm_analysis_port #(VX_operands_tb_txn_item)   operands_info_analysis_port[`SOCKET_SIZE][`ISSUE_WIDTH];

    virtual VX_scoreboard_if  scoreboard_if[`SOCKET_SIZE][`ISSUE_WIDTH];
    virtual VX_writeback_if   writeback_if [`SOCKET_SIZE][`ISSUE_WIDTH];
    virtual VX_operands_if    operands_if[`SOCKET_SIZE][`ISSUE_WIDTH];

    function new(string name="VX_issue_monitor", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        for(int core_id=0; core_id < `SOCKET_SIZE; core_id++)begin
            
            scoreboard_info[core_id] = VX_scoreboard_tb_txn_item::type_id::create($sformatf("core[%0d].SCOREBOARD_INFO", core_id), this);
            writeback_info[core_id]  = VX_writeback_tb_txn_item::type_id::create($sformatf("core[%0d].VX_writeback_tb_txn_item",core_id), this);
            operands_info[core_id]   = VX_operands_tb_txn_item::type_id::create($sformatf("core[%0d].VX_operands_tb_txn_item", core_id), this);

            for(int issue_slice=0; issue_slice < `ISSUE_WIDTH; issue_slice++)begin

                scoreboard_info_analysis_port[core_id][issue_slice] = new($sformatf("core[%0d]_scoreboard_info_analysis_port",core_id), this);
                writeback_info_analysis_port[core_id][issue_slice]  = new($sformatf("core[%0d]_writeback_info_analysis_port", core_id), this);
                operands_info_analysis_port[core_id][issue_slice]   = new($sformatf("core[%0d]_operands_info_analysis_port",  core_id), this);

                if (!uvm_config_db #(virtual VX_scoreboard_if)::get(this, "", $sformatf("core[%0d].scoreboard_if[%0d]",core_id, issue_slice), scoreboard_if[core_id][issue_slice]))
                    `VX_error(message_id, $sformatf("Failed to get access to core[%0d].scoreaboard_if", core_id))

                if (!uvm_config_db #(virtual VX_writeback_if)::get(this, "", $sformatf("core[%0d].writeback_if[%0d]", core_id, issue_slice), writeback_if[core_id][issue_slice]))
                    `VX_error(message_id, $sformatf("Failed to get access to core[%0d].writeback_if", core_id))
            
                if (!uvm_config_db #(virtual VX_operands_if)::get(this, "", $sformatf("core[%0d].operands_if[%0d]", core_id, issue_slice), operands_if[core_id][issue_slice]))
                    `VX_error(message_id, $sformatf("Failed to get access to core[%0d].operands_if", core_id))
            
            end
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        for(int id=0; id < `SOCKET_SIZE; id++)begin
            automatic int core_id = id;

            for(int idx=0; idx < `ISSUE_WIDTH; idx++)begin
                automatic int issue_slice = idx;

                fork
                    get_scoreboard_info(core_id, issue_slice);
                    get_writeback_info(core_id, issue_slice);
                    get_operands_info(core_id, issue_slice);
                join_none
            end
        end
            
    endtask
    
    virtual task get_scoreboard_info(int core_id, int issue_slice);
        `VX_info(message_id, $sformatf("Starting GET_SCOREBOARD_INFO  for SLICE: %0d",issue_slice))
       
        forever @ (posedge scoreboard_if[core_id][issue_slice].valid)begin
            scoreboard_info[core_id].core_id    = core_id;
            scoreboard_info[core_id].valid      = scoreboard_if[core_id][issue_slice].valid;
            scoreboard_info[core_id].slice_num  = VX_pipeline_issue_slice_num_t'(issue_slice);
            scoreboard_info[core_id].wid        = wis_to_wid(scoreboard_if[core_id][issue_slice].data.wis, 0);
            scoreboard_info[core_id].wb         = scoreboard_if[core_id][issue_slice].data.wb;
            scoreboard_info[core_id].used_rs    = scoreboard_if[core_id][issue_slice].data.used_rs;
            scoreboard_info[core_id].rd         = scoreboard_if[core_id][issue_slice].data.rd;
            scoreboard_info[core_id].rs1        = scoreboard_if[core_id][issue_slice].data.rs1;
            scoreboard_info[core_id].rs2        = scoreboard_if[core_id][issue_slice].data.rs2;
            scoreboard_info[core_id].rs3        = scoreboard_if[core_id][issue_slice].data.rs3;
            scoreboard_info_analysis_port[core_id][issue_slice].write(scoreboard_info[core_id]);
        end 
    endtask

    virtual task get_writeback_info(int core_id, int issue_slice);
        `VX_info(message_id, $sformatf("Starting GET_WRITEBACK_INFO for SLICE: %0d",issue_slice))
      
        forever @ ( posedge writeback_if[core_id][issue_slice].valid)begin
            writeback_info[core_id].core_id    = core_id;
            writeback_info[core_id].valid      = writeback_if[core_id][issue_slice].valid;
            writeback_info[core_id].slice_num  = VX_pipeline_issue_slice_num_t'(issue_slice);
            writeback_info[core_id].wid        = wis_to_wid(writeback_if[core_id][issue_slice].data.wis, 0);
            writeback_info[core_id].rd         = writeback_if[core_id][issue_slice].data.rd;
            writeback_info_analysis_port[core_id][issue_slice].write(writeback_info[core_id]);
        end
    endtask

    virtual task get_operands_info(int core_id, int issue_slice);
        `VX_info(message_id, $sformatf("Starting GET_OPERANDS_INFO for SLICE: %0d", issue_slice))
        
        forever @ (posedge operands_if[core_id][issue_slice].valid)begin
            operands_info[core_id].core_id  = core_id;
            operands_info[core_id].rs1_data = operands_if[core_id][issue_slice].data.rs1_data;
            operands_info[core_id].rs2_data = operands_if[core_id][issue_slice].data.rs2_data;
            operands_info[core_id].rs3_data = operands_if[core_id][issue_slice].data.rs3_data;
            operands_info_analysis_port[core_id][issue_slice].write(operands_info[core_id]);
        end
    endtask

endclass