// `ifndef __UVM_APB_SLAVE_AGENT_SVH__
// `define __UVM_APB_SLAVE_AGENT_SVH__

class uvm_apb_slave_agent #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_agent;

  `uvm_component_param_utils(uvm_apb_slave_agent#(PM))

  virtual apb_interface      #(PM)   vif                ;
                                                        
  uvm_apb_slave_sequencer    #(PM)   sequencer          ;
  uvm_apb_slave_driver       #(PM)   driver             ;
  uvm_apb_monitor            #(PM)   monitor            ;
  uvm_apb_request_monitor    #(PM)   request_monitor    ;

  function new(string name="uvm_apb_slave_agent", uvm_component parent);
    super.new(name, parent);                                    
  endfunction : new                                            

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual apb_interface#(PM))::get(this, "", "vif", vif))
       `uvm_fatal(get_name(), "Could not get the virtual interface handle from the config database.")
    else
       `uvm_info(get_name(), "Virtual Interface Handle Assignment from uvm_config_db is done!", UVM_LOW)

    monitor            = uvm_apb_monitor         #(PM)  ::type_id::create("monitor"         , this);
    driver             = uvm_apb_slave_driver    #(PM)  ::type_id::create("driver"          , this);
    sequencer          = uvm_apb_slave_sequencer #(PM)  ::type_id::create("sequencer"       , this);
    request_monitor    = uvm_apb_request_monitor #(PM)  ::type_id::create("request_monitor" , this);
    
//  if(get_is_active() == UVM_ACTIVE) 
//  begin
//  end 

  endfunction : build_phase 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    request_monitor.vif = vif ;
    monitor        .vif = vif ;
    driver         .vif = vif ;

    driver.seq_item_port.connect(sequencer.seq_item_export); // connect sequence item ports of driver and sequencer 
    
//  request_monitor.analysis_port.connect(sequencer.analysis_fifo.analysis_export);
    
  endfunction : connect_phase 

endclass: uvm_apb_slave_agent


// `endif

