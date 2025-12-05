class VX_risc_v_Itype_seq_item extends VX_risc_v_instr_seq_item;

    rand risc_v_seq_i_type_imm_t      imm;
    rand risc_v_seq_reg_num_t         rs1;
    rand risc_v_seq_funct3_t          funct3;
    rand risc_v_seq_reg_num_t         rd;

    `uvm_object_utils_begin(VX_risc_v_Itype_seq_item);    
        `uvm_field_int(imm, UVM_ALL_ON)
        `uvm_field_int(rs1,    UVM_ALL_ON)
        `uvm_field_int(rs1,    UVM_ALL_ON)
        `uvm_field_int(rd,     UVM_ALL_ON)
        `uvm_field_int(opcode, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_Itype_seq_item");
        super.new(name);
    endfunction

    function void set_instruction_fields(string name, risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rd, 
                                      risc_v_seq_reg_num_t rs1,  risc_v_seq_funct3_t funct3,
                                      risc_v_seq_opcode_t opcode
                                      );
       
        this.instr_name  = name;
        this.instr_type  = I_TYPE;
        this.imm         = imm[11:0];
        this.rs1         = rs1;
        this.funct3      = funct3;
        case(opcode)
            INST_JALR: this.funct3      = 3'b000;
        endcase
        
        this.rd          = rd;
        this.opcode      = opcode;
        this.raw_data    = {this.imm,this.rs1,this.funct3,this.rd,this.opcode};
    endfunction

    function void set_imm_field(risc_v_seq_imm_t imm);
        this.imm = imm[11:0];
        this.raw_data    = {this.imm,this.rs1,this.funct3,this.rd,this.opcode};
    endfunction

    static function VX_risc_v_Itype_seq_item create_instruction_with_fields(string name, risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rd, 
                                      risc_v_seq_reg_num_t rs1,  risc_v_seq_funct3_t funct3,
                                      risc_v_seq_opcode_t opcode
                                      );
        
        VX_risc_v_Itype_seq_item item = VX_risc_v_Itype_seq_item::type_id::create("VX_risc_v_Itype_seq_item");
        item.set_instruction_fields(name, imm,rd,rs1,funct3,opcode);
        return item;
    endfunction
    
endclass