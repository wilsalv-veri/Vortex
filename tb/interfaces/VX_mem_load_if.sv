interface VX_mem_load_if import VX_tb_common_pkg::*; ();

    logic                 clk;
    logic                 load_ready;
    logic                 load_valid;

    risc_v_data_type_t    data_type;
    risc_v_cacheline_t    cacheline;

    modport slave (input  clk,
                   output load_ready,
                   input  data_type,
                   input  load_valid,
                   input  cacheline
                   );
    
    modport master(input  clk, 
                   input  load_ready,
                   output data_type,
                   output load_valid,
                   output cacheline
                   );
    
endinterface