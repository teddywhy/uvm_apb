
`ifndef __UVM_APB_ENV_SVH__
`define __UVM_APB_ENV_SVH__

class uvm_apb_env extends uvm_env;

  `uvm_component_utils(uvm_apb_env)

  uvm_apb_master_agent #(PM)   apb_master_agent ;
  uvm_apb_slave_agent  #(PM)   apb_slave_agent  ;
    
  function new(string name="uvm_apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction : new
    

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    apb_master_agent = uvm_apb_master_agent::type_id::create("apb_master_agent", this);
    apb_slave_agent  = uvm_apb_slave_agent ::type_id::create("apb_slave_agent",  this);
      
  endfunction: build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

  endfunction: connect_phase

    
endclass : uvm_apb_env

`endif