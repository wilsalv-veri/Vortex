`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class apb_txn extends uvm_sequence_item;
  
  rand int unsigned paddr;
  rand bit pwrite;
  rand int unsigned pwdata;
  rand int unsigned prdata;
  rand bit pslverr;
  rand bit pready;
  
  constraint addr_c { paddr < 32;}
  
  function new(string name="apb_txn");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(apb_txn)
  `uvm_field_int(paddr,   UVM_ALL_ON)
  `uvm_field_int(pwrite,  UVM_ALL_ON)
  `uvm_field_int(pwdata,  UVM_ALL_ON)
  `uvm_field_int(prdata,  UVM_ALL_ON)
  `uvm_field_int(pslverr, UVM_ALL_ON)
  `uvm_field_int(pready,  UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass

class apb_sequence extends uvm_sequence #(apb_txn);
  
  `uvm_object_utils(apb_sequence)
  
  apb_txn txn;
  rand int num_of_txns;
  
  
  constraint txns_c { num_of_txns inside {[5:10]}; }
  
  function new(string name="apb_sequence");
    super.new(name);
    
    if ( ! this.randomize())
      `uvm_error("APB_SEQUENCE", "Failed to randomize apb_sequence")
  endfunction
  
  task body();
  	  
    for(int txn_count=0; txn_count < num_of_txns; txn_count++)begin
      txn = apb_txn::type_id::create($sformatf("APB_TXN_%0d", txn_count));
      start_item(txn);
      assert(txn.randomize());
      `uvm_info("APB_SEQ", $sformatf("PADDR: 0x%0x PWRITE: 0x%0x PWDATA: 0x%0x", txn.paddr, txn.pwrite, txn.pwdata), UVM_NONE)
      finish_item(txn);
    end
    
  endtask
  
endclass

class apb_driver extends uvm_driver #(apb_txn);
  
  `uvm_component_utils(apb_driver)
  
  apb_txn txn;
  bit first_txn = 1'b1;
  virtual apb_if ifc;
  
  function new(string name="apb_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    txn = apb_txn::type_id::create("apb_driver_txn", this);
    
    if(! uvm_config_db #(virtual apb_if)::get(this, "", "ifc", ifc))
       `uvm_error("APB_DRIVER", "Failed to get access to apb_if")
       
  endfunction
       
  virtual task run_phase(uvm_phase phase);
  	super.run_phase(phase);
    ifc.presetn = 1;
    //`uvm_info("APB_DRIVER", "GOT HERE", UVM_NONE)
    
    forever @(posedge ifc.pclk)begin
      //`uvm_info("APB_DRIVER", "POSEDGE CLK", UVM_NONE)
      if (first_txn || ifc.pready)begin
      	first_txn   <= 1'b0;
        seq_item_port.get_next_item(txn);
        `uvm_info("APB_DRIVER", $sformatf("PADDR: 0x%0x PWRITE: 0x%0x PWDATA: 0x%0x", txn.paddr, txn.pwrite, txn.pwdata), UVM_NONE)
        ifc.psel    <= 1'b1;
        @ (posedge ifc.pclk);
        ifc.penable <= 1'b1;
      	ifc.paddr   <= txn.paddr;
      	ifc.pwrite  <= txn.pwrite;
      	ifc.pwdata <= txn.pwdata;
      	seq_item_port.item_done();
      end
    end
  endtask
  
endclass
  
class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)
  
  apb_txn txn;
  virtual apb_if ifc;
  uvm_analysis_port #(apb_txn) send;
  
  
  function new(string name="apb_monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    txn  = apb_txn::type_id::create("apb_monitor_txn");
    send = new("apb_analysis_port", this);
    
    if(! uvm_config_db #(virtual apb_if)::get(this, "", "ifc", ifc))
      `uvm_error("APB_MONITOR", "Failed to get access to apb_if")

  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever @(posedge ifc.pclk)begin
      if(ifc.pready)begin
        txn.paddr   = ifc.paddr;
        txn.pwrite  = ifc.pwrite;
        txn.pwdata  = ifc.pwdata;
        txn.prdata  = ifc.prdata;
        txn.pslverr = ifc.pslverr;
        `uvm_info("APB_MONITOR", $sformatf("PADDR: 0x%0x PWRITE: 0x%0x PWDATA: 0x%0x PRDATA: 0x%0x PSLVERR: 0x%0x", txn.paddr, txn.pwrite, txn.pwdata, txn.prdata, txn.pslverr), UVM_NONE)
  
        send.write(txn);
      end
    end
  endtask
  
endclass
    
class apb_scoreboard extends uvm_scoreboard;
	
  `uvm_component_utils(apb_scoreboard)
   
  `uvm_analysis_imp_decl(_apb_txn)
   uvm_analysis_imp_apb_txn #(apb_txn, apb_scoreboard) receive;
  
   apb_txn txn;
  
  function new(string name="apb_scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    txn     = apb_txn::type_id::create("apb_scoreboard_txn");
    receive = new("apb_analysis_imp", this);
  endfunction
  
  function void write_apb_txn(apb_txn txn);
    `uvm_info("APB_SCOREBOARD", $sformatf("PADDR: 0x%0x PWRITE: 0x%0x  PWDATA: 0x%0x PRDATA: 0x%0x PSLVERR: 0x%0x",  
                                          txn.paddr, txn.pwrite , txn.pwdata, txn.prdata, txn.pslverr), UVM_NONE)
    $display();
    
  endfunction
  
endclass
    
class apb_agent extends uvm_agent;

  `uvm_component_utils(apb_agent)
  
   apb_driver  apb_drv;
   apb_monitor apb_mon;
   uvm_sequencer #(apb_txn) seqr;
  
  function new(string name="apb_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    apb_drv = apb_driver::type_id::create("apb_driver", this);
    apb_mon = apb_monitor::type_id::create("apb_monitor", this);
    seqr    = uvm_sequencer #(apb_txn)::type_id::create("apb_sequencer", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass
    
class apb_environment extends uvm_env;

  
  `uvm_component_utils(apb_environment)
  
   apb_agent      apb_agnt;
   apb_scoreboard apb_scbd;
  
  function new(string name="apb_environment", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    apb_agnt = apb_agent::type_id::create("apb_agent", this);
    apb_scbd = apb_scoreboard::type_id::create("apb_scoreboard", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_agnt.apb_mon.send.connect(apb_scbd.receive);
  endfunction
  
endclass 
    
class apb_test extends uvm_test;
      
  `uvm_component_utils(apb_test)
  
   apb_environment apb_env;
   apb_sequence    apb_seq;
  
  function new(string name="apb_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    apb_env = apb_environment::type_id::create("apb_environment", this);
    apb_seq = apb_sequence::type_id::create("apb_sequence", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);
    apb_seq.start(apb_env.apb_agnt.seqr);
    phase.drop_objection(this);
  endtask
  
endclass


typedef struct {
  int age;
  int id;
} student_t;

module tb_top;
  
  apb_if ifc();
  apb_ram apb_inst(ifc.presetn, ifc.pclk, ifc.psel, ifc.penable, ifc.pwrite, ifc.paddr, ifc.pwdata, ifc.prdata, ifc.pready, ifc.pslverr);
  
  initial begin
    ifc.pclk    = 0;
    ifc.presetn = 0;
    forever #1 ifc.pclk = ~ ifc.pclk;
  end

  initial begin
    uvm_config_db #(virtual apb_if)::set(null, "*", "ifc", ifc);
    run_test("apb_test");
  end
  
  initial begin
    $display("TB_TOP running at time %0t", $time);
    $dumpfile("waves.vcd");
    $dumpvars(0, tb_top);
    #20
    $display("TB_TOP finished at time %0t", $time);
    $finish();
  end

endmodule