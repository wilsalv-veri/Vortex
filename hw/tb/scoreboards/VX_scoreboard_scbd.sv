class VX_scoreboard_scbd extends uvm_scoreboard;

    `uvm_component_utils(VX_scoreboard_scbd);

    string message_id = "VX_SCOREBOARD_SCBD";

    VX_scoreboard_tb_txn_item scoreboard_info;
    VX_writeback_tb_txn_item  writeback_info;
    VX_seq_gpr_reg_mask       inuse_regs [`ISSUE_WIDTH-1:0] [PER_ISSUE_WARPS-1:0];

    uvm_tlm_analysis_fifo #(VX_scoreboard_tb_txn_item) scoreboard_info_fifo;
    uvm_tlm_analysis_fifo #(VX_writeback_tb_txn_item)  writeback_info_fifo;

    function new(string name="VX_scoreboard_scbd", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        scoreboard_info = VX_scoreboard_tb_txn_item::type_id::create("VX_scoreboard_tb_txn_item", this);
        writeback_info  = VX_writeback_tb_txn_item::type_id::create("VX_writeback_tb_txn_item", this);

        scoreboard_info_fifo = new("VX_SCOREBOARD_INFO_FIFO", this);
        writeback_info_fifo = new("VX_WRITEBACK_INFO_FIFO", this);      
    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);
        
        fork 
            forever begin
                scoreboard_info_fifo.get(scoreboard_info);
                check_scoreboard_info();
                set_in_use_regs();
            end

            forever begin
                writeback_info_fifo.get(writeback_info);
                clear_committed_reg();
            end
        join_none
    endtask

    function void clear_committed_reg();
        inuse_regs[writeback_info.slice_num][writeback_info.wid][writeback_info.rd]  = 1'b0;
    endfunction

    virtual function void check_scoreboard_info();
        if (scoreboard_info.used_rs.use_rs1)begin
            if (inuse_regs[scoreboard_info.slice_num][scoreboard_info.wid][scoreboard_info.rs1])
                `VX_error(message_id, $sformatf("Scoreboard Valid While RS1 Still in Use RS1: %0d", scoreboard_info.rs1))
        end

        if (scoreboard_info.used_rs.use_rs2)begin
            if (inuse_regs[scoreboard_info.slice_num][scoreboard_info.wid][scoreboard_info.rs2])
                `VX_error(message_id, $sformatf("Scoreboard Valid While RS2 Still in Use RS1: %0d", scoreboard_info.rs2))
        end

        if (scoreboard_info.used_rs.use_rs3)begin
            if (inuse_regs[scoreboard_info.slice_num][scoreboard_info.wid][scoreboard_info.rs3])
                `VX_error(message_id, $sformatf("Scoreboard Valid While RS3 Still in Use RS1: %0d", scoreboard_info.rs3))
        end
    endfunction

    virtual function void set_in_use_regs();
        if (scoreboard_info.wb)
            inuse_regs[scoreboard_info.slice_num][scoreboard_info.wid][scoreboard_info.rd]  = 1'b1;
     
    endfunction

endclass