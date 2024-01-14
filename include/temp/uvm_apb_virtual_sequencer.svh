`ifndef __UVM_APB_VIRTUAL_SEQUENCER_SVH__ 
`define __UVM_APB_VIRTUAL_SEQUENCER_SVH__ 


class uvm_apb_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(uvm_apb_virtual_sequencer)

  uvm_apb_master_sequencer #(apb_parameter) master_sequencer ;
  uvm_apb_slave_sequencer  #(apb_parameter) slave_sequencer  ;

  function new(string name = "uvm_apb_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass 

`endif
