import VX_tb_common_pkg::*;
import VX_sched_pkg::*;
import VX_gpr_pkg::*;
import VX_issue_pkg::*;
import VX_execute_pkg::*;

class VX_tb_environment extends uvm_env;

    `uvm_component_utils(VX_tb_environment)

    VX_risc_v_agent      risc_v_agent;
    VX_sched_agent       sched_agent;
    VX_gpr_agent         gpr_agent;
    VX_issue_agent       issue_agent;
    VX_execute_agent     execute_agent;

    VX_warp_ctl_scbd     warp_ctl_scbd;
    VX_data_hazard_scbd  data_hazard_scbd;
    VX_operands_scbd     operands_scbd;
    VX_alu_scbd          alu_scbd;
    VX_lsu_scbd          lsu_scbd;
     
    function new(string name="VX_tb_environment", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        risc_v_agent     = VX_risc_v_agent::type_id::create("VX_risc_v_agent", this);
        sched_agent      = VX_sched_agent::type_id::create("VX_sched_agent", this);
        gpr_agent        = VX_gpr_agent::type_id::create("VX_gpr_agent", this);
        issue_agent      = VX_issue_agent::type_id::create("VX_issue_agent", this);
        execute_agent    = VX_execute_agent::type_id::create("VX_execute_agent", this);

        warp_ctl_scbd    = VX_warp_ctl_scbd::type_id::create("VX_warp_ctl_scbd", this);
        data_hazard_scbd = VX_data_hazard_scbd::type_id::create("VX_scoreboard_scbd", this);
        operands_scbd    = VX_operands_scbd::type_id::create("VX_operands_scbd", this);
        alu_scbd         = VX_alu_scbd::type_id::create("VX_alu_scbd", this);
        lsu_scbd         = VX_lsu_scbd::type_id::create("VX_lsu_scbd", this);
    endfunction

    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        //Warp_Ctl_Scbd
        risc_v_agent.risc_v_driver.instr_analysis_port.connect(warp_ctl_scbd.receive_riscv_instr);
        risc_v_agent.risc_v_driver.instr_analysis_port.connect(alu_scbd.receive_riscv_instr);
        risc_v_agent.risc_v_driver.instr_analysis_port.connect(lsu_scbd.receive_riscv_instr);
        
        sched_agent.sched_monitor.sched_info_analysis_port.connect(warp_ctl_scbd.receive_sched_info);

        for(int bank_num=0; bank_num  < `NUM_GPR_BANKS; bank_num++) begin
            gpr_agent.gpr_monitor.gpr_info_analysis_port[bank_num].connect(warp_ctl_scbd.gpr_tb_fifo.analysis_export);
            gpr_agent.gpr_monitor.gpr_info_analysis_port[bank_num].connect(operands_scbd.gpr_tb_fifo.analysis_export);
            gpr_agent.gpr_monitor.gpr_info_analysis_port[bank_num].connect(     alu_scbd.gpr_tb_fifo.analysis_export);
            gpr_agent.gpr_monitor.gpr_info_analysis_port[bank_num].connect(     lsu_scbd.gpr_tb_fifo.analysis_export);
        end

        //Issue Scbds
        for(int issue_slice=0; issue_slice < `ISSUE_WIDTH; issue_slice++)begin
            issue_agent.issue_monitor.scoreboard_info_analysis_port[issue_slice].connect(data_hazard_scbd.scoreboard_info_fifo.analysis_export);
            issue_agent.issue_monitor.writeback_info_analysis_port[issue_slice].connect(data_hazard_scbd.writeback_info_fifo.analysis_export);
            
            issue_agent.issue_monitor.scoreboard_info_analysis_port[issue_slice].connect(operands_scbd.scoreboard_info_fifo.analysis_export);
            issue_agent.issue_monitor.operands_info_analysis_port[issue_slice].connect(operands_scbd.operands_info_fifo.analysis_export);
        end

        execute_agent.execute_monitor.alu_analysis_port.connect(alu_scbd.receive_alu_info);
        execute_agent.execute_monitor.lsu_analysis_port.connect(lsu_scbd.receive_lsu_info);
        execute_agent.execute_monitor.commit_analysis_port.connect(lsu_scbd.receive_commit_info);
    endfunction
    
endclass