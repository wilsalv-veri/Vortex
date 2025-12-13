for(genvar bank_num=0; bank_num < `NUM_GPR_BANKS; bank_num++)  begin : gpr_tb_if_block
    assign gpr_tb_if.read_en[bank_num]               = `VX_GPR(bank_num).read;
    assign gpr_tb_if.write_en[bank_num]              = `VX_GPR(bank_num).write;
    
    assign gpr_tb_if.rd_bank_set[bank_num]           = `VX_GPR(bank_num).raddr;
    assign gpr_tb_if.wr_bank_set[bank_num]           = `VX_GPR(bank_num).waddr;
    
    assign gpr_tb_if.wr_byteen[bank_num]             = `VX_GPR(bank_num).wren;
    
    assign gpr_tb_if.rd_gpr_data_entry[bank_num]     = `VX_GPR(bank_num).rdata; 
    assign gpr_tb_if.wr_gpr_data_entry[bank_num]     = `VX_GPR(bank_num).wdata; 
end