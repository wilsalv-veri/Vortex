for(genvar bank_num=0; bank_num < `NUM_GPR_BANKS; bank_num++)  begin : gpr_tb_if_block
    assign gpr_tb_if[core_id].read_en[bank_num]               = `VX_GPR(core_id, bank_num).read;
    assign gpr_tb_if[core_id].write_en[bank_num]              = `VX_GPR(core_id, bank_num).write;
    
    assign gpr_tb_if[core_id].rd_bank_set[bank_num]           = `VX_GPR(core_id, bank_num).raddr;
    assign gpr_tb_if[core_id].wr_bank_set[bank_num]           = `VX_GPR(core_id, bank_num).waddr;
    
    assign gpr_tb_if[core_id].wr_byteen[bank_num]             = `VX_GPR(core_id, bank_num).wren;
    
    assign gpr_tb_if[core_id].rd_gpr_data_entry[bank_num]     = `VX_GPR(core_id, bank_num).rdata; 
    assign gpr_tb_if[core_id].wr_gpr_data_entry[bank_num]     = `VX_GPR(core_id, bank_num).wdata; 
end