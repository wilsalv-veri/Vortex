class VX_commit_tb_txn_item extends uvm_transaction;

    risc_v_seq_instr_address_t pc;
    VX_wid_t                   wid;
    VX_tmask_t                 tmask;
    bit                        wb;
    risc_v_seq_reg_num_t       rd;
    VX_commit_data             data; 
          
    `uvm_object_utils_begin(VX_commit_tb_txn_item)
        `uvm_field_int(pc,    UVM_DEFAULT)
         `uvm_field_int(wid,  UVM_DEFAULT)   
        `uvm_field_int(tmask, UVM_DEFAULT)
        `uvm_field_int(wb,    UVM_DEFAULT)
        `uvm_field_int(rd,    UVM_DEFAULT)
        `uvm_field_int(data,  UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name="VX_commit_tb_txn_item");
        super.new(name);
    endfunction
    
endclass