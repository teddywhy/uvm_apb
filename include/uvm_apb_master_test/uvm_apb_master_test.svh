
`ifndef __UVM_APB_MASTER_TEST_SVH__
`define __UVM_APB_MASTER_TEST_SVH__

class uvm_apb_master_test extends uvm_test;

  `uvm_component_utils(uvm_apb_master_test)

  uvm_apb_master_env                            master_env        ;

  uvm_apb_master_sequence_w   #(apb_parameter)  master_sequence_w ;
  uvm_apb_master_sequence_r   #(apb_parameter)  master_sequence_r ;    
                                                                            

  function new(string name = "uvm_apb_master_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     
     uvm_config_int::set(this, "*", "recording_detail", 1); // Enable Transaction Recording
     
     master_env   = uvm_apb_master_env::type_id::create("apb_master_env", this);    
     
     master_sequence_w = uvm_apb_master_sequence_w #(apb_parameter)::type_id::create("master_sequence_w", this);
     master_sequence_r = uvm_apb_master_sequence_r #(apb_parameter)::type_id::create("master_sequence_r", this);

  endfunction

  virtual function void end_of_elaboration_phase (uvm_phase phase);
     uvm_top.print_topology();
  endfunction

  function void check_phase(uvm_phase phase);
     check_config_usage();
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);        
  
    phase.raise_objection(this);

    // sequences        
    master_sequence_w.start(master_env.apb_master_agent.sequencer);
    master_sequence_r.start(master_env.apb_master_agent.sequencer);
    
    phase.drop_objection(this);
    
    `uvm_info(get_type_name, "End of testcase", UVM_LOW);
  endtask


endclass : uvm_apb_master_test  

`endif


// teddywhy@gmail.com

