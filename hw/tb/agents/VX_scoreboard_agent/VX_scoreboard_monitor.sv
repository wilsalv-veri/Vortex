class VX_scoreboard_monitor extends uvm_monitor;
   
    `uvm_component_utils(VX_scoreboard_monitor)

    string message_id = "VX_SCOREBOARD_MONITOR";
    
    VX_scoreboard_tb_txn_item scoreboard_info;
    VX_writeback_tb_txn_item  writeback_info;

    uvm_analysis_port #(VX_scoreboard_tb_txn_item) scoreboard_info_analysis_port[`ISSUE_WIDTH];
    uvm_analysis_port #(VX_writeback_tb_txn_item)  writeback_info_analysis_port[`ISSUE_WIDTH];

    virtual VX_scoreboard_if  scoreboard_if[`ISSUE_WIDTH];
    virtual VX_writeback_if   writeback_if [`ISSUE_WIDTH];

    function new(string name="VX_scoreboard_monitor", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        scoreboard_info = VX_scoreboard_tb_txn_item::type_id::create("SCOREBOARD_INFO", this);
        writeback_info  = VX_writeback_tb_txn_item::type_id::create("VX_writeback_tb_txn_item", this);
     
        for(int issue_slice=0; issue_slice < `ISSUE_WIDTH; issue_slice++)begin
            
            scoreboard_info_analysis_port[issue_slice] = new("SCOREBOARD_INFO_ANALYSIS_PORT",this);
            writeback_info_analysis_port[issue_slice] = new("WRITEBACK_INFO_ANALYSIS_PORT",this);
     

            if (!uvm_config_db #(virtual VX_scoreboard_if)::get(this, "", $sformatf("scoreboard_if[%0d]",issue_slice), scoreboard_if[issue_slice]))
                `VX_error(message_id, "Failed to get access to scoreaboard_if")
            
            if (!uvm_config_db #(virtual VX_writeback_if)::get(this, "", $sformatf("writeback_if[%0d]", issue_slice), writeback_if[issue_slice]))
                `VX_error(message_id, "Failed to get access to writeback_if")
        end
        
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        for(int idx=0; idx < `ISSUE_WIDTH; idx++)begin
            automatic int issue_slice = idx;
            
            fork
                get_scoreboard_info(issue_slice);
                get_writeback_info(issue_slice);
            join_none
        end
            
    endtask
    
    virtual task get_scoreboard_info(int issue_slice);
        `VX_info(message_id, $sformatf("Starting GET_SCOREBOARD_INFO  for SLICE: %0d",issue_slice))
       
        forever @ (posedge scoreboard_if[issue_slice].valid)begin
            scoreboard_info.valid      = scoreboard_if[issue_slice].valid;
            scoreboard_info.slice_num  = VX_pipeline_issue_slice_num_t'(issue_slice);
            scoreboard_info.wid        = wis_to_wid(scoreboard_if[issue_slice].data.wis, 0);
            scoreboard_info.wb         = scoreboard_if[issue_slice].data.wb;
            scoreboard_info.used_rs    = scoreboard_if[issue_slice].data.used_rs;
            scoreboard_info.rd         = scoreboard_if[issue_slice].data.rd;
            scoreboard_info.rs1        = scoreboard_if[issue_slice].data.rs1;
            scoreboard_info.rs2        = scoreboard_if[issue_slice].data.rs2;
            scoreboard_info.rs3        = scoreboard_if[issue_slice].data.rs3;
            scoreboard_info_analysis_port[issue_slice].write(scoreboard_info);
        end 
   
    endtask

    virtual task get_writeback_info(int issue_slice);
        `VX_info(message_id, $sformatf("Starting GET_WRITEBACK_INFO for SLICE: %0d",issue_slice))
      
        forever @ ( posedge writeback_if[issue_slice].valid)begin
            writeback_info.valid = writeback_if[issue_slice].valid;
            writeback_info.slice_num  = VX_pipeline_issue_slice_num_t'(issue_slice);
            writeback_info.wid   = wis_to_wid(writeback_if[issue_slice].data.wis, 0);
            writeback_info.rd    = writeback_if[issue_slice].data.rd;
            writeback_info_analysis_port[issue_slice].write(writeback_info);
        end
    endtask

endclass