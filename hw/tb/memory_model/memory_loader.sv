
`define RESET_DATA 512'hdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef
`define RESET_TAG  48'h0  

typedef enum {MEM_LOAD_IDLE=0, MEM_LOAD_DONE=1} memory_load_state_t;

module VX_mem_loader (
                    input                     clk,
                    input                     reset,
                    
                    input                     start_loading,
                    output                    done_loading,

                    VX_mem_bus_if.master      mem_load_bus_if
                    
);
                                 //2000f133
localparam inst0               = { 7'b0100000,5'b0,5'b1 ,3'b111,5'b10, 7'b0110011};
localparam cache_line          = {479'b0,inst0};


//Req Data
logic [511:0] data; //TODO: Parameterize 
logic [47:0]  tag;
logic rw;
logic [25:0] addr;

logic done;
logic req_valid;

logic rsp_ready;

memory_load_state_t state;
memory_load_state_t next_state;

//Output Logic 
always_comb begin

    data                              = 512'b0;
    rw                                = 1'b0;
    addr                              = 26'b0;
    tag                               = `RESET_TAG;

    done                              = 1'b0;
    req_valid                         = 1'b0;
    
    case(state)
        
        MEM_LOAD_IDLE: begin
            if (start_loading && mem_load_bus_if.req_ready)begin
                req_valid                 = 1'b1;
                data                      = cache_line;
                rw                        = 1'b1;
                addr                      = 26'h4;
            end
        end
        
        MEM_LOAD_DONE: begin 
            done                      = 1'b1;
        end
    endcase
end

//Next-State Logic
always_comb begin
    if (reset)
        next_state = MEM_LOAD_IDLE;
    else begin
         
        case(state)
            MEM_LOAD_IDLE:      next_state = (start_loading && mem_load_bus_if.req_ready) ? MEM_LOAD_DONE : MEM_LOAD_IDLE;
            MEM_LOAD_DONE:      next_state = MEM_LOAD_DONE;
        endcase    
    end
end

always @ (posedge clk)begin
    state          <= next_state;
end

assign mem_load_bus_if.req_data.data   = data;
assign mem_load_bus_if.req_data.rw     = rw;
assign mem_load_bus_if.req_data.addr   = addr;
assign mem_load_bus_if.req_data.tag    = tag;

assign mem_load_bus_if.req_valid       = req_valid;
assign mem_load_bus_if.rsp_ready       = rsp_ready;

assign done_loading                    = done;


endmodule