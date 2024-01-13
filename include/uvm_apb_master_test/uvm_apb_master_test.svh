

class uvm_apb_master_test extends uvm_test;

  `uvm_component_utils(uvm_apb_master_test)

  uvm_apb_master_env                            env      ;

  uvm_reset_sequence                            reset_sequence    ;

  uvm_apb_master_sequence_w   #(apb_parameter)  master_sequence_w ;
  uvm_apb_master_sequence_r   #(apb_parameter)  master_sequence_r ;    
                                                                            

  function new(string name = "uvm_apb_master_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     
     uvm_config_int::set(this, "*", "recording_detail", 1); // Enable Transaction Recording
     
     env   = uvm_apb_master_env::type_id::create("env", this);    

     reset_sequence    = uvm_reset_sequence                        ::type_id::create("reset_sequence"   , this);
     
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

    reset_sequence   .start(env.reset_agent.sequencer);

    // sequences        
    master_sequence_w.start(env.apb_master_agent.sequencer);
    master_sequence_r.start(env.apb_master_agent.sequencer);
    
    phase.drop_objection(this);
    
    `uvm_info(get_type_name, "End of testcase", UVM_LOW);
  endtask


endclass : uvm_apb_master_test  



// teddywhy@gmail.com

