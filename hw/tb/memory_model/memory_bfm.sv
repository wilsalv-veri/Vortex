module Memory_BFM import VX_gpu_pkg::*; import VX_tb_top_pkg::*; import VX_tb_common_pkg::*; (
        input wire             clk,
        input wire             reset,
        VX_uvm_test_if.slave   uvm_test_if,  
        VX_mem_bus_if.slave    load_if, 
        VX_mem_bus_if.slave    mem_bus_if 
    );

    logic              load_req_ready, core_req_ready;
    logic              load_rsp_valid, core_rsp_valid;
    
    mem_operation_t    operation;
    addr_t             address;
    tag_t              tag;
    risc_v_cacheline_t data;
    
    memory_state_t     state;
    memory_state_t     next_state;
    memory_state_t     last_idle;
    

    risc_v_cacheline_t memory[int];
    tag_t              tag_mem[int];

    //Output Logic 
    always @ (*) begin
                        
        load_req_ready                           = 1'b0;
        load_rsp_valid                           = 1'b0;
                
        core_req_ready                           = 1'b0;
        core_rsp_valid                           = 1'b0;

        case(state)
            LOAD_IDLE: begin
                load_req_ready                   = 1'b1;
                last_idle                        = LOAD_IDLE;

            end
            CORE_REQ_IDLE:begin
                core_req_ready                   = 1'b1;
                last_idle                        = CORE_REQ_IDLE;

            end
            EXECUTE_OPERATION: begin
                case(operation) 
                    WRITE: begin
                        memory[address]         =  data;
                        tag_mem[address]        =  tag;
                    end
                endcase
            end
            EXECUTE_OPERATION_READ: begin
                case(last_idle)
                    LOAD_IDLE    : load_rsp_valid = 1'b1;
                    CORE_REQ_IDLE: core_rsp_valid = 1'b1;
                endcase
            end
        endcase    
    end
    
    //Next State Logic
    always_comb begin
        case (state)
            LOAD_IDLE: begin
                next_state                       = load_if.req_valid ? EXECUTE_OPERATION : LOAD_IDLE;
            end
            CORE_REQ_IDLE: begin
                next_state                       = mem_bus_if.req_valid ? EXECUTE_OPERATION : CORE_REQ_IDLE;
            end  
            EXECUTE_OPERATION: begin
                if (operation)
                    next_state                   = uvm_test_if.mem_load_seq_done ? CORE_REQ_IDLE : LOAD_IDLE;
                else if (mem_bus_if.rsp_ready)
                    next_state                   = EXECUTE_OPERATION_READ;
                else
                    next_state                   = EXECUTE_OPERATION;
            end
            EXECUTE_OPERATION_READ: begin
                    next_state                   = uvm_test_if.mem_load_seq_done ? CORE_REQ_IDLE : LOAD_IDLE;
            end
        endcase
    end

    always_ff @ (posedge clk)begin
        if (reset)
            state <= LOAD_IDLE;
        else
            state  <= next_state;

        case(state)
            LOAD_IDLE:begin
                data                            <= RESET_DATA;
                tag                             <= RESET_TAG;
                 if (load_if.req_valid) begin
                    operation                   <= mem_operation_t'(load_if.req_data.rw);
                    address                     <= load_if.req_data.addr; 
                    data                        <= load_if.req_data.data;
                    tag                         <= load_if.req_data.tag;
                end
            end
            CORE_REQ_IDLE:begin
                data                            <= RESET_DATA;
                tag                             <= RESET_TAG;
                if (mem_bus_if.req_valid) begin
                    operation                   <= mem_operation_t'(mem_bus_if.req_data.rw);
                    address                     <= mem_bus_if.req_data.addr; 
                    data                        <= mem_bus_if.req_data.data;
                    tag                         <= mem_bus_if.req_data.tag;
                end
            end
            EXECUTE_OPERATION: begin
                case(operation) 
                        READ: begin
                            data                <=  memory.exists(address)  ? memory[address]  : RESET_DATA;
                            tag                 <=  tag_mem.exists(address) ? tag_mem[address] : RESET_TAG; 
                        end
                endcase
            end
           
        endcase        
    end

    assign mem_bus_if.req_ready     = core_req_ready;
    assign mem_bus_if.rsp_valid     = core_rsp_valid;
    assign mem_bus_if.rsp_data.data = data;
    assign mem_bus_if.rsp_data.tag  = tag;
    
    assign load_if.req_ready        = load_req_ready;
    assign load_if.rsp_valid        = load_rsp_valid;
    assign load_if.rsp_data.data    = data;
    assign load_if.rsp_data.tag     = tag;
  
endmodule