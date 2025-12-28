# Vortex Verification Environment Setup and Usage Guide
This document describes how to set up the simulation environment and run tests for the Vortex verification environment using the Altair DSIM simulator.

--- 

## 1. Download Altair DSIM Simulator
1. Create an Altair user account to gain access to Altair tools and software
   Registration Link:
   https://admin.altairone.com/register
2. Download the Altair DSIM Simulator from:
    https://altair.com/dsim 
3. Follow Altair's installation instructions to install DSIM on your system

---

## 2. Obtain Altair DSIM License
Altair offers 2 types of DSIM licenses:
- **Cloud-based license**
- **Local single-seat license**

During the development of this project, a **free local single-seat license** was used.
> **Note:**
> If using a cloud license, the environment variable `ALTAIR_LICENSE_PATH` must be set instead of `DSIM_LICENSE`.

Steps to obtain a license
1. Login to the Altair DSim Cloud using your Altair account:
   https://app.metricsvcloud.com/
2. Navigate to the **licenses** section, under your profile
   https://app.metricsvcloud.com/security/licenses
3. Generate and download the license file

---

## 3. Set Env Variables
1. Open the following file using your preferred text editor:
   /verif/scripts/dsim_env.sh
2. Set the following environment variables
    - `DSIM_LICENSE` - Path to the DSIM license file
    - `DSIM`         - Path to DSIM installation 
    - `VORTEX`       - Path to the Vortex repository root

---

## 4. Source DSIM Environment
From the Vortex repository root directory, source the DSIM environment:
```bash 
 source /verif/scripts/dsim_env.sh
```
---

## 5. Compile Shared DPI Library
Use the provided Makefile to compile the shared DPI library
From the Vortex repository root directory:
> **Note:**
> g++ will be required for this step. If not installed, please do so now
```bash
  cd dpi
  make all
```
> **Note:**
> An output/ directory will be created containing compilation logs.

---

## 6. Compile RTL, Testbench, and DPI Library
Compile the full environment using the provided helper script:
```bash
    compile_vortex
```

## 7. Run Test
Run any test using the following command:
```bash
    run_vortex Test_Name
```
---

## 8. Test List

### Warp Control Tests
-  `VX_bar_doa_test`
-  `VX_bar_test`
-  `VX_branch_doa_test`
-  `VX_branch_test`
-  `VX_pred_doa_test`
-  `VX_pred_test`
-  `VX_read_from_empty_ipdom_test`
-  `VX_split_join_doa_test`
-  `VX_split_join_test`
-  `VX_non_dvg_join_test`
-  `VX_tmc_doa_test`
-  `VX_tmc_test`
-  `VX_wspawn_doa_test`
-  `VX_wspawn_test`
-  `VX_wspawn_twice_test`

### Data Hazard Tests
- `VX_data_hazard_base_test`
- `VX_data_hazard_rtg_test`

### Execute Tests
- `VX_arithmetic_doa_test`
- `VX_arithmetic_rtg_test`
- `VX_arithmetic_simd_test`
- `VX_arithmetic_imm_doa_test`
- `VX_arithmetic_imm_rtg_test`
- `VX_arithmetic_imm_simd_test`
- `VX_load_imm_doa_test`
- `VX_load_imm_rtg_test`
- `VX_store_imm_doa_test`
- `VX_store_imm_rtg_test`
- `VX_vote_doa_test`
- `VX_vote_rtg_test`
- `VX_shfl_doa_test`
- `VX_shfl_rtg_test`
- `VX_fence_doa_test`