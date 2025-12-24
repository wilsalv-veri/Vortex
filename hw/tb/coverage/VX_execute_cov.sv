module VX_alu_int_cov (input clk, 
                input logic [ALU_TYPE_BITS-1:0]  xtype,
                input logic [1:0]                alu_class, 
                input logic [INST_ALU_BITS-1:0]  alu_op, //only for alu op
                input logic                      is_sub_op,
                input logic                      is_signed,
                input logic                      use_pc,
                input logic                      use_imm,
                input logic                      result_valid,
                
                //Branch
                input logic                      is_br_op,
                input logic [1:0]                br_class, 
                input logic [INST_BR_BITS-1:0]   br_op, //only for br op
                input logic                      br_enable,           
                input logic                      is_br_neg,
                input logic                      is_br_less,
                input logic                      is_br_static,
                input logic                      br_wid,            
                input logic                      br_taken,
                input logic                      br_valid
                );


    covergroup alu_int_operations_cg @(posedge clk);
        
        option.per_instance = 1;

        coverpoint xtype {
            bins ALU_TYPE_ARITH = {ALU_TYPE_ARITH};
            bins ALU_TYPE_BRANC = {ALU_TYPE_BRANCH};
            bins ALU_TYPE_OTHER = {ALU_TYPE_OTHER};
        }

        coverpoint alu_op;
        
        cross xtype, alu_op {
            bins vote = (binsof (xtype) intersect {ALU_TYPE_OTHER}) && (binsof (alu_op) intersect {4'b0???});
            bins shfl = (binsof (xtype) intersect {ALU_TYPE_OTHER}) && (binsof (alu_op) intersect {4'b1???});
        }

        coverpoint alu_class;
        coverpoint is_sub_op;
        coverpoint is_signed;
        coverpoint use_pc;
        coverpoint use_imm;
        coverpoint result_valid;
               
        coverpoint is_br_op;
        coverpoint br_class;
        coverpoint br_op;
        coverpoint br_enable;          
        coverpoint is_br_neg;
        coverpoint is_br_less;
        coverpoint is_br_static;
        coverpoint br_wid;      
        coverpoint br_taken;
        coverpoint br_valid;

        cross br_enable, br_class, br_op, is_br_neg, is_br_less, is_br_static, br_taken, br_wid;   
    endgroup

    alu_int_operations_cg alu_int_wg  = new();

endmodule

module VX_alu_muldiv_cov (  input logic clk,
                            input logic mul_valid_in,
                            input logic mul_valid_out,
                            input logic [INST_M_BITS-1:0] muldiv_op,
                            input logic is_mulx_op,
                            input logic is_signed_op,
                            input logic is_mulh_in,
                            input logic is_signed_mul_a,
                            input logic is_signed_mul_b,

                            input logic div_valid_in,
                            input logic div_valid_out,
                            input logic is_rem_op,
                            input logic is_rem_op_out,
                            input logic is_div_w_out
                        );

    covergroup alu_muldiv_wg @(posedge clk);

        coverpoint mul_valid_in;
        coverpoint mul_valid_out;
        coverpoint muldiv_op;
        coverpoint is_mulx_op;
        coverpoint is_signed_op;
        coverpoint is_mulh_in;
        coverpoint is_signed_mul_a;
        coverpoint is_signed_mul_b;

        coverpoint div_valid_in;
        coverpoint div_valid_out;
        coverpoint is_rem_op;
        coverpoint is_rem_op_out;
        coverpoint is_div_w_out;

    endgroup

    alu_muldiv_wg muldiv_wg = new();

endmodule

module VX_lsu_cov (input logic clk,
                   input logic mem_req_fire,
                   input logic mem_rsp_fire,
                   input logic [LSU_WORD_SIZE-1:0] mem_req_byteen_w,
   
                   input logic req_is_fence,
                   input logic rsp_is_fence,
                   input logic fence_lock
                );

    covergroup lsu_cov_wg @ (posedge clk);
        coverpoint mem_req_fire;
        coverpoint mem_rsp_fire;

        coverpoint mem_req_byteen_w{
            bins ld_st_byte   = {4'b1};
            bins ld_st_half_w = {4'b11};
            bins ld_st_word   = {4'b1111};
        }

        cross mem_req_fire ,mem_req_byteen_w;
        cross mem_rsp_fire, mem_req_byteen_w;

        coverpoint req_is_fence;
        coverpoint rsp_is_fence;
        coverpoint fence_lock;
    endgroup

    lsu_cov_wg  lsu_wg = new();

endmodule