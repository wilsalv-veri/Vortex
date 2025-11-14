class VX_risc_v_Vtype_seq_item extends VX_risc_v_inst_seq_item;

    rand risc_v_vfunary_seq_t         vfunary;
    rand risc_v_vm_seq_t              vm;
    rand risc_v_vfncvt_seq_t          vfncvt;    
    rand risc_v_opfvv_seq_t           opfvv;
    rand risc_v_seq_reg_num_t         vs2;
    rand risc_v_seq_reg_num_t         vd;

    `uvm_object_utils_begin(VX_risc_v_Vtype_seq_item);    
        `uvm_field_int(vfunary, UVM_ALL_ON)
        `uvm_field_int(vm     , UVM_ALL_ON)
        `uvm_field_int(vfncvt , UVM_ALL_ON)  
        `uvm_field_int(opfvv  , UVM_ALL_ON)
        `uvm_field_int(vs2    , UVM_ALL_ON)
        `uvm_field_int(vd     , UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="VX_risc_v_Vtype_seq_item");
        super.new(name);
    endfunction

    function void set_instruction_fields( risc_v_seq_reg_num_t vd, risc_v_vm_seq_t vm,
                                            risc_v_seq_reg_num_t vs  
                                        );

        this.vfunary   = 6'b010010;
        this.vm        = vm;
        this.vs2       = vs2;
        this.vfncvt    = 5'b010010;
        this.opfvv     = 3'b001;
        this.vd        = vd;
        this.opcode    = INST_V;
        this.raw_data  = {this.vfunary,this.vm,this.vs2,this.vfncvt,this.opfvv,this.vd,this.opcode};
    endfunction

    static function VX_risc_v_Vtype_seq_item create_instruction_with_fields( risc_v_seq_reg_num_t vd, risc_v_vm_seq_t vm,
                                            risc_v_seq_reg_num_t vs  
                                        );
        
        VX_risc_v_Vtype_seq_item  item = VX_risc_v_Vtype_seq_item::type_id::create("VX_risc_v_Vtype_seq_item");
        item.set_instruction_fields(vd,vm,vs);
        return item;   
    endfunction

endclass