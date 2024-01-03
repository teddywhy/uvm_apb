
//`ifndef __UVM_APB_MASTER_ENV_SVH__
//`define __UVM_APB_MASTER_ENV_SVH__


class uvm_apb_master_env extends uvm_env;

  `uvm_component_utils(uvm_apb_master_env)

//  parameter apb_parameter_t PM  = apb_parameter;

  uvm_apb_master_agent #(apb_parameter)   apb_master_agent;
  uvm_apb_master_scoreboard               scoreboard;

  function new(string name="uvm_apb_master_env", uvm_component parent);
    super.new(name, parent);
  endfunction : new


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    apb_master_agent = uvm_apb_master_agent#(apb_parameter)::type_id::create("apb_master_agent", this);
   
    scoreboard       = uvm_apb_master_scoreboard::type_id::create("scoreboard", this);
  endfunction: build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

//  apb_master_agent.driver.drv2sb_port.connect(scoreboard.drv2sb_port);

    apb_master_agent.monitor.analysisport.connect(scoreboard.analysis_imp_mon2sb);

  endfunction: connect_phase


endclass : uvm_apb_master_env

//`endif

// teddywhy@gmail.com
