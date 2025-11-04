import VX_gpu_pkg::*;

//TODO: Parameterize 
typedef logic [511:0] cache_line_t;
typedef logic [25:0]  addr_t;

typedef logic [48:0] tag_t;
typedef enum {READ=0, WRITE=1} operation_t;
typedef enum {IDLE=0, EXECUTE_OPERATION=1, EXECUTE_OPERATION_READ=2} memory_state_t;

`define RESET_DATA 512'hdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef
`define RESET_TAG  48'h0  

module Memory_BFM (
        input wire             clk,
        input wire             reset,
        input wire             load,
        VX_mem_bus_if.slave    load_if, 
        VX_mem_bus_if.slave    mem_bus_if 
    );

    
    logic          req_ready;
    logic          rsp_valid;
    
    operation_t    operation;
    addr_t         address;
    cache_line_t   data;
    tag_t          tag;
    
    memory_state_t state;
    memory_state_t next_state;
    
    cache_line_t   memory[int];
    tag_t          tag_mem[int];

    //Output Logic 
    always @ (*) begin
                
        case(state)
            IDLE: begin
                req_ready                           = 1'b1;
                rsp_valid                           = 1'b0;
        
                operation               = load ? operation_t'(load_if.req_data.rw) : operation_t'(mem_bus_if.req_data.rw);
                address                 = load ? addr_t'(load_if.req_data.addr) : addr_t'(mem_bus_if.req_data.addr);
                data                    = load ? load_if.req_data.data : mem_bus_if.req_data.data;
                tag                     = load ? load_if.req_data.tag : mem_bus_if.req_data.tag;
            end
            EXECUTE_OPERATION: begin
                case(operation) 
                    WRITE: begin
                        memory[address]  =  data;
                        tag_mem[address] =  tag;
                    end
                endcase
            end
            EXECUTE_OPERATION_READ: begin
                rsp_valid                   =  1'b1;
                data                        =  memory.exists(address) ? memory[address] :   `RESET_DATA;
                tag                         =  tag_mem.exists(address) ? tag_mem[address] : `RESET_TAG; 
            end

        endcase    
    end
    
    //Next State Logic
    always_comb begin

        if (reset) begin
            next_state     = IDLE;
        end
        else begin
            case (state)
                IDLE: next_state               = (load_if.req_valid || mem_bus_if.req_valid) ? EXECUTE_OPERATION : IDLE;
                EXECUTE_OPERATION: begin
                    if (operation)
                        next_state            = IDLE;
                    else if (mem_bus_if.rsp_ready)
                        next_state            = EXECUTE_OPERATION_READ;
                    else
                        next_state            = EXECUTE_OPERATION;
                end
                EXECUTE_OPERATION_READ: next_state  = IDLE;
            endcase
        end
    end

    always @ (posedge clk)begin
         state  <= next_state;
    end

    assign mem_bus_if.req_ready     = req_ready;
    assign mem_bus_if.rsp_valid     = rsp_valid;
    assign mem_bus_if.rsp_data.data = data;
    assign mem_bus_if.rsp_data.tag  = tag;
    
    assign load_if.req_ready        = req_ready;
    assign load_if.rsp_valid        = rsp_valid;
    assign load_if.rsp_data.data    = data;
    assign load_if.rsp_data.tag     = tag;
  
endmodule