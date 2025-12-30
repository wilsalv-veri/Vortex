class VX_split_join_rtg_seq extends VX_split_join_doa_seq;

    `uvm_object_utils(VX_split_join_rtg_seq)

    string message_id = "VX_SPLIT_JOIN_RTG_SEQ";

    function new(string name="VX_split_join_rtg_seq");
        super.new(name);
        ipdom_top_stack_reg = 0;

        if (!this.randomize())
            `VX_error(message_id, "Failed to randomize VX_split_join_rtg_seq")
        
    endfunction

    constraint split_join_rtg_c {

        unique {pred_reg,ipdom_stack_ptr_reg,then_val_reg,else_val_reg,all_val_reg};
        unique {then_store_val,else_store_val,all_store_val};

        pred_val            inside {[1:15]};
        not_pred_val        dist {0:= 70, 1:=30};
        then_store_val      inside {[1:15]};
        else_store_val      inside {[1:15]};
        all_store_val       inside {[1:15]};

        pred_reg            inside {[2:RV_REGS - 1]};
        ipdom_stack_ptr_reg inside {[2:RV_REGS - 1]};
        then_val_reg        inside {[2:RV_REGS - 1]};
        else_val_reg        inside {[2:RV_REGS - 1]};
        all_val_reg         inside {[2:RV_REGS - 1]};

        ipdom_top_stack_reg == ipdom_stack_ptr_reg;
    }

endclass