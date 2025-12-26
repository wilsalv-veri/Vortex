class VX_writeback_tb_txn_item extends uvm_transaction;

    VX_core_id_t                  core_id;
    logic                         valid;
    VX_pipeline_issue_slice_num_t slice_num;
    VX_wid_t                      wid;
    VX_pipeline_reg_num_t         rd;
       
    `uvm_object_utils_begin(VX_writeback_tb_txn_item);
        `uvm_field_int(core_id, UVM_DEFAULT)   
        `uvm_field_int(valid,   UVM_DEFAULT)
        `uvm_field_int(wid,     UVM_DEFAULT)
        `uvm_field_int(rd,      UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name="VX_writeback_tb_txn_item");
        super.new(name);
    endfunction

endclass