class VX_risc_v_inst_item extends uvm_sequence_item;

    function new(string name="VX_risc_v_inst_item");
        super.new(name);
    endfunction

    rand bit eleven, twelve, twenty; 
    rand risc_v_seq_inst_type_t       inst_type;
    rand risc_v_seq_opcode_t          opcode;
    rand risc_v_seq_reg_num_t         rs1;
    rand risc_v_seq_reg_num_t         rs2;
    rand risc_v_seq_reg_num_t         rd;
    rand risc_v_seq_funct3_t          funct3;
    rand risc_v_seq_funct7_t          funct7;

    //Optional Immediates
    rand risc_v_seq_i_type_imm_t      i_type_imm;
    rand risc_v_seq_s_type_imm1_t     s_type_imm1;
    rand risc_v_seq_s_type_imm0_t     s_type_imm0;
    rand risc_v_seq_b_type_imm1_t     b_type_imm1;
    rand risc_v_seq_b_type_imm0_t     b_type_imm0;
    rand risc_v_seq_u_type_imm_t      u_type_imm;
    rand risc_v_seq_j_type_imm1_t     j_type_imm1;
    rand risc_v_seq_j_type_imm0_t     j_type_imm0;

    `uvm_object_utils_begin(VX_risc_v_inst_item);
    
    `uvm_field_enum(risc_v_seq_inst_type_t, inst_type, UVM_ALL_ON)
    `uvm_field_int(opcode, UVM_ALL_ON)
    `uvm_field_int(rs1, UVM_ALL_ON)
    `uvm_field_int(rs2, UVM_ALL_ON)
    `uvm_field_int(rd, UVM_ALL_ON)
    `uvm_field_int(funct3, UVM_ALL_ON)
    `uvm_field_int(funct7, UVM_ALL_ON)
    
    `uvm_field_int(i_type_imm, UVM_ALL_ON)
    `uvm_field_int(s_type_imm1, UVM_ALL_ON)
    `uvm_field_int(s_type_imm0, UVM_ALL_ON)
    `uvm_field_int(b_type_imm1, UVM_ALL_ON)
    `uvm_field_int(b_type_imm0, UVM_ALL_ON)
    `uvm_field_int(u_type_imm, UVM_ALL_ON)
    `uvm_field_int(j_type_imm1, UVM_ALL_ON)
    `uvm_field_int(j_type_imm0, UVM_ALL_ON)

    `uvm_object_utils_end
endclass