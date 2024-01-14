
class uvm_reset_agent 
extends uvm_agent;

  `uvm_component_param_utils(uvm_reset_agent)

  virtual reset_interface       vif       ;

  uvm_reset_sequencer           sequencer ;
  uvm_reset_driver              driver    ;
  uvm_reset_monitor             monitor   ;
  

  function new(string name="uvm_reset_agent", uvm_component parent);
    super.new(name, parent);                                    
  endfunction : new                                            

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual reset_interface)::get(this, "", "vif", vif))
       `uvm_fatal(get_name(), "Could not get the virtual interface handle from the config database.")
    else
       `uvm_info(get_name(), "Virtual Interface Handle Assignment from uvm_config_db is done!", UVM_LOW)

    monitor   = uvm_reset_monitor     ::type_id::create("monitor"  , this);
    driver    = uvm_reset_driver      ::type_id::create("driver"   , this);
    sequencer = uvm_reset_sequencer   ::type_id::create("sequencer", this);

//  if(get_is_active() == UVM_ACTIVE) 
//  begin
//  end 

  endfunction : build_phase 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    monitor.vif = vif ;
    driver .vif = vif ;

    driver.seq_item_port.connect(sequencer.seq_item_export); // connect sequence item ports of driver and sequencer 
     
  endfunction : connect_phase 

endclass: uvm_reset_agent
