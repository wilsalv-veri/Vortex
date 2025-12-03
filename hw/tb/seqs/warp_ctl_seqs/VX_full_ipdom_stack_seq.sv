class VX_full_ipdom_stack_seq extends VX_risc_v_base_instr_seq;

    `uvm_object_utils(VX_full_ipdom_stack_seq)

   
    function new(string name="VX_full_ipdom_stack_seq");
        super.new(name);
    endfunction

    virtual function void add_instructions();
        //SETUP
        instr_queue.push_back(`ADDI(`RS1(1),`IMM_BIN(3),`RD(1)));
        instr_queue.push_back(`TMC(`RS1(1)));         
        
        instr_queue.push_back(`ADDI(`RS1(2),`IMM_BIN(7),`RD(2)));
        instr_queue.push_back(`ADDI(`RS1(3),`IMM_BIN(1),`RD(3)));
        instr_queue.push_back(`TMC(`RS1(2)));         
        instr_queue.push_back(`ADDI(`RS1(4),`IMM_HEX(f),`RD(4)));
        instr_queue.push_back(`TMC(`RS1(4))); 
        instr_queue.push_back(`SPLIT(`RS1(4),`RS2(0),`RD(5)));
        
        //FIRST THEN
        
        //SECOND THEN
        instr_queue.push_back(`SPLIT(`RS1(3),`RS2(0),`RD(6)));
        
        //THIRD THEN
        instr_queue.push_back(`SPLIT(`RS1(1),`RS2(0),`RD(1))); 
        instr_queue.push_back(`ADDI(`RS1(7),`IMM_HEX(9),`RD(7)));
        instr_queue.push_back(`JOIN(`RS1(1)));
        //THIRD ELSE
        instr_queue.push_back(`ADDI(`RS1(8),`IMM_HEX(a),`RD(8)));
        instr_queue.push_back(`JOIN(`RS1(1)));
        

        instr_queue.push_back(`ADDI(`RS1(9),`IMM_HEX(b),`RD(9)));
        instr_queue.push_back(`JOIN(`RS1(6)));
        //SECOND ELSE
        instr_queue.push_back(`ADDI(`RS1(10),`IMM_HEX(c),`RD(10)));
        instr_queue.push_back(`JOIN(`RS1(6)));
        
        instr_queue.push_back(`ADDI(`RS1(11),`IMM_HEX(d),`RD(11)));
        instr_queue.push_back(`JOIN(`RS1(5)));
        
        //FIRST ELSE
        instr_queue.push_back(`ADDI(`RS1(12),`IMM_HEX(e),`RD(12)));
        instr_queue.push_back(`JOIN(`RS1(5)));
        instr_queue.push_back(`ADDI(`RS1(13),`IMM_HEX(f),`RD(13))); 
    endfunction

endclass