for(genvar bank_num=0; bank_num < `NUM_GPR_BANKS; bank_num++)  begin : gpr_tb_if_block
    assign gpr_tb_if.write_en[bank_num]  = `VX_GPR(bank_num).write;
    assign gpr_tb_if.bank_set[bank_num]  = `VX_GPR(bank_num).waddr;
    assign gpr_tb_if.gpr_data_entry[bank_num]  = `VX_GPR(bank_num).wdata;
    //assign gpr_tb_if.gpr_block[bank_num] = `VX_GPR(bank_num).ram; 
end