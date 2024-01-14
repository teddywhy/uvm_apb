


class uvm_apb_master_env extends uvm_env;

  `uvm_component_utils(uvm_apb_master_env)

//  parameter apb_parameter_t PM  = apb_parameter;

  uvm_reset_agent                                                    reset_agent            ;

  uvm_apb_master_agent #(apb_parameter)   apb_master_agent;
  uvm_apb_master_scoreboard               scoreboard;

  function new(string name="uvm_apb_master_env", uvm_component parent);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    reset_agent      = uvm_reset_agent                     ::type_id::create("reset_agent",      this);
    
    apb_master_agent = uvm_apb_master_agent#(apb_parameter)::type_id::create("apb_master_agent", this);
   
    scoreboard       = uvm_apb_master_scoreboard::type_id::create("scoreboard", this);
  endfunction: build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    reset_agent     .monitor.analysis_port.connect(scoreboard.analysis_imp_from_reset_monitor);

    apb_master_agent.monitor.analysis_port.connect(scoreboard.analysis_imp_from_apb_master_agent);

  endfunction: connect_phase


endclass : uvm_apb_master_env



// teddywhy@gmail.com
