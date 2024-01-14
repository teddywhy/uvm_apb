
class uvm_reset_sequence extends uvm_sequence#(uvm_reset_sequence_item, uvm_reset_sequence_item);
   
   `uvm_object_utils(uvm_reset_sequence)
    
   function new(string name="uvm_reset_sequence");
       super.new(name);
   endfunction : new
   
   virtual task body();
      `uvm_do_with(req, {req.delay==3; req.duration==5;})   
   endtask : body
    
endclass : uvm_reset_sequence


// teddywhy@gmail.com
