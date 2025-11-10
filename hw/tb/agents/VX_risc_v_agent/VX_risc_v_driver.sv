class VX_risc_v_driver  extends uvm_driver #(VX_risc_v_inst_item);

    `uvm_component_utils(VX_risc_v_driver)

    localparam INSTRUCTION_INSERTION_MSB = `CACHE_LINE_WIDTH - 1;
    localparam INSTRUCTION_INSERTION_LSB = `CACHE_LINE_WIDTH - PC_BITS;

    localparam REST_OF_CACHELINE_MSB     = INSTRUCTION_INSERTION_LSB - 1;
    localparam REST_OF_CACHELINE_LSB     = 0;

    VX_risc_v_inst_item risc_v_inst_seq_item;
    
    uvm_blocking_get_port #(int) receive_seq_num_insts;

    //For instruction type creation
    risc_v_inst_t      risc_v_inst;
    risc_v_cacheline_t cacheline = 512'b0;
    
    risc_v_driver_state_t driver_state = GET_INSTR;
    
    virtual VX_risc_v_inst_if riscv_inst_ifc;
    virtual VX_mem_load_if    mem_load_ifc;

    int inst_count        = 0;
    int insts_to_send     = 0;
    int shift_amount      = 0;
    logic instr_received  = 1'b0;

    function new(string name="VX_risc_v_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `VX_info("VX_RISC_V_DRIVER", "Built Monitor")
        
        risc_v_inst_seq_item  = VX_risc_v_inst_item::type_id::create("riscv_driver_inst");
        
        receive_seq_num_insts = new("UVM_GET_SEQ_NUM_INSTS", this);
        
        if (!uvm_config_db #(virtual VX_risc_v_inst_if)::get(this, "", "riscv_inst_ifc", riscv_inst_ifc))
            `VX_error("VX_RISC_V_DRIVER", "Failed to get access to VX_risc_v_inst_if")

        if (!uvm_config_db #(virtual VX_mem_load_if)::get(this, "", "mem_load_ifc", mem_load_ifc))
            `VX_error("VX_RISC_V_DRIVER", "Failed to get access to VX_mem_load_if")

    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        mem_load_ifc.load_valid                         = 1'b0;
        
        fork 
            get_seq_num_insts();
        join_none
        
        forever @ (posedge mem_load_ifc.clk) begin    
            
            driver_state                <= get_next_state();;
            if (! mem_load_ifc.load_valid) begin
                case(driver_state)
                    GET_INSTR             : begin 
                                        if (!instr_received)
                                            get_instr(); 
                    end
                    PROCESS_INSTR         : process_instr();
                    SEND_INSTR            : send_instr();
                endcase
            end
            else if (!mem_load_ifc.load_ready) begin
                mem_load_ifc.load_valid    <= 1'b0;
                cacheline                  <= 512'b0;
            end
        end
        
    endtask

    function risc_v_driver_state_t get_next_state();
            risc_v_driver_state_t next_state;

            case(driver_state)
                GET_INSTR             : next_state  = instr_received ? PROCESS_INSTR : GET_INSTR;
                PROCESS_INSTR      : begin
                    if ((inst_count && ((inst_count % INST_PER_CACHE_LINE) == 0))  || inst_count == insts_to_send) 
                                        next_state  = SEND_INSTR;
                    else
                                        next_state =  GET_INSTR;
                end

                SEND_INSTR             : next_state = GET_INSTR;
            endcase
            return next_state;
    endfunction

    task get_instr();
        seq_item_port.get_next_item(risc_v_inst_seq_item);
        
        `VX_info("[VX_RISC_V_DRIVER]", $sformatf("Instruction Received! Type:%s", risc_v_inst_seq_item.inst_type.name));
            
        case(risc_v_inst_seq_item.inst_type)
            R_TYPE: begin
                risc_v_inst.r_type_inst.funct7       <= risc_v_inst_seq_item.funct7;
                risc_v_inst.r_type_inst.rs2          <= risc_v_inst_seq_item.rs2;
                risc_v_inst.r_type_inst.rs1          <= risc_v_inst_seq_item.rs1;
                risc_v_inst.r_type_inst.funct3       <= risc_v_inst_seq_item.funct3;
                risc_v_inst.r_type_inst.rd           <= risc_v_inst_seq_item.rd;
                risc_v_inst.r_type_inst.opcode       <= risc_v_inst_seq_item.opcode;
            end  
            I_TYPE: begin  
                risc_v_inst.i_type_inst.imm          <= risc_v_inst_seq_item.i_type_imm;
                risc_v_inst.i_type_inst.rs1          <= risc_v_inst_seq_item.rs1;
                risc_v_inst.i_type_inst.funct3       <= risc_v_inst_seq_item.funct3;
                risc_v_inst.i_type_inst.rd           <= risc_v_inst_seq_item.rd;
                risc_v_inst.i_type_inst.opcode       <= risc_v_inst_seq_item.opcode;
            end  
            S_TYPE: begin  
                risc_v_inst.s_type_inst.imm1         <= risc_v_inst_seq_item.s_type_imm1;
                risc_v_inst.s_type_inst.rs1          <= risc_v_inst_seq_item.rs1;
                risc_v_inst.s_type_inst.funct3       <= risc_v_inst_seq_item.funct3;
                risc_v_inst.s_type_inst.imm0         <= risc_v_inst_seq_item.s_type_imm0;
                risc_v_inst.s_type_inst.opcode       <= risc_v_inst_seq_item.opcode;
            end  
            B_TYPE: begin  
                risc_v_inst.b_type_inst.twelve       <= risc_v_inst_seq_item.twelve;
                risc_v_inst.b_type_inst.imm1         <= risc_v_inst_seq_item.b_type_imm1;
                risc_v_inst.b_type_inst.rs2          <= risc_v_inst_seq_item.rs2;
                risc_v_inst.b_type_inst.rs1          <= risc_v_inst_seq_item.rs1;
                risc_v_inst.b_type_inst.funct3       <= risc_v_inst_seq_item.funct3;
                risc_v_inst.b_type_inst.imm0         <= risc_v_inst_seq_item.b_type_imm0;
                risc_v_inst.b_type_inst.eleven       <= risc_v_inst_seq_item.eleven;
                risc_v_inst.b_type_inst.opcode       <= risc_v_inst_seq_item.opcode;
            end  
            U_TYPE: begin  
                risc_v_inst.u_type_inst.imm          <= risc_v_inst_seq_item.u_type_imm;
                risc_v_inst.u_type_inst.rd           <= risc_v_inst_seq_item.rd;
                risc_v_inst.u_type_inst.opcode       <= risc_v_inst_seq_item.opcode;
            end  
            J_TYPE: begin  
                risc_v_inst.j_type_inst.twenty       <= risc_v_inst_seq_item.twenty;
                risc_v_inst.j_type_inst.imm1         <= risc_v_inst_seq_item.j_type_imm1;
                risc_v_inst.j_type_inst.eleven       <= risc_v_inst_seq_item.eleven;
                risc_v_inst.j_type_inst.imm0         <= risc_v_inst_seq_item.j_type_imm0;
                risc_v_inst.j_type_inst.rd           <= risc_v_inst_seq_item.rd;
                risc_v_inst.j_type_inst.opcode       <= risc_v_inst_seq_item.opcode;
            end
        endcase
        
        inst_count                                   <= inst_count + 1;
        instr_received                               <= 1'b1;
    endtask

    task process_instr();
        `VX_info("[VX_RISC_V_DRIVER]", $sformatf("Processing Instruction Data: %0h",  risc_v_inst.inst_data));
        shift_amount                                 <= get_shift_amount();
        cacheline                                    <= {risc_v_inst.inst_data, cacheline[REST_OF_CACHELINE_MSB:REST_OF_CACHELINE_LSB]} >> get_shift_amount();
        instr_received                               <= 1'b0;
        seq_item_port.item_done();
    endtask

    task send_instr();
       
        `VX_info("VX_RISC_V_DRIVER", "Waiting For Load Ready")
        wait(mem_load_ifc.load_ready);
        `VX_info("VX_RISC_V_DRIVER", "Sending Cacheline")
            
        mem_load_ifc.cacheline                   <= cacheline;
        mem_load_ifc.load_valid                  <= 1'b1;
        mem_load_ifc.cacheline_type              <= INST;
    endtask

    function int get_shift_amount();
        return (inst_count  == insts_to_send) ? 
                        (INST_PER_CACHE_LINE - (inst_count % INST_PER_CACHE_LINE))*PC_BITS : PC_BITS;
        
    endfunction

    task get_seq_num_insts();

        int num_insts;
        
        forever begin
            receive_seq_num_insts.get(num_insts);
            `VX_info("VX_RISC_V_DRIVER", $sformatf("Number of Insts Received: %0d", num_insts))
        
            if (inst_count == insts_to_send)begin
                inst_count    = 0;
                insts_to_send = num_insts;
            end
            else 
                insts_to_send += num_insts;
        end
        
    endtask

endclass