class VX_risc_v_Stype_seq_item extends VX_risc_v_instr_seq_item;

    rand risc_v_seq_s_type_imm1_t     imm1;
    rand risc_v_seq_reg_num_t         rs2; 
    rand risc_v_seq_reg_num_t         rs1;
    rand risc_v_seq_funct3_t          funct3;
    rand risc_v_seq_s_type_imm0_t     imm0;
    
    `uvm_object_utils_begin(VX_risc_v_Stype_seq_item);    
        `uvm_field_int(imm1,   UVM_ALL_ON)
        `uvm_field_int(rs2,    UVM_ALL_ON)
        `uvm_field_int(rs1,    UVM_ALL_ON)
        `uvm_field_int(funct3, UVM_ALL_ON)
        `uvm_field_int(imm0,   UVM_ALL_ON)
        `uvm_field_int(opcode, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_Stype_seq_item");
        super.new(name);
    endfunction

    function void set_instruction_fields(string name, risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rs2,
                                        risc_v_seq_reg_num_t rs1, risc_v_seq_funct3_t funct3,
                                        risc_v_seq_opcode_t opcode);
        this.instr_name  = name;
        this.instr_type  = S_TYPE;                                
        this.imm1        = imm[11:5];
        this.rs2         = rs2;
        this.rs1         = rs1;
        this.imm0        = imm[4:0];
        this.funct3      = funct3;
        this.opcode      = opcode;
        set_raw_data_from_current_fields();
    endfunction

     function void set_instruction_with_data(string name, risc_v_seq_data_t raw_data);   
        this.instr_name  = name;
        this.instr_type  = S_TYPE;
        this.raw_data    = raw_data;
        {>>{this.imm1,this.rs2,this.rs1,this.funct3,this.imm0,this.opcode}} = raw_data;
    endfunction

    function void set_imm_field(risc_v_seq_imm_t imm);
        this.imm1 = imm[11:5];
        this.imm0 = imm[4:0];
        set_raw_data_from_current_fields();
    endfunction

    function void set_funct3(risc_v_seq_funct3_t funct3);
        this.funct3 = funct3;
        set_raw_data_from_current_fields();
    endfunction

    function void set_raw_data_from_current_fields();
        this.raw_data = {this.imm1,this.rs2,this.rs1,this.funct3,this.imm0,this.opcode};
    endfunction

    static function VX_risc_v_Stype_seq_item create_instruction_with_fields(string name,risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rs2,
                                        risc_v_seq_reg_num_t rs1, risc_v_seq_funct3_t funct3, risc_v_seq_opcode_t opcode
                                        );

        VX_risc_v_Stype_seq_item item = VX_risc_v_Stype_seq_item::type_id::create("VX_risc_v_Stype_seq_item");
        item.set_instruction_fields(name,imm,rs2,rs1,funct3,opcode);
        return item;
    endfunction

     static function VX_risc_v_Stype_seq_item create_instruction_with_data(string name, risc_v_seq_data_t raw_data);
        VX_risc_v_Stype_seq_item item = VX_risc_v_Stype_seq_item::type_id::create("VX_risc_v_Stype_seq_item");
        item.set_instruction_with_data(name, raw_data);
        return item;
    endfunction

endclass