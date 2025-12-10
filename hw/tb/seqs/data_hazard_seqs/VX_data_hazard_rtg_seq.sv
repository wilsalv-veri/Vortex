class VX_data_hazard_rtg_seq extends VX_data_hazard_base_seq;

    `uvm_object_utils(VX_data_hazard_rtg_seq)

    function new(string name="VX_data_hazard_rtg_seq");
        super.new(name);
        this.message_id = "VX_DATA_HAZARD_RTG_SEQ";

        if (! this.randomize())
            `VX_error(message_id, "Failed to randomize VX_data_hazard_rtg_seq")
        else begin
            `VX_info(message_id,$sformatf("Data Hazard Selected : %0s", this.data_hazard_type.name))
            `VX_info(message_id, $sformatf("Hazard_Reg1: %0d Hazard_Reg2: %0d Hazard_Reg3: %0d Hazard_Reg4: %0d", 
            this.hazard_reg1,this.hazard_reg2,this.hazard_reg3,this.hazard_reg4))
            `VX_info(message_id, $sformatf("SRC1: %0d SRC2: %0d RD: %0d", this.src1_reg, this.src2_reg, this.dst_reg))
        end
    endfunction

    constraint data_hazard_c {
        solve hazard_reg3      before hazard_reg4;
        solve hazard_reg4      before src1_reg,src2_reg,dst_reg;

        hazard_reg1 inside {[1:RV_REGS]};
        hazard_reg3 inside {[1:RV_REGS]};
        hazard_reg1 != hazard_reg3;
       
        if (data_hazard_type == RAW) {
            hazard_reg2 == hazard_reg1;
            hazard_reg4 == hazard_reg3;
            !(dst_reg   inside {hazard_reg2,hazard_reg2});
            dst_reg     inside {[1:RV_REGS]};
            
            if (src_hazard){
                src1_reg    == hazard_reg2;
                src2_reg    == hazard_reg4;
            }
            else {
                src1_reg    == hazard_reg4;
                src2_reg    == hazard_reg2;
            }
        }
        else if (data_hazard_type == WAW) {
            hazard_reg2 == hazard_reg1;
            hazard_reg4 == hazard_reg3;
            
            src1_reg    == hazard_reg2;
            src2_reg    == hazard_reg2;
            dst_reg     == hazard_reg4;
        }
        else if (data_hazard_type == WAR) {
            hazard_reg2 inside {[1:RV_REGS]};
            hazard_reg4 inside {[1:RV_REGS]};

            hazard_reg3 == hazard_reg2;
            hazard_reg4 != hazard_reg3;
            
            src1_reg inside {[1:RV_REGS]};
            src2_reg inside {[1:RV_REGS]};
            
            src1_reg   == 0;
            src2_reg   == 0;
            dst_reg    == hazard_reg3;
        }
    }
    
endclass