
`ifndef __UVM_APB_TEST_SVH__
`define __UVM_APB_TEST_SVH__

class uvm_apb_test extends uvm_test;

  `uvm_component_utils(uvm_apb_test)

  uvm_apb_env                                       env                     ;

  uvm_reset_sequence                                reset_sequence          ;

  uvm_apb_master_sequence_w       #(apb_parameter)  master_sequence_w       ;
  uvm_apb_master_sequence_r       #(apb_parameter)  master_sequence_r       ;

  uvm_apb_slave_response_sequence #(apb_parameter)  slave_response_sequence ;

  function new(string name = "uvm_apb_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     
     uvm_config_int::set(this, "*", "recording_detail", 1); // Enable Transaction Recording
     
     env                     = uvm_apb_env::type_id::create("env", this);    
     
     reset_sequence          = uvm_reset_sequence                              ::type_id::create("reset_sequence"         , this);
                             
     master_sequence_w       = uvm_apb_master_sequence_w       #(apb_parameter)::type_id::create("master_sequence_w"      , this);
     master_sequence_r       = uvm_apb_master_sequence_r       #(apb_parameter)::type_id::create("master_sequence_r"      , this);

     slave_response_sequence = uvm_apb_slave_response_sequence #(apb_parameter)::type_id::create("slave_response_sequence", this);

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

     reset_sequence.start(env.reset_agent.sequencer);

  	 slave_response_sequence.start(env.apb_slave_agent.sequencer);


     `uvm_info(get_type_name(), {"Start Master Sequences...", get_full_name()}, UVM_HIGH)
     master_sequence_w.start(env.apb_master_agent.sequencer);
     master_sequence_r.start(env.apb_master_agent.sequencer);

     phase.drop_objection(this);      
     
     `uvm_info(get_type_name, "End of testcase", UVM_LOW);
  endtask


endclass : uvm_apb_test  

`endif
