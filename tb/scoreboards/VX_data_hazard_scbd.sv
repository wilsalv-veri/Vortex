class VX_data_hazard_scbd extends uvm_scoreboard;

    `uvm_component_utils(VX_data_hazard_scbd);

    string message_id = "VX_DATA_HAZARD_SCBD";

     
    VX_scoreboard_tb_txn_item scoreboard_info[`SOCKET_SIZE];
    VX_writeback_tb_txn_item  writeback_info[`SOCKET_SIZE];
   
    VX_scoreboard_tb_txn_item scoreboard_info_item;
    VX_writeback_tb_txn_item  writeback_info_item;
   
    VX_seq_gpr_reg_mask       inuse_regs [`SOCKET_SIZE][`ISSUE_WIDTH-1:0] [PER_ISSUE_WARPS-1:0];

    uvm_tlm_analysis_fifo #(VX_scoreboard_tb_txn_item) scoreboard_info_fifo;
    uvm_tlm_analysis_fifo #(VX_writeback_tb_txn_item)  writeback_info_fifo;

    function new(string name="VX_data_hazard_scbd", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        scoreboard_info_fifo = new("VX_SCOREBOARD_INFO_FIFO", this);
        writeback_info_fifo = new("VX_WRITEBACK_INFO_FIFO", this);      
    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);
        
        fork 
            forever begin
                scoreboard_info_fifo.get(scoreboard_info_item);
                scoreboard_info[scoreboard_info_item.core_id] = scoreboard_info_item;
                check_scoreboard_info(scoreboard_info_item.core_id);
                set_in_use_regs(scoreboard_info_item.core_id);
            end

            forever begin
                writeback_info_fifo.get(writeback_info_item);
                writeback_info[writeback_info_item.core_id] = writeback_info_item;
                clear_committed_reg(writeback_info_item.core_id);
            end
        join_none
    endtask

    function void clear_committed_reg(VX_core_id_t  core_id);
        inuse_regs[core_id][writeback_info[core_id].slice_num][writeback_info[core_id].wid][writeback_info[core_id].rd]  = 1'b0;
    endfunction

    virtual function void check_scoreboard_info(VX_core_id_t  core_id);
        if (scoreboard_info[core_id].used_rs.use_rs1)begin
            if (inuse_regs[core_id][scoreboard_info[core_id].slice_num][scoreboard_info[core_id].wid][scoreboard_info[core_id].rs1])
                `VX_error(message_id, $sformatf("Scoreboard Valid While RS1 Still in Use RS1: %0d CORE_ID: %0d", scoreboard_info[core_id].rs1, core_id))
        end

        if (scoreboard_info[core_id].used_rs.use_rs2)begin
            if (inuse_regs[core_id][scoreboard_info[core_id].slice_num][scoreboard_info[core_id].wid][scoreboard_info[core_id].rs2])
                `VX_error(message_id, $sformatf("Scoreboard Valid While RS2 Still in Use RS1: %0d CORE_ID: %0d", scoreboard_info[core_id].rs2, core_id))
        end

        if (scoreboard_info[core_id].used_rs.use_rs3)begin
            if (inuse_regs[core_id][scoreboard_info[core_id].slice_num][scoreboard_info[core_id].wid][scoreboard_info[core_id].rs3])
                `VX_error(message_id, $sformatf("Scoreboard Valid While RS3 Still in Use RS1: %0d CORE_ID: %0d", scoreboard_info[core_id].rs3, core_id))
        end
    endfunction

    virtual function void set_in_use_regs(VX_core_id_t  core_id);
        if (scoreboard_info[core_id].wb)
            inuse_regs[core_id][scoreboard_info[core_id].slice_num][scoreboard_info[core_id].wid][scoreboard_info[core_id].rd]  = 1'b1;
     
    endfunction

endclass