interface VX_gpr_tb_if import VX_tb_common_pkg::*;();
    
    bit                   write_en [`NUM_GPR_BANKS - 1:0];
    bit                   read_en  [`NUM_GPR_BANKS - 1:0];
    
    VX_gpr_bank_set_t     rd_bank_set       [`NUM_GPR_BANKS - 1:0];
    VX_gpr_data_entry_t   rd_gpr_data_entry [`NUM_GPR_BANKS - 1:0];
    
    VX_gpr_bank_set_t     wr_bank_set       [`NUM_GPR_BANKS - 1:0];
    VX_gpr_data_entry_t   wr_gpr_data_entry [`NUM_GPR_BANKS - 1:0];
    VX_gpr_entry_byteen   wr_byteen         [`NUM_GPR_BANKS - 1:0];

    modport master (output wr_gpr_data_entry);
    modport slave  (input  wr_gpr_data_entry);
     
endinterface