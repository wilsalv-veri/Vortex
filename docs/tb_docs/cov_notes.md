# Coverage Notes

This project used functional coverage as a feedback mechanism to guide stimulus refinement and confirm that key SIMT execution scenarios were being exercised.

---

## Scheduling / Warp Control

Coverage in the scheduling domain was used to confirm that the test suite exercised a representative mix of SIMT control behaviors, including:
- Warp control activity (spawn, mask/predicate updates, divergence, reconvergence)
- Barrier participation under different occupancy conditions
- Branch outcomes across different warps

How it influenced stimulus:
- When coverage showed execution consistently anchored to Warp 0, an additional sequence was introduced to explicitly spawn and schedule warps from non-zero warp IDs.
- When IPDOM stack depth coverage never reached a full condition, a targeted sequence was added to construct nested divergence scenarios that drive the stack to its maximum depth.
- When barrier-related coverage indicated only local synchronization behavior, existing sequences and constraints were updated to exercise a mix of both local and global barrier scenarios.

---

## Issue / Operand Collection Coverage

Issue-stage coverage was used to confirm that instruction issue and operand handling logic was exercised across a representative set of dependency and contention scenarios.

Coverage in this domain focused on:
- Source operand availability patterns (single-source vs multi-source dependencies)
- Scoreboard busy conditions reflecting different combinations of operand usage
- Operand collector collision behavior when multiple instructions contend for source operands
- General-purpose register access patterns, including read/write activity and partial-lane updates

---

## Execute Coverage

Execute-domain coverage was used to confirm breadth across common execution classes and to catch “missing shapes” of activity that constrained-random stimulus can overlook.

### ALU and Branch Behavior

Coverage tracked broad classes of integer execution and branch behavior, including:
- Arithmetic and immediate forms (e.g., signed vs unsigned, add/sub patterns)
- Special SIMT-style ALU operations (e.g., shuffle and vote groups)
- Branch diversity (different branch types and taken/not-taken outcomes)

How it influenced stimulus:
- When branch coverage showed limited diversity across operand sign combinations, constraints were updated to exercise all sign-mix permutations.

### LSU and Fences

LSU coverage focused on basic access diversity and ordering-related activity, including:
- Different access sizes (byte, half, word)
- Fence request/response activity and lock behavior