module VX_scoreboard_cov (  input clk,
                            input logic [NUM_SRC_OPDS:0] operands_busy
                          );

        covergroup scoreboard_wg @ (posedge clk);

            option.per_instance = 1;

            coverpoint operands_busy{
                bins operands_busy_valid = {[1:7]};
                wildcard bins rs1_busy   = {3'b??1};
                wildcard bins rs2_busy   = {3'b?1?};
                wildcard bins rs3_busy   = {3'b1??};
            }
            
        endgroup

        scoreboard_wg scbd_wg  = new();
endmodule

module VX_opc_cov (input clk, 
                   input logic [NUM_SRC_OPDS-1:0] src_valid,
                   input logic has_collision
                  );

    covergroup operand_collector_wg @ (posedge clk);
        
        option.per_instance = 1;

        coverpoint has_collision;

        coverpoint src_valid {
            bins instr_src_valid = {[1:7]};
            wildcard bins rs1_valid   = {3'b??1};
            wildcard bins rs2_valid  = {3'b?1?};
            wildcard bins rs3_valid   = {3'b1??};
        }
    endgroup

    operand_collector_wg opc_wg    = new();

endmodule 

module VX_gpr_cov #(parameter PER_OPC_WARPS    = PER_ISSUE_WARPS / `NUM_OPCS,
                    parameter BANK_DATA_WIDTH  = `XLEN * `SIMD_WIDTH,
                    parameter BANK_DATA_SIZE   = BANK_DATA_WIDTH / 8,
                    parameter BANK_SIZE        = (NUM_REGS * SIMD_COUNT * PER_OPC_WARPS) / `NUM_BANKS,
                    parameter BANK_ADDR_WIDTH  = `CLOG2(BANK_SIZE)
                )
    
                ( input clk,
                    input logic gpr_read,
                    input logic gpr_write, 
                    input logic [BANK_ADDR_WIDTH-1:0] gpr_wr_set,
                    input logic [BANK_ADDR_WIDTH-1:0] gpr_rd_set, 
                    input logic [BANK_DATA_SIZE-1:0]  gpr_wr_byteen
                );
        
        covergroup gen_pupose_reg_cov @ (posedge clk);
            option.per_instance = 1;

            coverpoint gpr_read;
            coverpoint gpr_write;

            coverpoint gpr_rd_set;
            coverpoint gpr_wr_set;

            coverpoint gpr_wr_byteen{

                wildcard bins byte0_wr =  {16'b???????????????1};
                wildcard bins byte1_wr =  {16'b??????????????1?};
                wildcard bins byte2_wr =  {16'b?????????????1??};
                wildcard bins byte3_wr =  {16'b????????????1???};
                wildcard bins byte4_wr =  {16'b???????????1????};
                wildcard bins byte5_wr =  {16'b??????????1?????};
                wildcard bins byte6_wr =  {16'b?????????1??????};
                wildcard bins byte7_wr =  {16'b????????1???????};
                wildcard bins byte8_wr =  {16'b???????1????????};
                wildcard bins byte9_wr =  {16'b??????1?????????};
                wildcard bins byte10_wr = {16'b?????1??????????};
                wildcard bins byte11_wr = {16'b????1???????????};
                wildcard bins byte12_wr = {16'b???1????????????};
                wildcard bins byte13_wr = {16'b??1?????????????};
                wildcard bins byte14_wr = {16'b?1??????????????};
                wildcard bins byte15_wr = {16'b1???????????????};
                
                wildcard bins thread0_allbytes = {16'b????????????1111};
                wildcard bins thread1_allbytes = {16'b????????1111????};
                wildcard bins thread2_allbytes = {16'b????1111????????};
                wildcard bins thread3_allbytes = {16'b1111????????????};
            }
        endgroup

        gen_pupose_reg_cov gpr_cov = new(); 

endmodule