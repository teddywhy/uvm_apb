`ifndef __UVM_APB_VIRTUAL_SEQUENCE_SVH__
`define __UVM_APB_VIRTUAL_SEQUENCE_SVH__

class uvm_apb_virtual_sequence extends uvm_sequence ;

  `uvm_object_utils(uvm_apb_virtual_sequence)

  `uvm_declare_p_sequencer(uvm_apb_virtual_sequencer)

   uvm_apb_master_sequence_r #(apb_parameter) apb_master_sequence_r ;
   uvm_apb_master_sequence_w #(apb_parameter) apb_master_sequence_w ;


  function new(string name = "uvm_apb_virtual_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "virtual_sequence: body()", UVM_LOW);
    
    `uvm_do_on      (apb_master_sequence_r, p_sequencer.uvm_apb_master_sequencer) 
    `uvm_do_on      (apb_master_sequence_w, p_sequencer.uvm_apb_master_sequencer) 

  endtask

endclass

`endif

//
// `uvm_do_on      (sequence, p_sequencer.sequencer) 
// `uvm_do_on_with (sequence, p_sequencer.sequencer, constraints)
// `uvm_do         (sequence)
//