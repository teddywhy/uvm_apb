
// `ifndef __UVM_APB_MASTER_SEQUENCER_SVH__   
// `define __UVM_APB_MASTER_SEQUENCER_SVH__   

class uvm_apb_master_sequencer #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_sequencer #
(
   uvm_apb_sequence_item #(PM)
);

  `uvm_component_param_utils(uvm_apb_master_sequencer #(PM))

  function new(string name="uvm_apb_master_sequencer", uvm_component parent);   
    super.new(name, parent); 
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

endclass : uvm_apb_master_sequencer


// `endif
