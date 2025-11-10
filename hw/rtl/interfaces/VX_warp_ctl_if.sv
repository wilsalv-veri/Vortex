// Copyright © 2019-2023
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`include "VX_define.vh"

interface VX_warp_ctl_if import VX_gpu_pkg::*; ();

    wire        valid;
    wire [NW_WIDTH-1:0] wid;
    wire tmc_t       tmc; 
    wire wspawn_t    wspawn; 
    wire split_t     split; 
    wire join_t      sjoin; 
    wire barrier_t   barrier; 

    wire [NW_WIDTH-1:0] dvstack_wid;
    wire [DV_STACK_SIZEW-1:0] dvstack_ptr;

    modport master (
        inout valid, 
        inout wid, 
        inout wspawn,
        inout tmc, 
        inout split, 
        inout sjoin, 
        inout barrier, 

        inout dvstack_wid, 
        input  dvstack_ptr
    );

    modport slave (
        input valid,
        input wid,
        input wspawn,
        input tmc,
        input split,
        input sjoin,
        input barrier,

        input dvstack_wid,
        inout dvstack_ptr 
    );

endinterface
