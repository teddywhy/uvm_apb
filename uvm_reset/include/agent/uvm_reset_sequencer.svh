
class uvm_reset_sequencer 
extends uvm_sequencer #
(
   uvm_reset_sequence_item 
);

   `uvm_component_param_utils (uvm_reset_sequencer )
      
   function new(string name="uvm_reset_sequencer", uvm_component parent);   
      super.new(name, parent); 
   endfunction
  
   function void start_of_simulation_phase(uvm_phase phase);
      `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
   endfunction : start_of_simulation_phase

endclass : uvm_reset_sequencer
