
interface VX_tb_top_if import VX_gpu_pkg::*; ();
    //Clk
    logic clk;

    //Resets
    logic gbar_reset;
    logic mem_load_reset;
    logic mem_reset;
    logic mem_arb_reset;
    logic icache_reset;
    logic dcache_reset;
    logic core_reset;

    //Mem
    logic load_mem;
    logic start_mem_loader;
    logic mem_loader_done;

endinterface

interface VX_uvm_test_if ();
    logic mem_load_seq_done;
    logic core_busy;
    modport slave(input mem_load_seq_done);
    modport master(output mem_load_seq_done);
endinterface

interface VX_tb_top_dcr_if import VX_gpu_pkg::*; ();
    logic write_valid;
    logic [VX_DCR_ADDR_WIDTH-1:0] write_addr;
    logic [VX_DCR_DATA_WIDTH-1:0] write_data;
endinterface
