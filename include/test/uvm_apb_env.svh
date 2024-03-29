
`ifndef __UVM_APB_ENV_SVH__
`define __UVM_APB_ENV_SVH__


class uvm_apb_env extends uvm_env;
  `uvm_component_utils(uvm_apb_env)

  uvm_reset_agent                                                    reset_agent            ;

  uvm_apb_master_agent  #(apb_parameter)                             apb_master_agent       ;
  uvm_apb_slave_agent   #(apb_parameter)                             apb_slave_agent        ;
                                                                                            
  uvm_apb_scoreboard                                                 scoreboard             ;

  uvm_tlm_analysis_fifo #(uvm_apb_sequence_item#(apb_parameter))     apb_slave_analysis_fifo;


  function new(string name="uvm_apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    reset_agent      = uvm_reset_agent                     ::type_id::create("reset_agent",      this);
    
    apb_master_agent = uvm_apb_master_agent#(apb_parameter)::type_id::create("apb_master_agent", this);
    apb_slave_agent  = uvm_apb_slave_agent #(apb_parameter)::type_id::create("apb_slave_agent",  this);
   
    scoreboard       = uvm_apb_scoreboard::type_id::create("scoreboard", this);
    
    apb_slave_analysis_fifo = new("apb_slave_analysis_fifo",  this); 
    
    // store analysis_fifo in the uvm_config_db
    uvm_config_db#(uvm_tlm_analysis_fifo#(uvm_apb_sequence_item#(apb_parameter)))::set(null, "", "apb_slave_analysis_fifo", apb_slave_analysis_fifo);
    
  endfunction: build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

//  apb_master_agent.driver.drv2sb_port.connect(scoreboard.drv2sb_port);

    reset_agent     .monitor.analysis_port.connect(scoreboard.analysis_imp_from_reset_monitor);

    apb_master_agent.monitor.analysis_port.connect(scoreboard.analysis_imp_from_apb_master_agent);
    apb_slave_agent .monitor.analysis_port.connect(scoreboard.analysis_imp_from_apb_slave_agent);

    apb_slave_agent.request_monitor.analysis_port.connect(apb_slave_analysis_fifo.analysis_export);

  endfunction: connect_phase


endclass : uvm_apb_env

`endif
