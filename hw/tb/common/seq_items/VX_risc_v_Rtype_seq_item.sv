class VX_risc_v_Rtype_seq_item extends VX_risc_v_inst_seq_item;
 
    rand risc_v_seq_funct7_t          funct7;
    rand risc_v_seq_reg_num_t         rs2; 
    rand risc_v_seq_reg_num_t         rs1;
    rand risc_v_seq_funct3_t          funct3;
    rand risc_v_seq_reg_num_t         rd;
    

    `uvm_object_utils_begin(VX_risc_v_Rtype_seq_item);    
        `uvm_field_int(funct7, UVM_ALL_ON)
        `uvm_field_int(rs2,    UVM_ALL_ON)
        `uvm_field_int(rs1,    UVM_ALL_ON)
        `uvm_field_int(funct3, UVM_ALL_ON)
        `uvm_field_int(rd,     UVM_ALL_ON)
        `uvm_field_int(opcode, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_Rtype_seq_item");
        super.new(name);
    endfunction
    
    function void set_instruction_with_fields(
                                    risc_v_seq_funct7_t funct7,  risc_v_seq_reg_num_t rd, 
                                    risc_v_seq_reg_num_t rs2,    risc_v_seq_reg_num_t rs1, 
                                    risc_v_seq_funct3_t funct3,  risc_v_seq_opcode_t opcode
                                    );

        this.funct7   = funct7; 
        this.rs2      = rs2;
        this.rs1      = rs1;
        this.funct3   = funct3;
        this.rd       = rd;
        this.opcode   = opcode;
        this.raw_data = {this.funct7,this.rs2,this.rs1,this.rd,this.opcode};
    endfunction

    static function VX_risc_v_Rtype_seq_item create_instruction_with_fields(
                                    risc_v_seq_funct7_t funct7,  risc_v_seq_reg_num_t rd, 
                                    risc_v_seq_reg_num_t rs2,    risc_v_seq_reg_num_t rs1, 
                                    risc_v_seq_funct3_t funct3,  risc_v_seq_opcode_t opcode
                                    );
        
        VX_risc_v_Rtype_seq_item item = VX_risc_v_Rtype_seq_item::type_id::create("VX_risc_v_Rtype_seq_item");
        item.set_instruction_with_fields(funct7, rd, rs2, rs1, funct3, opcode);
        return item;

    endfunction


endclass