interface VX_sched_tb_if import VX_tb_common_pkg::*;();

    logic                                           clk;
    logic                                           reset;
    logic                                           warp_ctl_valid;
    logic                                           wspawn_valid;
    logic                                           join_valid;
    VX_ipdom_wr_ptrs_t                              ipdom_wr_ptrs;
    logic                                           curr_single_warp;
    logic [`NUM_WARPS-1:0]                          active_warps; // updated when a warp is activated or disabled
    logic [`NUM_WARPS-1:0]                          stalled_warps;  // set when branch/gpgpu instructions are issued

    logic [`NUM_WARPS-1:0][`NUM_THREADS-1:0]        thread_masks;
    logic [`NUM_WARPS-1:0][PC_BITS-1:0]             warp_pcs;
    logic [PC_BITS-1:0]                             result_pc;
    logic [NW_WIDTH-1:0]                            wid;
    logic [`UP( `CLOG2(`NUM_SFU_LANES))-1:0]        last_tid;

    logic [`NUM_ALU_BLOCKS-1:0]                     br_valid;
    logic [`NUM_ALU_BLOCKS-1:0] [NW_WIDTH-1:0]      br_wid;
    logic [`NUM_ALU_BLOCKS-1:0]                     br_taken;
    risc_v_instr_address_t  [`NUM_ALU_BLOCKS-1:0]   br_target;
    risc_v_instr_address_t                          br_pc;


    clocking wctl_cb @(posedge clk);
        input reset;
        input warp_ctl_valid;
        input active_warps; 
        input stalled_warps;  
        input thread_masks;
        input result_pc;
        input wid;
        input last_tid;
    endclocking

    clocking wspawn_cb @(posedge clk);
        input wspawn_valid;
        input curr_single_warp;  
        input active_warps; 
        input warp_pcs;
    endclocking

    clocking join_cb @ (posedge clk);
        input join_valid;
        input ipdom_wr_ptrs;
        input thread_masks;
        input result_pc;
    endclocking

    clocking branch_cb @(posedge clk);
        input br_valid;
        input br_pc;
        input br_wid;
        input br_taken;
        input br_target;
        input warp_pcs;
    endclocking
    
endinterface 