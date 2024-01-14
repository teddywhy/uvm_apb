
class uvm_reset_sequence_item extends uvm_sequence_item;     


  rand int                          duration    ; 
  rand int                          delay       ; 
 
  `uvm_object_utils_begin (uvm_reset_sequence_item         )  
    `uvm_field_int        (duration           ,  UVM_ALL_ON)
    `uvm_field_int        (delay              ,  UVM_ALL_ON)    
  `uvm_object_utils_end

  function new (string name = "uvm_reset_sequence_item");
    super.new(name);
  endfunction : new

endclass : uvm_reset_sequence_item
