class VX_risc_v_R4type_seq_item extends VX_risc_v_inst_seq_item;
    
    rand risc_v_seq_reg_num_t         rs3; 
    rand risc_v_seq_funct2_t          funct2;
    rand risc_v_seq_reg_num_t         rs2; 
    rand risc_v_seq_reg_num_t         rs1;
    rand risc_v_seq_funct3_t          funct3;
    rand risc_v_seq_reg_num_t         rd;
   
    `uvm_object_utils_begin(VX_risc_v_R4type_seq_item);    
        `uvm_field_int(rs3,    UVM_ALL_ON)
        `uvm_field_int(funct2, UVM_ALL_ON)
        `uvm_field_int(rs2,    UVM_ALL_ON)
        `uvm_field_int(rs1,    UVM_ALL_ON)
        `uvm_field_int(funct3, UVM_ALL_ON)
        `uvm_field_int(rd,     UVM_ALL_ON)
        `uvm_field_int(opcode, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_R4type_seq_item");
        super.new(name);
    endfunction

    function void set_instruction_fields(risc_v_seq_funct3_t funct3, risc_v_seq_reg_num_t rd,    
                                        risc_v_seq_reg_num_t rs3, risc_v_seq_reg_num_t rs2,
                                        risc_v_seq_reg_num_t rs1, risc_v_seq_opcode_t opcode
                                        );

        this.rs3       = rs3;
        this.funct2    = 2'b00;
        this.rs2       = rs2;
        this.rs1       = rs1;
        this.funct3    = funct3;
        this.rd        = rd;
        this.opcode    = opcode;
        this.raw_data  = {this.rs3,this.funct2,this.rs2,this.rs1,this.funct3,this.rd,this.opcode};
    endfunction

    static function VX_risc_v_R4type_seq_item create_instruction_with_field(risc_v_seq_funct3_t funct3, risc_v_seq_reg_num_t rd,    
                                        risc_v_seq_reg_num_t rs3, risc_v_seq_reg_num_t rs2,
                                        risc_v_seq_reg_num_t rs1, risc_v_seq_opcode_t opcode
                                        );

        VX_risc_v_R4type_seq_item item = VX_risc_v_R4type_seq_item::type_id::create("VX_risc_v_R4type_seq_item");
        item.set_instruction_fields(funct3,rd,rs3,rs2,rs1,opcode);
        return item;                        
    endfunction
endclass