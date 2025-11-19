import VX_tb_common_pkg::*;
   
class VX_split_join_doa_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_split_join_doa_seq)

    bit [3:0] predicate;

    function new(string name="VX_split_join_doa_seq");
        super.new(name);
    endfunction
     
    virtual function add_instructions();
        instr_queue.push_back(`ADDI(`RS1(2),`IMM_HEX(f),`RD(2)));
        instr_queue.push_back(`TMC(`RS1(2))); 
        instr_queue.push_back(`SPLIT(`RS1(2),`RS2(0),`RD(3)));
        instr_queue.push_back(`ADDI(`RS1(4),`IMM_HEX(8),`RD(4)));
        instr_queue.push_back(`JOIN(`RS1(3)));
    endfunction
    
endclass
