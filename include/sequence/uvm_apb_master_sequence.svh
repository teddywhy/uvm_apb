
class uvm_apb_master_sequence #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_sequence#(uvm_apb_sequence_item#(PM), uvm_apb_sequence_item#(PM));
   
   `uvm_object_utils(uvm_apb_master_sequence)
    
   function new(string name="uvm_apb_master_sequence");
       super.new(name);
   endfunction : new
   
   virtual task body();
         
   endtask : body
    
endclass : uvm_apb_master_sequence


// teddywhy@gmail.com
