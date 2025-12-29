# Vortex GPGPU SIMT Core - Verification Environment
UVM-based functional verification of a 6-stage RISC-V SIMT core pipeline, with focus on warp scheduling, data hazards, operand collection, execution units, and system-level SIMT mechanisms such as cross-SM barriers and memory ordering fences.

This project uses the original Vortex architecture and RTL strictly as the design under test. All other components of the upstream Vortex repository; including the software stack, testing framework, and integration harness, are intentionally excluded.

The **goal** is to develop a scalable, reusable IP-level verification environment capable of validating realistic SIMT execution behavior and supporting incremental integration into larger GPU subsystems.

The **environment** is structured to reflect production-quality UVM practices, including modular agents, constrained-random stimulus, functional coverage, and assertion-based checking.

The **verification architecture** is intentionally modular, enabling straightforward scaling from IP-level verification to subsystem-level integration without requiring structural redesign.

---

## Out of Scope
- **Instruction Fetch and Decode:**
Front-end logic, including instruction fetch, decode, and associated control flow, is excluded from verification. The environment assumes architecturally valid instructions are presented to the execution pipeline, allowing verification to focus on downstream SIMT behavior.

- **Floating-Point Unit (FPU):**
Floating-point execution is intentionally excluded to avoid expanding the verification scope into floating-point–specific semantics and corner cases, allowing the effort to remain focused on SIMT execution control, scheduling, and architectural ordering behavior. The environment is structured such that FPU verification could be added later as an independent execution cluster.

- **Texture Control Unit (TCU):**
The Vortex texture unit and associated memory access paths are excluded. This avoids coupling execution-centric verification with texture-specific functionality, which is orthogonal to the goals of this project.

---

## Verification Strategy
The verification strategy decomposes SIMT execution risk into independent architectural concerns, enabling focused validation while preserving end-to-end correctness.

- **Stimulus** generation combines directed and constrained-random sequences targeting specific SIMT features. A custom RISC-V instruction generator produces architecturally valid instruction streams, expressed as instruction queues to precisely control dependencies, ordering, and warp-level interactions.

- **Checking** is distributed across multiple domain-specific scoreboards (e.g., warp scheduling, execution behavior), complemented by assertion-based checks for time-dependent invariants and protocol guarantees.

- A **memory BFM** acts as an L2-like interface between sequences and the DUT, allowing the driver to enqueue memory transactions and providing deterministic responses to core requests. This abstraction enables flexible stimulus delivery and verification of memory-related behaviors without requiring an actual memory subsystem.

- **Functional coverage** is intent-driven and used to measure exploration of warp states, scheduling decisions, hazards, and execution outcomes. Coverage results guide stimulus refinement rather than serving as a purely quantitative metric.

The environment is modular by construction, allowing verification scope to scale from IP-level execution blocks to subsystem-level integration through configuration and composition. It is designed to evolve incrementally as additional execution clusters or system-level features are brought into scope.

---

## Architecture

### Verification Configuration (Instantiated Blocks)
- 2 SM cores
- Per-core instruction cache
- Per-core data cache
- L1 cache arbiter
- Memory BFM acting as an L2 cache interface

### Core Configuration
- 4 warps
- 4 threads per warp
- 1 issue slice
- Per-execute unit dispatch
- 4 execute units (ALU, LSU, FPU, STU)
- Per-thread execution lanes in each execute unit

Refer to [`docs/rtl_docs/microarchitecture.md`](docs/rtl_docs/microarchitecture.md) and [`docs/rtl_docs/assets/vortex_microarchitecture.png`](docs/rtl_docs/assets/vortex_microarchitecture.png) for full micro-architectural details

---

## Repository Structure
- `/rtl`        : Snapshot of Vortex RTL used for verification
- `/dpi`        : DPI dependencies for FPU and MUL/DIV functions
- `/tb`         : Top-level testbench + UVM environment (agents, env, scoreboards)
- `/tests`      : Directed and constrained-random tests
- `/docs`       : Testplan, bug reports, coverage notes
- `/output`     : Compilation logs
- `/test_runs`  : Test execution logs

---

## Quick Start
### Pre-Requisites:
- `Altair DSIM (software)`
- `Altair DSIM License`
- `g++`

### Build and Run:
1. Compile the DPI shared library
2. Compile RTL, testbench, and DPI library
3. Run tests

Refer to [`/docs/tb_docs/setup.md`](/docs/tb_docs/setup.md) for detailed setup and usage instructions 

---

## Vortex Repository

This project is based on a fork of the original Vortex repository:
https://github.com/vortexgpgpu/vortex
