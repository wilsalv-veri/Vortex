class VX_risc_v_driver  extends uvm_driver #(VX_risc_v_seq_item);

    `uvm_component_utils(VX_risc_v_driver)

    localparam INSTRUCTION_INSERTION_MSB = `CACHE_LINE_WIDTH - 1;
    localparam INSTRUCTION_INSERTION_LSB = `CACHE_LINE_WIDTH - PC_BITS;

    localparam REST_OF_CACHELINE_MSB     = INSTRUCTION_INSERTION_LSB - 1;
    localparam REST_OF_CACHELINE_LSB     = 0;

    VX_risc_v_seq_item risc_v_seq_item;
    VX_risc_v_instr_seq_item instr_item;

    uvm_blocking_get_port   #(int) receive_seq_num_insts;

    `uvm_blocking_put_imp_decl(_seq_lib_seq_num)
    uvm_blocking_put_imp_seq_lib_seq_num  #(int, VX_risc_v_driver) receive_seq_lib_seq_num;

    uvm_analysis_port #(VX_risc_v_instr_seq_item) instr_analysis_port;

    //For instruction type creation
    risc_v_cacheline_data_t data_word;
    risc_v_cacheline_t      cacheline = 512'b0;
    
    risc_v_driver_state_t   driver_state = GET_INSTR;
    risc_v_data_type_t      data_type;
    
    virtual VX_risc_v_inst_if riscv_inst_ifc;
    virtual VX_mem_load_if    mem_load_ifc;

    int   word_count        = 0;
    int   words_to_send     = 0;
    int   seq_lib_seq_count = 0;
    int   seq_lib_seqs      = 1;
    int   shift_amount      = 0;
    logic instr_received    = 1'b0;

    function new(string name="VX_risc_v_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        risc_v_seq_item         = VX_risc_v_seq_item::type_id::create("riscv_driver_item");
        receive_seq_num_insts   = new("UVM_GET_SEQ_NUM_INSTS", this);
        receive_seq_lib_seq_num = new("UVM_GET_SEQ_LIB_SEQ_NUM", this); 
        instr_analysis_port     = new("VX_RISC_V_DRIVER_ANALYSIS_PORT", this);

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
            
            driver_state                   <= get_next_state();;
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
                    if (word_count &&  should_send_cacheline())  
                                        next_state  = SEND_INSTR;
                    else
                                        next_state =  GET_INSTR;
                end

                SEND_INSTR             : next_state = GET_INSTR;
            endcase
            return next_state;
    endfunction

    task get_instr();
        seq_item_port.get_next_item(risc_v_seq_item);
            
        data_type                       <= risc_v_seq_item.data_type;
        data_word                       <= risc_v_seq_item.raw_data;
        instr_received                  <= 1'b1;
    endtask

    task process_instr();
        word_count                      <= word_count + 1;
        shift_amount                    <= get_shift_amount();
        cacheline                       <= {data_word, cacheline[REST_OF_CACHELINE_MSB:REST_OF_CACHELINE_LSB]} >> get_shift_amount();
        instr_received                  <= 1'b0;
        `VX_info("VX_RISC_V_DRIVER", $sformatf("Word_Count: %0d Words_to_Send: %0d Seq_Lib_Seq_Count: %0d Seq_Lib_Seq: %0d ",word_count, words_to_send, seq_lib_seq_count, seq_lib_seqs))
        `VX_info("VX_RISC_V_DRIVER", $sformatf("Shift Amount: %0d",get_shift_amount()))
       
        if (data_type == INST) begin
            $cast(instr_item,risc_v_seq_item);
            `VX_info("VX_RISC_V_DRIVER", $sformatf("Sending Instr With PC: 0x%0h", instr_item.address))
            instr_analysis_port.write(instr_item);
        end
        seq_item_port.item_done();
    endtask

    task send_instr(); 
        `VX_info("VX_RISC_V_DRIVER", "Waiting For Load Ready")
        wait(mem_load_ifc.load_ready);
        `VX_info("VX_RISC_V_DRIVER", "Sending Cacheline")
        `VX_info("VX_RISC_V_DRIVER", $sformatf("Cacheline: 0x%0h",cacheline))
            
        mem_load_ifc.cacheline                   <= cacheline;
        mem_load_ifc.load_valid                  <= 1'b1;
        mem_load_ifc.data_type                   <= data_type;
    endtask

    function int get_shift_amount();
        `VX_info("VX_RISC_V_DRIVER", $sformatf("Should Send Cacheline: %0d Word_Count:%0d", should_send_cacheline, word_count))
               
        return should_send_cacheline() ? 
                        (INST_PER_CACHE_LINE - (word_count % INST_PER_CACHE_LINE) - 1)*PC_BITS : PC_BITS;
                 
    endfunction

    task get_seq_num_insts();

        int num_words;
        
        forever begin
            receive_seq_num_insts.get(num_words);
            seq_lib_seq_count++;

            words_to_send += num_words;
            
            `VX_info("VX_RISC_V_DRIVER", $sformatf("Number of Words To Send: %0d Current Word Count: %0d", num_words, words_to_send))
        
        end
        
    endtask

    virtual task put_seq_lib_seq_num(int num_of_seqs);
        seq_lib_seqs = num_of_seqs;
        `VX_info("VX_RISC_V_DRIVER", $sformatf("Number of Sequences in Seq Lib: %0d", seq_lib_seqs))
    endtask
    
    virtual function bit should_send_cacheline();
        return (all_words_received() || cacheline_filled()) ? 1'b1 : 1'b0;
    endfunction

    virtual function bit all_words_received();
        return ((word_count == (words_to_send - 1)) && (seq_lib_seq_count == seq_lib_seqs));
    endfunction

    virtual function bit cacheline_filled();
        return (word_count % INST_PER_CACHE_LINE) == (INST_PER_CACHE_LINE - 1);
    endfunction
endclass