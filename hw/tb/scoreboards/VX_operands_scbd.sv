class VX_operands_scbd extends uvm_scoreboard;

    `uvm_component_utils(VX_operands_scbd)

    string message_id = "VX_OPERANDS_SCBD";

    VX_scoreboard_tb_txn_item  scoreboard_info;    
    VX_scoreboard_tb_txn_item  scoreboard_info_clone;    
    VX_scoreboard_tb_txn_item  opc_used_scoreboard_info;    
    
    VX_scoreboard_tb_txn_item  scoreboard_info_items[$];    
    VX_operands_tb_txn_item    operands_info;    
    VX_gpr_tb_txn_item         gpr_info;
   
    VX_gpr_seq_block_t         gpr_block;

    uvm_tlm_analysis_fifo #(VX_scoreboard_tb_txn_item) scoreboard_info_fifo;
    uvm_tlm_analysis_fifo #(VX_operands_tb_txn_item)   operands_info_fifo;
    
    uvm_tlm_analysis_fifo #(VX_gpr_tb_txn_item)      gpr_tb_fifo;

    VX_seq_gpr_bank_num_t      rs1_bank_num, rs2_bank_num, rs3_bank_num;
    VX_seq_gpr_bank_set_t      rs1_set_num, rs2_set_num, rs3_set_num;
    
    function new(string name="VX_operands_scbd", uvm_component parent=null);
        super.new(name,parent);
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        gpr_tb_fifo          = new("OPERANDS_SCBD_GPR_TB_FIFO", this);
        scoreboard_info_fifo = new("OPERANDS_SCBD_SCOREBOARD_INFO_FIFO", this);
        operands_info_fifo   = new("OPERANDS_SCBD_OPERANDS_INFO_FIFO", this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase(phase);
        fork 
            forever begin
                operands_info_fifo.get(operands_info);  
                set_opc_used_scorboard_info();  
                check_operands();
            end
            
            forever begin
                scoreboard_info_fifo.get(scoreboard_info);
                
                if (!$cast(scoreboard_info_clone, scoreboard_info.clone()))
                    `VX_error(message_id, "Failed to cast scoreboard_info clone into local scoreboard_info object")
            
                scoreboard_info_items.push_back(scoreboard_info_clone);     
            end

            forever begin
                gpr_tb_fifo.get(gpr_info);
                write_gpr_info(gpr_info);
            end

        join_none
    endtask

    function void check_operands();
        
        if (opc_used_scoreboard_info.used_rs.use_rs1)begin
            if (operands_info.rs1_data != gpr_block[rs1_bank_num][rs1_set_num])
                `VX_error(message_id, $sformatf("Incorrect Operand RS1 Data Given OPC RS1 Data: 0x%0h GPR Data for GPR %0d: 0x%0h",
            operands_info.rs1_data, opc_used_scoreboard_info.rs1, gpr_block[rs1_bank_num][rs1_set_num]))
        end

        if (opc_used_scoreboard_info.used_rs.use_rs2)begin
            if (operands_info.rs2_data != gpr_block[rs2_bank_num][rs2_set_num])
                `VX_error(message_id, $sformatf("Incorrect Operand RS2 Data Given OPC RS2 Data: 0x%0h GPR Data for GPR %0d: 0x%0h",
            operands_info.rs2_data, opc_used_scoreboard_info.rs2, gpr_block[rs2_bank_num][rs2_set_num]))  
        end

        if (opc_used_scoreboard_info.used_rs.use_rs3)begin
            if (operands_info.rs3_data != gpr_block[rs3_bank_num][rs3_set_num])
                `VX_error(message_id, $sformatf("Incorrect Operand RS3 Data Given OPC RS3 Data: %0h GPR Data for GPR %0d: %0h",
            operands_info.rs3_data, opc_used_scoreboard_info.rs3, gpr_block[rs3_bank_num][rs3_set_num]))
        end

    endfunction

    virtual function void write_gpr_info(VX_gpr_tb_txn_item gpr_info);
        write_gpr_entry(gpr_info, gpr_block);
        `VX_info(message_id, $sformatf("GPR Info Received BYTEEN: 0x%0h BANK_NUM: %0d SET: %0d DATA_ENTRY: 0x%0x", gpr_info.byteen,  gpr_info.bank_num, gpr_info.bank_set, gpr_info.gpr_data_entry))
    endfunction

    function void set_opc_used_scorboard_info();
        opc_used_scoreboard_info = scoreboard_info_items.pop_front();
        set_operands_gpr_bank_num();
        set_operands_gpr_set_num();
    endfunction
    
    function void set_operands_gpr_bank_num();
        rs1_bank_num = `REG_NUM_TO_BANK(opc_used_scoreboard_info.rs1);
        rs2_bank_num = `REG_NUM_TO_BANK(opc_used_scoreboard_info.rs2);
        rs3_bank_num = `REG_NUM_TO_BANK(opc_used_scoreboard_info.rs3);
    endfunction

    function void set_operands_gpr_set_num();
        rs1_set_num  = `REG_NUM_TO_SET(opc_used_scoreboard_info.wid,opc_used_scoreboard_info.rs1);
        rs2_set_num  = `REG_NUM_TO_SET(opc_used_scoreboard_info.wid,opc_used_scoreboard_info.rs2);
        rs3_set_num  = `REG_NUM_TO_SET(opc_used_scoreboard_info.wid,opc_used_scoreboard_info.rs3);
    endfunction

endclass