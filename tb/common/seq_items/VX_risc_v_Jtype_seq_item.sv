class VX_risc_v_Jtype_seq_item extends VX_risc_v_instr_seq_item;

    rand bit                          imm_20;
    rand risc_v_seq_j_type_imm1_t     imm1;
    rand bit                          imm_11;
    rand risc_v_seq_j_type_imm0_t     imm0;
    rand risc_v_seq_reg_num_t         rd;
   
    `uvm_object_utils_begin(VX_risc_v_Jtype_seq_item);    
        `uvm_field_int(imm_20, UVM_ALL_ON)
        `uvm_field_int(imm1,   UVM_ALL_ON)
        `uvm_field_int(imm_11, UVM_ALL_ON)
        `uvm_field_int(imm0,   UVM_ALL_ON)
        `uvm_field_int(rd,     UVM_ALL_ON)
        `uvm_field_int(opcode, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_Jtype_seq_item");
        super.new(name);
    endfunction

    function void set_instruction_fields(string name, risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rd,
                                        risc_v_seq_opcode_t opcode
                                        );
        this.instr_name  = name;
        this.instr_type  = J_TYPE;
        this.imm_20      = imm[`IMM_20];
        this.imm1        = imm[10:1];
        this.imm_11      = imm[`IMM_11];
        this.imm0        = imm[19:12];
        this.rd          = rd;
        this.opcode      = opcode;
        this.raw_data    = {this.imm_20,this.imm1,this.imm_11,this.imm0,this.rd,this.opcode};
    endfunction

    static function VX_risc_v_Jtype_seq_item create_instruction_with_fields(string name,risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rd,
                                        risc_v_seq_opcode_t opcode
                                        );
    
        VX_risc_v_Jtype_seq_item item = VX_risc_v_Jtype_seq_item::type_id::create("VX_risc_v_Jtype_seq_item");
        item.set_instruction_fields(name,imm,rd,opcode);
        return item;
    endfunction
endclass