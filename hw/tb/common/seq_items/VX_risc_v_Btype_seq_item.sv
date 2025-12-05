class VX_risc_v_Btype_seq_item extends VX_risc_v_instr_seq_item;

    rand bit                          imm_12;
    rand risc_v_seq_b_type_imm1_t     imm1;
    rand risc_v_seq_reg_num_t         rs2; 
    rand risc_v_seq_reg_num_t         rs1;
    rand risc_v_seq_funct3_t          funct3;
    rand risc_v_seq_b_type_imm0_t     imm0;
    rand bit                          imm_11;
    
    `uvm_object_utils_begin(VX_risc_v_Btype_seq_item);    
        `uvm_field_int(imm_12,      UVM_ALL_ON)
        `uvm_field_int(imm1,        UVM_ALL_ON)
        `uvm_field_int(rs2,         UVM_ALL_ON)
        `uvm_field_int(rs1,         UVM_ALL_ON)
        `uvm_field_int(funct3,      UVM_ALL_ON)
        `uvm_field_int(imm0,        UVM_ALL_ON)
        `uvm_field_int(imm_11,      UVM_ALL_ON)   
        `uvm_field_int(opcode,      UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_Btype_seq_item");
        super.new(name);
    endfunction

    function void set_instruction_fields(string name, risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rs2,
                                           risc_v_seq_reg_num_t rs1, risc_v_seq_funct3_t funct3
                                        );
        
        this.instr_name = name;
        this.instr_type = B_TYPE;                                
        this.imm_12     = imm[`IMM_12];
        this.imm1       = imm[10:5];
        this.rs2        = rs2;
        this.rs1        = rs1;
        this.funct3     = funct3;
        this.imm0       = imm[4:1];  
        this.imm_11     = imm[`IMM_11];
        this.opcode     = INST_B;
        this.raw_data   = {this.imm_12,this.imm1,this.rs2,this.rs1,this.funct3,this.imm0,this.imm_11,this.opcode};
    endfunction

    function void set_imm_field(risc_v_seq_imm_t imm);
        this.imm_12     = imm[`IMM_12];
        this.imm1       = imm[10:5];
        this.imm0       = imm[4:1];  
        this.imm_11     = imm[`IMM_11];
        this.raw_data   = {this.imm_12,this.imm1,this.rs2,this.rs1,this.funct3,this.imm0,this.imm_11,this.opcode};
    endfunction

    function void set_instruction_with_data(string name, risc_v_seq_data_t raw_data);   
        this.instr_name  = name;
        this.instr_type  = B_TYPE;
        this.raw_data    = raw_data;
        {>>{this.imm_12,this.imm1,this.rs2,this.rs1,this.funct3,this.imm0,this.imm_11,this.opcode}} = raw_data;
    endfunction

    static function VX_risc_v_Btype_seq_item create_instruction_with_fields(string name, risc_v_seq_imm_t imm, risc_v_seq_reg_num_t rs2,
                                           risc_v_seq_reg_num_t rs1, risc_v_seq_funct3_t funct3
                                        );

        VX_risc_v_Btype_seq_item item = VX_risc_v_Btype_seq_item::type_id::create("VX_risc_v_Btype_seq_item");
        item.set_instruction_fields(name, imm,rs2,rs1,funct3);
        return item;
    endfunction

    static function VX_risc_v_Btype_seq_item create_instruction_with_data(string name, risc_v_seq_data_t raw_data);
        
        VX_risc_v_Btype_seq_item item = VX_risc_v_Btype_seq_item::type_id::create("VX_risc_v_Btype_seq_item");
        item.set_instruction_with_data(name, raw_data);
        return item;
    endfunction


endclass