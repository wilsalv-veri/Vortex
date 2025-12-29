# Vortex SIMT Core – Validation Plan

## 1. Purpose

This document defines the **validation plan** for the Vortex SIMT GPGPU core verification effort. It captures the *verification intent, scope boundaries, assumptions, and completion criteria* used to guide and evaluate the work.

The purpose of this document is to communicate **what is being validated, why those areas matter, and how validation completeness is judged** at an architectural level. It is not intended to be a task-tracking or work-management artifact.

---

## 2. Design Under Test Overview

The design under test is a **6-stage RISC-V SIMT execution pipeline** derived from the Vortex GPGPU architecture. The core implements SIMT behavior through **extensions to the RISC-V ISA**, introducing special instructions to support warp control, divergence, synchronization, and inter-thread communication.

The architecture is highly configurable, allowing variation in:

* Number of SMs and execution resources
* Warp and thread counts
* Execution unit composition and dispatch structure
* Cache and memory-interface configuration

Verification focuses on the **execution-side microarchitecture**, assuming architecturally valid instructions are presented to the execution pipeline via the instruction cache interface.

Key execution components in scope include:

* Warp scheduling and control logic
* Divergence, split, and join mechanisms
* Operand collection and hazard handling
* Integer execution units and SIMT-visible execution behavior
* System-level SIMT mechanisms such as barriers and memory ordering fences

### SIMT ISA Extensions Overview

Vortex extends the base RISC-V ISA with a set of **SIMT-specific instructions** to support GPU-style execution semantics:

* `tmc`    – Thread mask control
* `pred`   – Predicate evaluation with thread mask update
* `wspawn` – Warp spawn and activation
* `split`  – Divergent control-flow split
* `join`   – Reconvergence of divergent paths
* `bar`    – Barrier synchronization across warps / SMs
* `tex`    – Texture-related operation (present architecturally but excluded from verification scope)

These instructions are non-standard RISC-V extensions and do not have a standalone architectural specification.

For this project, the **decoder implementation and surrounding RTL behavior serve as the primary reference for intended behavior**. Verification focuses on validating the *execution-side semantics and observable effects* of these instructions, including their impact on warp state, thread masks, scheduling decisions, synchronization, and architectural ordering.

---

## 3. Validation Scope

The validation effort targets correctness of **SIMT execution semantics**, with emphasis on behaviors that are architecturally complex, timing-sensitive, or prone to silent failure.

### In-Scope Areas

* Warp lifecycle management (activation, scheduling, termination)
* Divergence, split, and join semantics
* Lane masking and shuffle operations
* Data and control hazards within the execution pipeline
* Forward progress and deadlock avoidance
* SIMT-visible ordering guarantees (e.g., barriers, fences)

### Explicitly Out of Scope

The following areas are intentionally excluded to maintain a focused and achievable scope:

* Instruction fetch and decode logic
* Floating-point arithmetic semantics
* Texture control unit (TCU) behavior
* Full memory hierarchy correctness or cache-coherency signoff

These exclusions are deliberate and reflect conscious scope control rather than missing functionality.

---

## 4. Validation Objectives

The validation objectives are:

1. **Confirm correctness of SIMT control and execution behavior** under realistic execution scenarios
2. **Validate architectural intent** of warp scheduling, divergence, and synchronization mechanisms
3. **Detect corner-case failures** that may not manifest through simple directed instruction testing
4. **Build confidence in forward progress guarantees**, ensuring the core does not enter illegal or deadlocked states under valid execution

The objective is not exhaustive instruction coverage, but confidence that **architecturally meaningful execution states and transitions behave as intended**.

---

## 5. Key Risk Areas

The following areas are considered high risk and receive focused validation attention:

* Warp scheduling logic that can lead to starvation or deadlock
* Divergence and reconvergence paths that may silently violate SIMT semantics
* Shuffle and lane-bound operations with non-trivial masking behavior
* Single-warp and low-occupancy execution corner cases
* Temporal ordering guarantees across barriers and fences

These risks are informed by architectural complexity as well as issues uncovered during verification.

---

## 6. Verification Approach

Verification is implemented using a **UVM-based functional verification environment** designed around architectural observability and controllability.

Key aspects of the approach include:

* **Stimulus**: Directed and constrained-random sequences generate architecturally valid instruction streams. Sequences communicate instruction intent to the driver, which packages instructions into cacheline-aligned transactions, writes them into a memory BFM, and allows the core to fetch them through its instruction cache interface.

* **Checking**: Multiple domain-specific scoreboards track expected behavior for warp scheduling, execution results, and control-flow effects. Assertion-based checks are used to enforce temporal invariants and protocol-level rules.

* **Memory Interface Abstraction**: A memory BFM provides a deterministic interface for instruction and data access. It serves as a controllable boundary between stimulus and the DUT rather than a full system-level memory model.

The environment is structured to support incremental expansion from IP-level execution verification toward larger subsystem configurations without architectural redesign.

---

## 7. Coverage Intent

Coverage is used as a **qualitative feedback mechanism** rather than a sign-off metric.

Coverage intent includes:

* Exercising architecturally meaningful warp states and transitions
* Observing divergence and reconvergence under varied mask patterns
* Stressing hazard, stall, and scheduling conditions
* Exercising representative synchronization and ordering scenarios

Coverage items are defined per feature and reviewed alongside functional results to guide stimulus refinement.

---

## 8. Assumptions and Limitations

This validation effort assumes:

* The base RISC-V instruction semantics (encoding and high-level intent) are defined by the RISC-V specification
* Hardware-specific SIMT behavior beyond the base ISA (e.g., warp control, scheduling, synchronization, execution ordering) does not have a formal external specification
* Reset and configuration sequences place the core into a known-good state
* External system components (e.g., software stack, full memory hierarchy) are not required for correctness validation at this level

As a result, **verification correctness is established through engineering judgment applied consistently across the entire design**, rather than strict comparison against a complete architectural specification. Bugs identified during verification reflect deviations from inferred architectural intent, internal consistency, or expected SIMT execution semantics, rather than violations of a formally published spec.

---

## 9. Completion Criteria

Validation is considered complete when:

* All in-scope feature areas have been exercised with meaningful stimulus and checking
* No known functional correctness bugs remain open
* Identified risk areas have been explicitly addressed through testing or analysis

Completion is judged by **demonstrated confidence in SIMT execution correctness**, not by absolute coverage percentages.

---

## 10. Relationship to Other Artifacts

This document complements:

* Source code and inline documentation
* Bug reports and debug notes
* Coverage observations



