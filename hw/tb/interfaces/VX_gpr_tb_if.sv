interface VX_gpr_tb_if import VX_tb_common_pkg::*;();
    
    bit                   write_en [`NUM_GPR_BANKS - 1:0];
    VX_gpr_bank_set_t     bank_set [`NUM_GPR_BANKS - 1:0];
    VX_gpr_data_entry_t   gpr_data_entry [`NUM_GPR_BANKS - 1:0];
    //VX_gpr_block_t gpr_block;

    modport master (output gpr_data_entry);
    modport slave  (input  gpr_data_entry);
     
endinterface