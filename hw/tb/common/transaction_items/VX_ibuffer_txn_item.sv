class VX_ibuffer_tb_txn_item extends uvm_transaction;

    bit                           valid;
    VX_pipeline_issue_slice_num_t slice_num;
    VX_wid_t                      wid;
    bit                           wb;
    VX_pipeline_used_rs_t         used_rs;
    VX_pipeline_reg_num_t         rd;
    VX_pipeline_reg_num_t         rs1;
    VX_pipeline_reg_num_t         rs2;
    VX_pipeline_reg_num_t         rs3;
    
    `uvm_object_utils_begin(VX_ibuffer_tb_txn_item)
        `uvm_field_int(valid,   UVM_DEFAULT)
        `uvm_field_int(wid,     UVM_DEFAULT)
        `uvm_field_int(wb,      UVM_DEFAULT)
        `uvm_field_int(used_rs, UVM_DEFAULT)
        `uvm_field_int(rd,      UVM_DEFAULT)
        `uvm_field_int(rs1,     UVM_DEFAULT)
        `uvm_field_int(rs2,     UVM_DEFAULT)
        `uvm_field_int(rs3,     UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name="VX_ibuffer_tb_txn_item");
        super.new(name);
    endfunction

endclass