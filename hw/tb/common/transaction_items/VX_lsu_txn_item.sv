class VX_lsu_tb_txn_item extends uvm_transaction;

    VX_tmask_t                 req_mask;
    VX_lsu_req_addresses_t     req_addresses;
    VX_lsu_req_byteen_t        req_byteen;
      
    VX_tmask_t                 rsp_mask;
    VX_lsu_rsp_data            rsp_data;

    `uvm_object_utils_begin(VX_lsu_tb_txn_item)
        `uvm_field_int(req_mask,      UVM_DEFAULT)
        `uvm_field_int(req_addresses, UVM_DEFAULT)
        `uvm_field_int(req_byteen,    UVM_DEFAULT)
        `uvm_field_int(rsp_mask,      UVM_DEFAULT)
        `uvm_field_int(rsp_data,      UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name="VX_lsu_tb_txn_item");
        super.new(name);
    endfunction

endclass