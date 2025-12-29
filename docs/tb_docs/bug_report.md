# Bug Report
This document summarizes RTL logic issues and assertion findings identified during functional verification of the Vortex SIMT core. Issues are categorized to clearly distinguish functional RTL bugs from assertion robustness improvements.

## RTL Logic Findings
| Title               | BUG_ID  | File    |Description           | Proposed Fix               |
|--------------------|-------|-------|-----------|------------------|
| Undecoded System Instructions | BUGID1 | VX_decode.sv | System instructions (ECALL, EBREAK, URET, SRET, MRET) are treated as no-op operations by unconditionally advancing the PC by +4.  | For purposes of this project, modify EBREAK behavior to create an infinite loop by forcing PC + 0. |    
| Warp Deadlock Due to Single-Warp Condition | BUGID2 | VX_schedule.sv | The `is_single_warp` condition is evaluated early in warp spawn logic, which can cause a warp to remain locked and result in deadlock. | Continue updating `warp_pcs` under `is_single_warp`, but ensure the warp lock is released so the instruction becomes architecturally benign when invalid. |
| Incorrect Next PC After Divergent Split | BUGID3 | VX_schedule.sv | `JOIN_PC` is set to `SPLIT_PC + 4`, causing the join path to re-execute instructions under the then mask, effectively collapsing divergence behavior. | Remove PC manipulation during join. Instead, represent divergence explicitly in the instruction stream using structured SPLIT and JOIN operations. |
| Weak Divergent Join Detection Logic | BUGID4 | VX_split_join.sv | `sjoin_is_dvg` is derived from RS1 mismatching the current stack pointer, which allows false assertions under valid inputs. | Restrict divergence detection to the single architectural case requiring a pop operation; suppress assertion otherwise. |
| Incorrect MinLane/MaxLane Logic for Shuffle | BUGID5 | VX_alu_int.sv | MinLane/MaxLane computation only works for `[0 : maxThreadID]`. Subset ranges (e.g., `[1:2]`, `[1:3]`) produce incorrect behavior. | Derive MinLane from the instruction mask and MaxLane from the instruction `cVal` field. |
| Shuffle-Up Ignores MaxLane | BUGID6 | VX_alu_int.sv | Shuffle-up operations continue beyond the instruction-defined MaxLane and instead use the architectural max thread ID. | Clamp shuffle-up behavior to the instruction-defined MaxLane. |
| Shuffle-Down Ignores MinLane | BUGID7 | VX_alu_int.sv | Shuffle-down operations continue below the instruction-defined MinLane and instead reach lane 0. | Clamp shuffle-down behavior to the instruction-defined MinLane. |
| Shuffle-Butterfly Ignores MinLane | BUGID8 | VX_alu_int.sv | Shuffle-butterfly operations propagate below the instruction-defined MinLane. | Clamp shuffle-butterfly behavior to the instruction-defined MinLane. |
| Shuffle-Index Ignores MinLane | BUGID9 | VX_alu_int.sv | Shuffle-index allows access to lanes below the instruction-defined MinLane. | Prevent shuffle-index operations below the instruction-defined MinLane. |


## RTL Assertions Logic Findings
These findings reflect assertion logic deficiencies rather than functional RTL bugs.

| Title               | BUG_ID  | File    |Description           | Proposed Fix               |
|--------------------|-------|-------|-----------|------------------|
| Counter Overflow Assertion Fires Incorrectly | BUGID10 | VX_pending_size.sv | Overflow assertion does not account for full-condition gating and fires under valid scenarios. | Gate assertion with full indication and guard against X-values prior to reset. |
| Counter Underflow Assertion Fires Incorrectly | BUGID11 | VX_pending_size.sv | Underflow assertion does not account for empty-condition gating and fires under valid scenarios. | Gate assertion with empty indication and guard against X-values prior to reset. |


## RTL Assertions X-Propogation Findings
The following assertions fired due to X-propagation on control signals. These are classified as **false positives**.  
The proposed resolution is to explicitly guard assertions using X-checks on the listed signals.

| Assertion               | BUG_ID  | File    | Signal Name      |
|--------------------|-------|-------|------------------|
|missed mshr replay | BUGID12 | VX_cache_bank.sv | valid_st1  |
|inuse allocation | BUGID13 | VX_cache_mshr.sv | allocate_fire  |
|invalid release | BUGID14 | VX_cache_mshr.sv | finalize_valid  |
|invalid fill | BUGID15 | VX_cache_mshr.sv | fill_valid  |
| scheduler stall timeout | BUGID16 | VX_schedule.sv | timeout_ctr  |
|invalid request mask | BUGID17 | VX_mem_scheduler.sv | core_req_valid  |
|incrementing full queue | BUGID18 | VX_fifo_queue.sv | push  |
|decrementing empty queue | BUGID19 | VX_fifo_queue.sv | push  |
|scoreboard stall timeout | BUGID20 | VX_scoreboard.sv | timeout_ctr  |
|writing to a full stack | BUGID21 | VX_ipdom_stack.sv | push_s  |
|reading an empty stack | BUGID22 | VX_ipdom_stack.sv | pop_s  |
|push and pop in same cycle not supported | BUGID23 | VX_ipdom_stack.sv | push_s  |
|invalid request mask | BUGID24 | VX_mem_coalescer.sv | in_req_valid  |
|invalid request mask | BUGID25 | VX_mem_coalescer.sv | out_rsp_valid  |

