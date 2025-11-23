class VX_risc_v_Utype_seq_item extends VX_risc_v_instr_seq_item;

    rand risc_v_seq_u_type_imm_t      imm;
    rand risc_v_seq_reg_num_t         rd;

    `uvm_object_utils_begin(VX_risc_v_Utype_seq_item);    
        `uvm_field_int(imm,    UVM_ALL_ON)
        `uvm_field_int(rd,     UVM_ALL_ON)
        `uvm_field_int(opcode, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_Utype_seq_item");
        super.new(name);
    endfunction

    function void set_instruction_fields(string name, risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rd, 
                                      risc_v_seq_opcode_t opcode
                                    );
        
        this.instr_name          = name;
        this.instr_type          = U_TYPE;

        case(opcode)
            INST_LUI:
            INST_AUIPC: this.imm = imm[31:12];
            INST_JAL:   this.imm = {imm[20],imm[10:1], imm[11],imm[19:12]};    
        endcase
        
        this.rd                  = rd;
        this.opcode              = opcode;
        this.raw_data            = {this.imm,this.rd,this.opcode};
    endfunction

    static function VX_risc_v_Utype_seq_item create_instruction_with_fields(string name, risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rd, 
                                      risc_v_seq_opcode_t opcode
                                    );
        VX_risc_v_Utype_seq_item item = VX_risc_v_Utype_seq_item::type_id::create("VX_risc_v_Utype_seq_item");
        item.set_instruction_fields(name,imm,rd,opcode);
        return item;
    endfunction
   
endclass