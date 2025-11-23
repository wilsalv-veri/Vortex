class VX_risc_v_seq_item extends uvm_sequence_item;

    rand risc_v_data_type_t           data_type;
    rand risc_v_seq_data_t            raw_data;
    risc_v_seq_instr_address_t        address;

    `uvm_object_utils_begin(VX_risc_v_seq_item);    
        `uvm_field_enum(risc_v_data_type_t, data_type,      UVM_ALL_ON)
        `uvm_field_int(raw_data,                            UVM_ALL_ON)
        `uvm_field_int(address,                             UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_seq_item");
        super.new(name);
    endfunction
  
endclass

class VX_risc_v_instr_seq_item extends VX_risc_v_seq_item;

    rand risc_v_seq_instr_type_t      instr_type;
    string                            instr_name;
    rand risc_v_seq_opcode_t          opcode;
    

    `uvm_object_utils_begin(VX_risc_v_instr_seq_item);    
        `uvm_field_enum(risc_v_seq_instr_type_t, instr_type, UVM_ALL_ON)  
        `uvm_field_int(opcode,                               UVM_ALL_ON)
        `uvm_field_string(instr_name,                        UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_instr_seq_item");
        super.new(name);
    endfunction
  
endclass

