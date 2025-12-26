module VX_lsu_assert (input                clk, 
                      VX_lsu_mem_if.master lsu_mem_if,
                      input logic          req_is_fence,
                      input logic          fence_lock
                    );
    
    load_request_is_responded : assert property (@ (posedge clk) $rose(lsu_mem_if.req_valid) && !lsu_mem_if.req_data.rw |=> s_eventually $rose(lsu_mem_if.rsp_valid)) else `VX_sva_error("Load Request Was Never Responded");
    fence_is_unlocked         : assert property (@ (posedge clk) $rose(fence_lock) |-> s_eventually $fell(fence_lock)) else `VX_sva_error("Fence Was Never Released");

endmodule