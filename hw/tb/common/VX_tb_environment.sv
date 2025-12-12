import VX_tb_common_pkg::*;
import VX_sched_pkg::*;
import VX_gpr_pkg::*;
import VX_scoreboard_pkg::*;

class VX_tb_environment extends uvm_env;

    `uvm_component_utils(VX_tb_environment)

    VX_risc_v_agent      risc_v_agent;
    VX_sched_agent       sched_agent;
    VX_gpr_agent         gpr_agent;
    VX_scoreboard_agent  scoreboard_agent;

    VX_warp_ctl_scbd     warp_ctl_scbd;
    VX_scoreboard_scbd   scoreboard_scbd;
    //VX_risc_v_scbd     risc_v_scbd;
     
    function new(string name="VX_tb_environment", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        risc_v_agent     = VX_risc_v_agent::type_id::create("VX_risc_v_agent", this);
        sched_agent      = VX_sched_agent::type_id::create("VX_sched_agent", this);
        gpr_agent        = VX_gpr_agent::type_id::create("VX_gpr_agent", this);
        scoreboard_agent = VX_scoreboard_agent::type_id::create("VX_scoreboard_agent", this);

        warp_ctl_scbd    = VX_warp_ctl_scbd::type_id::create("VX_warp_ctl_scbd", this);
        scoreboard_scbd  = VX_scoreboard_scbd::type_id::create("VX_scoreboard_scbd", this);
        //risc_v_scbd  = VX_risc_v_scbd::type_id::create("VX_risc_v_scbd", this);
    endfunction

    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        //Warp_Ctl_Scbd
        risc_v_agent.risc_v_driver.instr_analysis_port.connect(warp_ctl_scbd.receive_riscv_instr);
        sched_agent.sched_monitor.sched_info_analysis_port.connect(warp_ctl_scbd.receive_sched_info);
        
        for(int bank_num=0; bank_num  < `NUM_GPR_BANKS; bank_num++) begin
            gpr_agent.gpr_monitor.gpr_info_analysis_port[bank_num].connect(warp_ctl_scbd.gpr_tb_fifo.analysis_export);
        end

        //Scoreboard_Scbd
        for(int issue_slice=0; issue_slice < `ISSUE_WIDTH; issue_slice++)begin
            scoreboard_agent.scoreboard_monitor.scoreboard_info_analysis_port[issue_slice].connect(scoreboard_scbd.scoreboard_info_fifo.analysis_export);
            scoreboard_agent.scoreboard_monitor.writeback_info_analysis_port[issue_slice].connect(scoreboard_scbd.writeback_info_fifo.analysis_export);
        end
    endfunction
    
endclass