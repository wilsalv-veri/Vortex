module VX_scoreboard_assert (input clk,
                             logic [NUM_REGS-1:0]               inuse_regs_n,
                             logic [REG_TYPES-1:0]              regs_busy,
                             logic                              operands_ready_r
                            );
 
    for(genvar reg_num=0; reg_num < NUM_REGS; reg_num++)begin
        used_regs_clears: assert property (@ (posedge clk) $rose(inuse_regs_n[reg_num]) |=> s_eventually $fell(inuse_regs_n[reg_num])) else $error($sformatf("Used GPR %0d Never Clears After Being Used", reg_num));
    end

    busy_regs_become_ready: assert property (@ (posedge clk)  ($countones(regs_busy) == 1) |-> s_eventually $rose(operands_ready_r)) else $error($sformatf("Busy Regs Never Became Ready"));

endmodule

module VX_operands_assert(input clk, 
                         input  logic has_collision,
                         VX_scoreboard_if.slave  scoreboard_if,
                         VX_operands_if.master   operands_if
                        );


    collision_clears : assert property ( @ (posedge clk) $rose(has_collision) ##1 has_collision |-> ##[0:3] $fell(has_collision) and (##[1:5] $rose(operands_if.valid)) ) else $error("Bank Conflict Never Gets Cleared");
    operands_valid   : assert property ( @ (posedge clk) $rose(scoreboard_if.valid) |-> ##[1:5] $rose(operands_if.valid)) else $error("Operands Did Not Become Valid After Scoreboard Became Valid");

endmodule