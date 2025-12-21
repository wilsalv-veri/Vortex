class Instruction_queue  #(type T = VX_risc_v_instr_seq_item) extends uvm_queue #(T);

    `uvm_object_utils(Instruction_queue)

    risc_v_seq_instr_address_t        current_address;

    function new(string name="Instruction_queue");
        super.new(name);
        current_address = `USER_BASE_ADDR;
    endfunction

    constraint initial_address_c {
        current_address == `USER_BASE_ADDR;
    }

    virtual function void push_back(VX_risc_v_instr_seq_item item);
        item.address = current_address;
        `VX_info("INSTRUCTION_QUEUE", $sformatf("Item Address: 0x%0h Current Address: 0x%0h USER_BASE: 0x%0h", item.address, current_address, `USER_BASE_ADDR))
        super.push_back(item);
        update_current_address();
    endfunction

    protected function void update_current_address();
        current_address += 4;
    endfunction

    virtual function void set_current_address(risc_v_seq_instr_address_t addr);
        current_address = addr;
    endfunction

    virtual function risc_v_seq_instr_address_t get_current_address();
        return current_address;
    endfunction
    
endclass

typedef Instruction_queue#(VX_risc_v_instr_seq_item) VX_risc_v_instr_queue;
