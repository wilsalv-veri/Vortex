`include "VX_define.vh"

module VX_mem_loader import VX_gpu_pkg::*; import VX_tb_top_pkg::*; import VX_tb_common_pkg::*;(
                    input                     clk,
                    input                     reset,
                    
                    VX_mem_load_if.slave      mem_load_if,
                    VX_mem_bus_if.master      mem_load_bus_if
                    
);

memory_load_state_t state;
memory_load_state_t next_state;

//Req Data
logic rw;
logic [`MEM_ADDR_WIDTH - `CLOG2(`L1_LINE_SIZE) - 1:0] addr;
logic [L1_MEM_ARB_TAG_WIDTH - 1:0]  tag;
risc_v_cacheline_t data;

int unsigned inst_cacheline_count = 0;
int unsigned data_cacheline_count = 0;

logic        req_valid;
logic        rsp_ready;
logic        load_ready      = 1'b0;

//Output Logic 
always_comb begin

    rw                                  = READ;
    addr                                = RESET_ADDR;
    tag                                 = RESET_TAG;
    data                                = RESET_DATA;
    
    req_valid                           = 1'b0;
    
    case(state)
        MEM_LOAD_DONE: begin
            if (mem_load_if.load_valid)begin 
                `VX_info("VX_MEM_LOADER", "Received Cacheline from Driver")
        
                req_valid               = 1'b1;
                rw                      = 1'b1;
                addr                    = (mem_load_if.data_type == INST) ? 
                                           (MEM_LOAD_BOOT_ADDR + inst_cacheline_count) : 
                                           MEM_LOAD_DATA_BASE_ADDR + data_cacheline_count;
                data                    = mem_load_if.cacheline;
            end
        end
 
    endcase
end

//Next-State Logic
always_comb begin   
    case(state)
        MEM_LOAD_IDLE  :  next_state = mem_load_bus_if.req_ready ?  MEM_LOAD_DONE : MEM_LOAD_IDLE;
        MEM_LOAD_DONE  :  next_state = mem_load_if.load_valid    ?  MEM_LOAD_IDLE : MEM_LOAD_DONE;
    endcase    
end

always @ (posedge clk)begin
    if(reset)
        state          <= MEM_LOAD_IDLE;
    else
        state          <= next_state;

    case(state)
        MEM_LOAD_IDLE: begin
            if (mem_load_bus_if.req_ready) begin
                    `VX_info("VX_MEM_LOADER", "Load Ready")
        
                    load_ready               <= 1'b1;
                    
            end
        end
        MEM_LOAD_DONE: begin
            if (mem_load_if.load_valid)begin
                    load_ready               <= 1'b0;

                    if(mem_load_if.data_type == INST) 
                        inst_cacheline_count <=  inst_cacheline_count + 1;
                    else 
                        data_cacheline_count <=  data_cacheline_count + 1;
                    
            end
        end
       
    endcase
end

assign mem_load_bus_if.req_data.rw     = rw;
assign mem_load_bus_if.req_data.addr   = addr;
assign mem_load_bus_if.req_data.tag    = tag;
assign mem_load_bus_if.req_data.data   = data;

assign mem_load_bus_if.req_valid       = req_valid;
assign mem_load_bus_if.rsp_ready       = rsp_ready;

assign mem_load_if.load_ready          = load_ready;

endmodule