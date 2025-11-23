class VX_risc_v_Ftype_seq_item extends VX_risc_v_instr_seq_item;

    rand risc_v_seq_fm_t       fm;
    rand risc_v_seq_pred_t     pred;
    rand risc_v_seq_succ_t     succ;
    rand risc_v_seq_reg_num_t  rs1;
    rand risc_v_seq_funct3_t   funct3;
    rand risc_v_seq_reg_num_t  rd;
    
    `uvm_object_utils_begin(VX_risc_v_Ftype_seq_item);    
        `uvm_field_int(fm  ,   UVM_ALL_ON) 
        `uvm_field_int(pred,   UVM_ALL_ON)
        `uvm_field_int(succ,   UVM_ALL_ON) 
        `uvm_field_int(rs1,    UVM_ALL_ON) 
        `uvm_field_int(funct3, UVM_ALL_ON)
        `uvm_field_int(rd,     UVM_ALL_ON)
        `uvm_field_int(opcode, UVM_ALL_ON) 
    `uvm_object_utils_end

    function new(string name="VX_risc_v_Ftype_seq_item");
        super.new(name);
    endfunction

    function void set_instruction_fields(string name, risc_v_seq_fm_t fm, risc_v_seq_succ_t succ,
                                            risc_v_seq_pred_t pred, risc_v_seq_reg_num_t rd,
                                            risc_v_seq_reg_num_t rs1, risc_v_seq_funct3_t funct3
                                            );

        this.instr_name  = name;
        this.instr_type  = F_TYPE;
        this.fm          = fm;
        this.succ        = succ;
        this.pred        = pred;
        this.rs1         = rs1;
        this.funct3      = funct3;
        this.rd          = rd;
        this.opcode      = INST_FENCE;
        this.raw_data    = {this.fm,this.succ,this.pred,this.rs1,this.funct3,this.rd,this.opcode};
    endfunction
    
    static function VX_risc_v_Ftype_seq_item create_instruction_with_fields(string name, risc_v_seq_fm_t fm, risc_v_seq_succ_t succ,
                                            risc_v_seq_pred_t pred, risc_v_seq_reg_num_t rd,
                                            risc_v_seq_reg_num_t rs1, risc_v_seq_funct3_t funct3
                                            );

        VX_risc_v_Ftype_seq_item item = VX_risc_v_Ftype_seq_item::type_id::create("VX_risc_v_Ftype_seq_item");
        item.set_instruction_fields(name,fm,succ,pred,rd,rs1,funct3);
        return item;
    endfunction 
endclass